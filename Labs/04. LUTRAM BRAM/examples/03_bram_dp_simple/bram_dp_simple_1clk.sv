module bram_dp_simple_1clk
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)
(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_a_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_b_i,
  input  logic [RAM_WIDTH-1:0]     data_a_i,
  input  logic                     we_a_i,
  input  logic                     en_b_i,
  output logic [RAM_WIDTH-1:0]     data_b_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data_ff;

  always_ff @(posedge clk_i) begin
    if (we_a_i)
      bram[addr_a_i] <= data_a_i;
    if (en_b_i)
      ram_data_ff <= bram[addr_b_i];
  end

  assign data_b_o = ram_data_ff;

endmodule
