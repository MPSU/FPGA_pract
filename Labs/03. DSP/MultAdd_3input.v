// This module describes a Multiplier,3 input adder (a*b + c + p(feedback))
// This can be packed into 1 DSP block (Ultrascale architecture)
// Make sure the widths are less than what is supported by the architecture

module multadd_3input#(
  parameter AWIDTH = 16,  // Width of multiplier's 1st input  
  parameter BWIDTH = 16,  // Width of multiplier's 2nd input
  parameter CWIDTH = 32,  // Width of Adder input
  parameter PWIDTH = 33   // Output Width
)(
  input clk,                     // Clock 
  input rst,                     // Reset

  input  signed [AWIDTH-1:0] a,  // Multiplier input
  input  signed [BWIDTH-1:0] b,  // Mutiplier input
  input  signed [CWIDTH-1:0] c,  // Adder input
  input                      ce, // Clock enable
  output signed [PWIDTH-1:0] p   // Output
);

  reg signed [AWIDTH-1:0] a_r;
  reg signed [BWIDTH-1:0] b_r;
  reg signed [CWIDTH-1:0] c_r;
  reg signed [PWIDTH-1:0] p_r;

  always @ (posedge clk)
  begin
  if(rst)
  begin
    a_r <= 0;
    b_r <= 0;
    c_r <= 0;
    p_r <= 0;
  end
  else
    begin
    if(ce)
    begin
      a_r <= a;
      b_r <= b;
      c_r <= c;
      p_r <= a_r * b_r + c_r + p_r; 
    end
    end
  end
  assign p = p_r;

endmodule
				
				