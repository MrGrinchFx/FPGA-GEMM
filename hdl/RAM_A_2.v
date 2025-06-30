module RAM_A_2(
    output reg signed [7:0] mdo_1,
    output reg signed [7:0] mdo_2,
    input clk,
    input [5:0] addr_1,
    input [5:0] addr_2
);
    reg signed [7:0] mem [63:0];

    initial begin
        $readmemb("C:\\Users\\2003k\\eec180\\eec180-lab6\\hdl\\ram_a_init.txt", mem);
    end

    always @ (posedge clk) begin
        mdo_1 <= mem[addr_1]; // read mem
        mdo_2 <= mem[addr_2];
    end
endmodule