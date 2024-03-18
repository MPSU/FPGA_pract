module mult_dsp_async
#(
  parameter A_WIDTH = 25,
  parameter B_WIDTH = 18,
  parameter R_WIDTH = A_WIDTH + B_WIDTH
)
(
  input  logic signed [A_WIDTH-1:0] a_i,
  input  logic signed [B_WIDTH-1:0] b_i,
  output logic signed [R_WIDTH-1:0] res_o
);

  assign res_o = a_ff * b_ff;

endmodule
