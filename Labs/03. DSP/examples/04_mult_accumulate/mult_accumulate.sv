module mult_accumulate 
(
  input  logic               clk_i,
  input  logic               rst_i,
  input  logic signed [23:0] a_i,
  input  logic signed [17:0] b_i,
  input  logic               clear_i,
  output logic signed [42:0] res_o
);

  logic signed [23:0] a_ff;
  logic signed [17:0] b_ff;
  logic signed [42:0] res_ff;
  logic signed [42:0] mult;
  logic        [42:0] mac_res;

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

  assign mac_res = clear_i ? '0
                           : res_ff;

  always_ff @(posedge clk_i) begin
    if (rst_i)
      res_ff <= '0;
    else
      res_ff <= mac_res + mult;
  end

  assign res_o = res_ff;

endmodule
