module mult_compare
(
  input  logic               clk_i,
  input  logic               rst_i,
  input  logic signed [23:0] a_i,
  input  logic signed [17:0] b_i,
  output logic signed [42:0] res_o,
  output logic               match_o
);

  localparam signed [42:0] CMP = 1235678;

  logic signed [23:0] a_ff;
  logic signed [17:0] b_ff;
  logic signed [42:0] res_ff;
  logic signed [42:0] mult;
  logic               match_ff;

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

  always_ff @(posedge clk_i) begin
    if (rst_i)
      match_ff <= '0;
    else
      match_ff <= mult == CMP;
  end

  assign match_o = match_ff;
  assign res_o   = res_ff;

endmodule
