// This code implements a parameterizable subtractor followed by multiplier which will be packed into DSP Block

module presub_with_mult#(
  parameter SIZEIN = 16  // Size of inputs
)(
  input  clk, // Clock
  input  ce,  // Clock enable
  input  rst, // Reset
  input  signed [SIZEIN-1:0] a,  // 1st Input to pre-subtractor
  input  signed [SIZEIN-1:0] b,  // 2nd input to pre-subtractor
  input  signed [SIZEIN-1:0] c,  // multiplier input
  output signed [2*SIZEIN:0] presubmult_out
);

  // Declare registers for intermediate values
  reg signed [SIZEIN-1:0] a_reg, b_reg, c_reg;
  reg signed [SIZEIN:0]   add_reg;
  reg signed [2*SIZEIN:0] m_reg, p_reg;

  always @(posedge clk)
  if (rst)
    begin
      a_reg   <= 0;
      b_reg   <= 0;
      c_reg   <= 0;
      add_reg <= 0;
      m_reg   <= 0;
      p_reg   <= 0;
    end
  else if (ce)
    begin
      a_reg   <= a;
      b_reg   <= b;
      c_reg   <= c;
      add_reg <= a - b;
      m_reg   <= add_reg * c_reg;
      p_reg   <= m_reg;
    end

  assign presubmult_out = p_reg;

endmodule
				
				