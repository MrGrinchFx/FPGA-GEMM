module RAMOUTPUT(
    input clk,
    input write_enable,
    input [5:0] addr,
    input signed [18:0] mdi
);
    reg signed [18:0] mem [63:0];
    always @ (posedge clk) begin
        if (write_enable) begin
            mem[addr] <= mdi; // write mem
            $display("RAMOUTPUT: Writing %d to addr %d", mdi, addr);
        end
    end
endmodule
