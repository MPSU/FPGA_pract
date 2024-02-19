module demo_wrapper_nexys_a7 (
  input  logic        CLK100MHZ,
  input  logic        BTNR,
  input  logic [15:0] SW,
  output logic [15:0] LED
);


  demo demo_inst (
    .clk_i (CLK100MHZ),
    .rst_i (BTNR),
    .sw_i  (SW),
    .led_o (LED)
  );

endmodule
