module mult_dsp_wrapper
#(
  parameter A_WIDTH = 25,
  parameter B_WIDTH = 18,
  parameter R_WIDTH = A_WIDTH + B_WIDTH
)
(
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic [24:0] a_i,
  input  logic [17:0] b_i,
  output logic [42:0] res_o
);

  logic [24:0] a_ff;
  logic [17:0] b_ff;
  logic [42:0] res_ff;
  logic [42:0] res;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      a_ff <= '0;
      b_ff <= '0;
    end
    else begin
      a_ff <= a_i;
      b_ff <= b_i;
    end
  end

  mult_dsp
  #(
    .A_WIDTH (A_WIDTH),
    .B_WIDTH (B_WIDTH)
  )
    i_mult
  (
    .clk_i (clk_i),
    .rst_i (rst_i),
    .a_i   (a_ff),
    .b_i   (b_ff),
    .res_o (res)
  );

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      res_ff <= '0;
    else
      res_ff <= res;
  end

  assign res_o = res_ff;

endmodule
