// This example shows how to infer Convergent Rounding (Odd) using pattern
// detect within DSP block (Width of the inputs should be within
// what can be supported by the DSP architecture)
module conv_rounding_odd(
  input  logic               clk_i,   // Clock
  input  logic        [23:0] a_i,     // First Input
  input  logic        [15:0] b_i,     // Second Input
  output logic signed [23:0] zlast_o  // Convergent Round Output
);

  logic signed [23:0] a_ff;
  logic signed [15:0] b_ff;
  logic signed [39:0] z1_ff;

  logic        pattern_detect_ff;
  logic [15:0] pattern;
  logic [39:0] c;

  assign pattern = 16'b1111111111111111;
  assign c = 40'b0000000000000000000000000111111111111111; // 15 ones

  logic signed [39:0] multadd;
  logic signed [15:0] zero;
  logic signed [39:0] multadd_ff;

  // Convergent Rounding: LSB Correction Technique
  // ---------------------------------------------
  // For static convergent rounding,  the pattern detector can be
  // used to detect  the midpoint case. For example,  in an 8-bit
  // round, if the decimal place is  set at 4, the C input should
  // be  set to  0000.0111.   Round to  odd  rounding should  use
  // CARRYIN =  "0" and  check for  PATTERN "XXXX.1111"  and then
  // replace  the  units place  bit  with  1  if the  pattern  is
  // matched. See UG193 for details

  assign multadd = z1_ff + c;

  always @(posedge clk_i)
    begin
      a_ff              <= a;
      b_ff              <= b;
      z1_ff             <= a_ff * b_ff;
      pattern_detect_ff <= multadd[15:0] == pattern ? 1'b1 : 1'b0;
      multadd_ff        <= multadd;
    end

  always @(posedge clk_i)
    zlast_o <= pattern_detect_ff ? {multadd_ff[39:17],1'b1} : multadd_ff[39:16];

endmodule
