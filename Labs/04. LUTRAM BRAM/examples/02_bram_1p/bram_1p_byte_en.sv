module bram_1p_byte_en
#(
  parameter NB_COL = 4,
  parameter COL_WIDTH = 8,
  parameter RAM_ADDR_BITS = 10,
)
(
  input  logic                           clk_i,
  input  logic [RAM_ADDR_BITS-1:0]       addr_i,
  input  logic [(NB_COL*COL_WIDTH)-1:0]  data_i,
  input  logic [NB_COL-1:0]              we_i,
  input  logic                           en_i,

  output logic [(NB_COL*COL_WIDTH)-1:0]  data_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [(NB_COL*COL_WIDTH)-1:0] bram [RAM_DEPTH-1:0];
  logic [(NB_COL*COL_WIDTH)-1:0] read_data = {(NB_COL*COL_WIDTH){1'b0}};

  always @(posedge clk_i) begin
    if (en_i)
      read_data <= bram[addr_i];
  end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge clk_i)
         if (en_i)
           if (we_i[i])
             bram[addr_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= data_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  assign data_o = read_data;

endmodule
