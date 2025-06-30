module mac(
    output reg signed [18:0] macc_out,
    input signed [7:0] inA,
    input signed [7:0] inB,
    input macc_clear,
    input write,
    input clk
);
    always @(posedge clk) begin
        if (macc_clear) begin
            macc_out <= inA * inB;
        end
        else if (write == 1) begin
            macc_out <= macc_out;
        end
        else if (inA) begin
            macc_out <= macc_out + inA * inB;
        end
        
    end

endmodule