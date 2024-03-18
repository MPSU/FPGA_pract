module pre_adder
(
  input  logic               clk_i,
  input  logic               rst_i,
  input  logic signed [23:0] a_i,
  input  logic signed [17:0] b_i,
  input  logic signed [23:0] c_i,
  output logic signed [42:0] res_o
);

  logic signed [23:0] a_ff;
  logic signed [17:0] b_ff;
  logic signed [23:0] c_ff;
  logic signed [42:0] res_ff;
  logic signed [42:0] mult;

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      a_ff <= '0;
      b_ff <= '0;
      c_ff <= '0;
    end
    else begin
      a_ff <= a_i;
      b_ff <= b_i;
      c_ff <= c_i;
    end
  end

  assign mult = (a_ff + c_ff) * b_ff;

  always_ff @(posedge clk_i) begin
    if (rst_i)
      res_ff <= '0;
    else
      res_ff <= mult;
  end

  assign res_o = res_ff;

endmodule
