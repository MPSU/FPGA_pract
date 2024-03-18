(* use_dsp = "no" *)
module mult_no_dsp
#(
  parameter A_WIDTH = 25,
  parameter B_WIDTH = 18,
  parameter R_WIDTH = A_WIDTH + B_WIDTH
)
(
  input  logic                      clk_i,
  input  logic                      rst_i,
  input  logic signed [A_WIDTH-1:0] a_i,
  input  logic signed [B_WIDTH-1:0] b_i,
  output logic signed [R_WIDTH-1:0] res_o

);

  logic signed [A_WIDTH-1:0] a_ff;
  logic signed [B_WIDTH-1:0] b_ff;
  logic signed [R_WIDTH-1:0] res_ff;
  logic signed [R_WIDTH-1:0] mult;

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      a_ff <= '0;
      b_ff <= '0;
    end
    else begin
      a_ff <= a_i;
      b_ff <= b_i;
    end
  end

  assign mult = a_ff * b_ff;

  always_ff @(posedge clk_i) begin
    if (rst_i)
      res_ff <= '0;
    else
      res_ff <= mult;
  end

  assign res_o = res_ff;

endmodule
