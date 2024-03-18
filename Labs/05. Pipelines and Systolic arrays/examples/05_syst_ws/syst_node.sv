module syst_node
#(
  parameter W_WIDTH  = 8,
  parameter X_WIDTH  = 8,
  parameter SI_WIDTH = 8,
  parameter SO_WIDTH = 17
)
(
  input  logic                clk_i,
  input  logic                rst_i,
  input  logic [W_WIDTH -1:0] weight_i,
  input  logic [SI_WIDTH-1:0] psumm_i,
  input  logic [X_WIDTH -1:0] x_i,
  output logic [SO_WIDTH-1:0] psumm_o,
  output logic [X_WIDTH -1:0] x_o
);

  logic [X_WIDTH        -1:0] x_ff;
  logic [SO_WIDTH       -1:0] psumm_ff;
  logic [X_WIDTH+W_WIDTH-1:0] weight_mult;

  assign weight_mult = x_i * weight_i;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      psumm_ff <= '0;
    else
      psumm_ff <= psumm_i + weight_mult;
  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      x_ff <= '0;
    else
      x_ff <= x_i;
  end

  assign psumm_o = psumm_ff;
  assign x_o     = x_ff;

endmodule
