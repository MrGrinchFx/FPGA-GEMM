module RAM_B_2(
    output reg signed [7:0] mdo,
    input clk,
    input [5:0] addr
);
    reg signed [7:0] mem [63:0];

    initial begin
        $readmemb("C:\\Users\\2003k\\eec180\\eec180-lab6\\hdl\\ram_b_init.txt", mem);
    end

    always @ (posedge clk) begin
        mdo <=  mem[addr]; // read mem
    end
endmodule