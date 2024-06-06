module wrapper_crc8
(
  input  logic        p_clk_i,
  input  logic        p_rstn_i,
  input  logic [31:0] p_dat_i,
  output logic [31:0] p_dat_o,
  input  logic        p_sel_i,
  input  logic        p_enable_i,
  input  logic        p_we_i,
  input  logic [31:0] p_adr_i,
  output logic        p_ready
);
