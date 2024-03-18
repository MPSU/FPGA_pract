module lutram
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 5
)
(
  input  logic                     clk_i,
  input  logic [RAM_WIDTH-1:0]     wdata_i,
  input  logic [RAM_ADDR_BITS-1:0] waddr_i,
  input  logic                     we_i,

  input  logic [RAM_ADDR_BITS-1:0] raddr_i,
  output logic [RAM_WIDTH-1:0]     rdata_o
);

  (* ram_style="distributed" *)
  logic [RAM_WIDTH-1:0] lutram [(2**RAM_ADDR_BITS)-1:0];

  always_ff @(posedge clk_i) begin
    if (we_i)
      lutram[waddr_i] <= wdata_i;
  end

  assign rdata_o = lutram[raddr_i];

endmodule
