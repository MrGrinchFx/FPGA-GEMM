module buffer(
    output reg signed [18:0] value,
    input signed [18:0] in1,
    input signed [18:0] in2,
    input [6:0] currAddr
    
);
    always @(*) begin
        if (currAddr % 2 == 0) begin
            value <= in1;
        end else if(currAddr % 2 == 1)begin
            value <= in2;
        end
    end
endmodule