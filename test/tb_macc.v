// Test bench module
module tb_macc;

// Input Array
/////////////////////////////////////////////////////////
//                  Test Bench Signals                 //
/////////////////////////////////////////////////////////

reg clk;

/////////////////////////////////////////////////////////
//                  I/O Declarations                   //
/////////////////////////////////////////////////////////
// declare variables to hold signals going into submodule
reg signed [7:0] inA, inB;
reg macc_clear;

// Output Signals
wire signed [18:0] macc_out;


/////////////////////////////////////////////////////////
//              Submodule Instantiation                //
/////////////////////////////////////////////////////////

/*****************************************
RENAME SIGNALS TO MATCH YOUR MODULE
******************************************/
mac DUT
(
    .clk        (clk),
    .macc_clear (macc_clear),
    .inA        (inA),
    .inB        (inB),
    .macc_out    (macc_out)
);

// Clock
always begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    // Initialize signals
    macc_clear = 1;
    inA = 0;
    inB = 0;
    
    // Wait for a few clock cycles
    #20;
    
    // Clear the MAC
    macc_clear = 1;
    #20;
    macc_clear = 0;
    
    // Apply first set of inputs
    inA = 8'd10;
    inB = 8'd3;
    #20;
    
    // Apply second set of inputs
    inA = 8'd5;
    inB = 8'd2;
    #20;
    
    // Apply third set of inputs
    inA = -8'd4;
    inB = 8'd1;
    #20;
    
    // Clear the MAC again
    macc_clear = 1;
    #20;
    macc_clear = 0;
    
    // Apply fourth set of inputs
    inA = 8'd7;
    inB = -8'd6;
    #20;
    
    // End simulation
    $stop;
end

endmodule
