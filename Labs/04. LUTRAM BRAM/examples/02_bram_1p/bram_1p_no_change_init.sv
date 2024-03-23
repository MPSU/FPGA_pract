module bram_1p_no_change_init
#(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10,
  parameter INIT_FILE     = ""
)
(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_i,
  input  logic [RAM_WIDTH-1:0]     data_i,
  input  logic                     we_i,
  input  logic                     en_i,
  output logic [RAM_WIDTH-1:0]     data_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] data_out_ff;

  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, bram, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          bram[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always_ff @(posedge clk_i) begin
    if (en_i) begin
      if (we_i)
        bram[addr_i] <= data_i;
      else
        data_out_ff  <= bram[addr_i];
    end
  end

  assign data_o = data_out_ff;

endmodule
