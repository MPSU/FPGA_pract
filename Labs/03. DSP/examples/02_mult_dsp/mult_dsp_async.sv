module mult_dsp_async(
  input  logic signed [24:0] a_i,
  input  logic signed [17:0] b_i,
  output logic signed [42:0] res_o
);

  assign res_o = a_ff * b_ff;

endmodule
