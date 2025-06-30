module matrix_mult(
    output reg done,
    output reg [10:0] clock_count,
    input clk,
    input start,
    input reset
);
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    wire signed [7:0] inA_1;
    wire signed [7:0] inA_2;
    wire signed [7:0] inB;
    wire signed [18:0] macc_out_1;
    wire signed [18:0] macc_out_2;

    reg [1:0] wait_counter;
    reg [1:0] next_wait_counter;

    reg [6:0] addr_A_1 = 0;
    reg [6:0] addr_A_2 = 1;
    reg [6:0] addr_B_1 = 0;


    reg [6:0] addr_C= 0;
    
    

    reg [6:0] next_addr_A_1;
    reg [6:0] next_addr_A_2;
    reg [6:0] next_addr_B_1;
    reg [6:0] next_addr_C;

    reg [1:0] state = S0;
    reg [1:0] next_state;

    reg next_done;
    reg [10:0] next_clock_count;

    reg macc_clear_1 = 0;
    reg next_macc_clear_1;
    reg macc_clear_2 = 0;
    reg next_macc_clear_2;



    reg write_enable;
    reg next_write_enable;

    wire signed [18:0] value;

    reg [6:0] addr_A_row_offset;
    reg [6:0] addr_B_col_offset;
    reg [6:0] next_addr_A_row_offset;
    reg [6:0] next_addr_B_col_offset;
    integer i;
    RAM_A_2 RAM_A(
        .mdo_1(inA_1),
        .mdo_2(inA_2), // Correctly connect mdo as output
        .clk(clk),
        .addr_1(addr_A_1[5:0]),
        .addr_2(addr_A_2[5:0])
    );
    RAM_B_2 RAM_B(
        .mdo(inB),
        .clk(clk),
        .addr(addr_B_1[5:0])
    );

    RAMOUTPUT RAMOUTPUT(
        .clk(clk),
        .write_enable(write_enable),
        .addr(addr_C[5:0]),
        .mdi(value) //figure out how to toggle
    );
    buffer BUFFER(
        .value(value),
        .in1(macc_out_1),
        .in2(macc_out_2),
        .currAddr(addr_C)
    );
    mac MAC_1(
        .macc_out(macc_out_1),
        .inA(inA_1),
        .inB(inB),
        .macc_clear(macc_clear_1),
        .write(write_enable),
        .clk(clk)
    );

    mac MAC_2(
        .macc_out(macc_out_2),
        .inA(inA_2),
        .inB(inB),
        .macc_clear(macc_clear_2),
        .write(write_enable),
        .clk(clk)
    );
    


    always @(posedge clk) begin
        // Inputs to MAC and RAM A/B
        addr_A_1 <= next_addr_A_1;
        addr_B_1 <= next_addr_B_1;
        addr_A_2 <= next_addr_A_2;

        // Control and Outputs
        state <= next_state;
        done <= next_done;
        macc_clear_1 <= next_macc_clear_1;
        macc_clear_2 <= next_macc_clear_2;
        clock_count <= next_clock_count;

        // RAM C
        addr_C <= next_addr_C;
        write_enable <= next_write_enable;

        wait_counter <= next_wait_counter;
        // Offsets
        addr_A_row_offset <= next_addr_A_row_offset;
        addr_B_col_offset <= next_addr_B_col_offset;
    end

    always @(*) begin
        
        next_addr_A_1 = addr_A_1;
        next_addr_B_1 = addr_B_1;
        next_addr_A_2 = addr_A_2;
        next_state = state;
        next_done = done;
        next_macc_clear_1 = macc_clear_1;
        next_macc_clear_2 = macc_clear_2;

        next_clock_count = clock_count;

        next_addr_C = addr_C;
        next_write_enable = write_enable;
        next_wait_counter = wait_counter;
        next_addr_A_row_offset = addr_A_row_offset;
        next_addr_B_col_offset = addr_B_col_offset;
        $display("Addresses: A =%d | B =%d | C =%d | MAC = %d and %d | MAC Clear =%d | Input A =%d and %d | Input B =%d, Offset (row, col): (%d, %d)", addr_A_1, addr_B_1, addr_C, macc_out_1, macc_out_2, macc_clear_1, inA_1, inA_2, inB, addr_A_row_offset, addr_B_col_offset);
        case (state)
            S0: begin
                if (start) begin
                    next_addr_A_1 = 7'd8;
                    next_addr_B_1 = 7'd1;
                    next_addr_A_2 = 7'd9;
                    
                    next_done = 1'd0;
                    next_macc_clear_1 = 1'd0;
                    next_macc_clear_2 = 1'd0;
                    next_clock_count = 1'd0;

                    next_addr_C = 1'd0;
                    next_write_enable = 1'd0;
                    next_wait_counter = 2'd0;
                    next_addr_A_row_offset = 7'd0;
                    next_addr_B_col_offset = 7'd0;

                    next_state = S1;
                end else begin
                    next_macc_clear_1 = 1'd1;
                    next_macc_clear_2 = 1'd1;
                    next_state = S0;
                end
            end
            S1: begin
                // If end of matrix C (addr_C == 64)
                next_macc_clear_1 = 1'd0;
                next_macc_clear_2 = 1'd0;
                if (addr_C == 7'd64) begin
                    // Set done to 1/go to next state
                    next_done = 1'd1;
                    next_state = S2;
                end
                else begin
                    // If at end of column for matrix B
                    if ((addr_B_1 + 7'd1) % 7'd8 == 0) begin
                        if (wait_counter < 1) begin
                            next_wait_counter = wait_counter + 2'd1;
                            next_state = S1;
                        end
                        // If at end of column for matrix C (% 8)
                        //We want to write into C here
                        else begin
                            next_wait_counter = 2'd0;
                            next_write_enable = 1'd1;
                            next_state = S3;
                        end
                    end else begin
                        // Increment row index for matrix B
                        // Increment addr_B_1 by 1
                        next_addr_B_1 = addr_B_1 + 7'd1;
                        // Increment column index for matrix A
                        next_addr_A_1 = addr_A_1 + 7'd8;
                        next_addr_A_2 = addr_A_2 + 7'd8;
                    end
                end
                next_clock_count = clock_count + 11'd1;
            end
            S2: begin
                if (reset) begin
                    next_done = 1'd1;
                    next_macc_clear_1 = 1'd1;
                    next_macc_clear_2 = 1'd1;
                    next_state = S0;
                end else begin
                    next_state = S2;
                end
            end
            //writing state
            S3: begin
                // if (wait_counter < 1)begin
                //     next_wait_counter = wait_counter + 1;
                //     next_state = S3;
                // end
                // else begin

                if (wait_counter == 2'd0) begin
                    next_addr_C = addr_C + 7'd1;
                    next_wait_counter = wait_counter + 2'd1;
                    next_clock_count = clock_count + 11'd1;
                end
                else if(wait_counter == 2'd1) begin
                    next_write_enable = 1'd0;
                    next_macc_clear_1 = 1'd1;
                    next_macc_clear_2 = 1'd1;
                    //this means we need to reset both row and col
                    if((addr_C == (7'd7 + addr_B_col_offset * 7'd8)))begin
                        // Update B column offset and set next B address
                        next_addr_B_col_offset = 7'd1 + addr_B_col_offset;
                        next_addr_B_1 = (7'd1 + addr_B_col_offset) * 7'd8;
                        //update A row offset and set next A address
                        next_addr_A_row_offset = 7'd0;
                        next_addr_A_1 = 7'd0;
                        next_addr_A_2 = 7'd1;
                        // Increment addr_C by 1
                        next_addr_C = addr_C + 7'd1;
                    end
                    //reset just col and increment row
                    else if((addr_C != (7'd7 + addr_B_col_offset * 7'd8)))begin
                        next_addr_B_1 = addr_B_col_offset * 7'd8;
                        next_addr_A_row_offset = addr_A_row_offset + 7'd2;
                        next_addr_A_1 = addr_A_row_offset + 7'd2;
                        next_addr_A_2 = addr_A_row_offset + 7'd3;
                        next_addr_C = addr_C + 7'd1;
                    end
                    next_state = S1;
                    //end
                    next_wait_counter = 2'd0;
                    next_clock_count = clock_count + 11'd1;
                end
            end
        endcase
    end
endmodule