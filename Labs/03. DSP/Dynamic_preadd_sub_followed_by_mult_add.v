// This module describes a dynamic pre add/sub followed by multiplier, adder
// Make sure the widths are less than what is supported by the architecture

module dynamic_preadd#(
  parameter SIZEIN = 16
)(
  input clk,   // Clock input
  input ce,    // Clock enable
  input rst,   // Reset
  input subadd, // Dynamic subadd control

  input  signed [SIZEIN-1:0] a,
  input  signed [SIZEIN-1:0] b,
  input  signed [SIZEIN-1:0] c,
  input  signed [SIZEIN-1:0] d,  

  output wire signed [2*SIZEIN:0] dynpreaddmultadd_out // Output
);

  // Declare registers for intermediate values
  reg signed [SIZEIN-1:0] a_reg, b_reg, c_reg;
  reg signed [SIZEIN:0]   add_reg;
  reg signed [2*SIZEIN:0] d_reg, m_reg, p_reg;

  always @(posedge clk)
  begin
  if (rst)
    begin
    a_reg   <= 0;
    b_reg   <= 0;
    c_reg   <= 0;
    d_reg   <= 0;
    add_reg <= 0;
    m_reg   <= 0;
    p_reg   <= 0;
    end
  else if (ce)
    begin
    a_reg   <= a;
    b_reg   <= b;
    c_reg   <= c;
    d_reg   <= d;
    if (subadd)
      add_reg <= a - b;
    else
      add_reg <= a + b;
    m_reg   <= add_reg * c_reg;
    p_reg   <= m_reg + d_reg;
    end
  end

  // Output accumulation result
  assign dynpreaddmultadd_out = p_reg;
				
endmodule
				