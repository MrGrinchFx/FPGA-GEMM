module RAMOUTPUT_2(
    input clk,
    input write_enable,
    input [5:0] addr_1,
    input [5:0] addr_2,
    input signed [18:0] mdi_1,
    input signed [18:0] mdi_2
);
    reg signed [18:0] mem [63:0];
    always @ (posedge clk) begin
        if (write_enable) begin
            mem[addr_1] <= mdi_1; // write mem
            mem[addr_2] <= mdi_2; // write mem
            $display("RAMOUTPUT: Writing %d to addr %d | Writing %d to addr %d", mdi_1, addr_1, mdi_2, addr_2);
        end
    end
endmodule
