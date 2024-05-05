`timescale 1ns / 1ps

module wrapper_crc8
(
  input  logic        p_clk_i,
  input  logic        p_rst_i,
  input  logic [31:0] p_dat_i,
  output logic [31:0] p_dat_o,
  input  logic        p_sel_i,
  input  logic        p_enable_i,
  input  logic        p_we_i,
  input  logic [31:0] p_adr_i,
  output logic        p_ready,
  output logic        p_slverr
);

  logic [7:0] din_i;
  logic [7:0] crc_o;
  logic [1:0] state;
  logic       crc_rd;
  logic       data_valid_i;

  assign p_slverr = 1'b0;

  crc8
  i_crc8
  (
    .clk_i        (p_clk_i),
    .rst_i        (!p_rst_i),
    .din_i        (din_i),
    .data_valid_i (data_valid_i),
    .crc_rd       (crc_rd),
    .crc_o        (crc_o),
    .state        (state)
  );

  logic cs_1_ff;
  logic cs_2_ff;

  logic cs_ack1_ff;
  logic cs_ack2_ff;

  always_ff @ (posedge p_clk_i)
  begin
      cs_1_ff <= p_enable_i & p_sel_i;
      cs_2_ff <= cs_1_ff;
  end

  logic cs;
  assign cs = cs_1_ff & (~cs_2_ff);

  always_ff @ (posedge p_clk_i)
  begin
    cs_ack1_ff <= cs_2_ff;
    cs_ack2_ff <= cs_ack1_ff;
  end

  // Generating acknowledge signal
  logic p_ready_ff;

  always_ff @ (posedge p_clk_i)
  begin
    p_ready_ff <= (cs_ack1_ff & (~cs_ack2_ff));
  end

  assign p_ready = p_ready_ff;

  always_comb
  begin
    p_dat_o = '0;
    if (cs & (~p_we_i) & (p_adr_i[3:0] == 4'd4))
      p_dat_o = {24'd0, crc_o};
    else if (cs & (~p_we_i)& (p_adr_i[3:0] == 4'd8))
      p_dat_o = {24'd0, state};
  end

  assign data_valid_i = (cs & p_we_i & p_adr_i[3:0]  == 4'd0);
  assign din_i        = (cs & p_we_i & p_adr_i[3:0]  == 4'd0) ? p_dat_i[7:0]: 8'd0;
  assign crc_rd       = (cs & ~p_we_i & p_adr_i[3:0] == 4'd4);

endmodule
