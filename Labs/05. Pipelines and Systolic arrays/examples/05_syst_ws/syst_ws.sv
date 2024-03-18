module syst_ws
(
  input  logic clk_i,
  input  logic rst_i,

  input  logic [7:0] x1_i,
  input  logic [7:0] x2_i,
  input  logic [7:0] x3_i,

  output logic [18:0] y1_o,
  output logic [18:0] y2_o
);

  localparam W11 = 8'd2;
  localparam W12 = 8'd3;
  localparam W13 = 8'd4;
  localparam W21 = 8'd5;
  localparam W22 = 8'd6;
  localparam W23 = 8'd7;


  localparam W_WIDTH = 8;
  localparam X_WIDTH = 8;

  logic [7:0]  x1_pipe;
  logic [7:0]  x2_pipe;
  logic [7:0]  x3_pipe;
  logic [16:0] psumm11;
  logic [17:0] psumm12;
  logic [18:0] psumm13;
  logic [16:0] psumm21;
  logic [17:0] psumm22;
  logic [18:0] psumm23;

  syst_node #(
    .W_WIDTH  (8),
    .X_WIDTH  (8),
    .SI_WIDTH (1),
    .SO_WIDTH (17)
  ) node_11 (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .weight_i (W11),
    .psumm_i  ('0),
    .x_i      (x1_i),
    .psumm_o  (psumm11),
    .x_o      (x1_pipe)
  );


  syst_node #(
    .W_WIDTH  (8),
    .X_WIDTH  (8),
    .SI_WIDTH (17),
    .SO_WIDTH (18)
  ) node_12 (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .weight_i (W12),
    .psumm_i  (psumm11),
    .x_i      (x2_i),
    .psumm_o  (psumm12),
    .x_o      (x2_pipe)
  );

  // Exercise: Add nodes 13 and 23 to systolic array

  // syst_node #(
  //   .W_WIDTH  (8),
  //   .X_WIDTH  (8),
  //   .SI_WIDTH (18),
  //   .SO_WIDTH (19)
  // ) node_13 (
  //   .clk_i    (clk_i),
  //   .rst_i    (rst_i),
  //   .weight_i (),
  //   .psumm_i  (),
  //   .x_i      (),
  //   .psumm_o  (),
  //   .x_o      ()
  // );


  syst_node #(
    .W_WIDTH  (8),
    .X_WIDTH  (8),
    .SI_WIDTH (1),
    .SO_WIDTH (17)
  ) node_21 (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .weight_i (W21),
    .psumm_i  ('0),
    .x_i      (x1_pipe),
    .psumm_o  (psumm21),
    .x_o      ()
  );


  syst_node #(
    .W_WIDTH  (8),
    .X_WIDTH  (8),
    .SI_WIDTH (17),
    .SO_WIDTH (18)
  ) node_22 (
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .weight_i (W22),
    .psumm_i  (psumm21),
    .x_i      (x2_pipe),
    .psumm_o  (psumm22),
    .x_o      ()
  );

  // Exercise: Add nodes 13 and 23 to systolic array

  // syst_node #(
  //   .W_WIDTH  (8),
  //   .X_WIDTH  (8),
  //   .SI_WIDTH (18),
  //   .SO_WIDTH (19)
  // ) node_23 (
  //   .clk_i    (clk_i),
  //   .rst_i    (rst_i),
  //   .weight_i (),
  //   .psumm_i  (),
  //   .x_i      (),
  //   .psumm_o  (),
  //   .x_o      ()
  // );


  assign y1_o = psumm12;
  assign y2_o = psumm22;

endmodule
