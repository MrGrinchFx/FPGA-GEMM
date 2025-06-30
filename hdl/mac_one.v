module mac_one(
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
        end else begin
            if (macc_out) begin
                macc_out <= macc_out + inA * inB;
            end
            else begin
                macc_out <= inA * inB;
            end
        end
    end
endmodule

