module tb_demo ();

  logic        clk;
  logic        rst;
  logic [15:0] sw;
  logic [15:0] led;

  initial begin
    clk <= 1'b0;
    sw  <= 16'b0000_0000_0000_0000;
  end


  initial begin
    rst <= 1'b0;
    #1
    rst <= 1'b1;
    #50
    rst <= 1'b0;
  end


  always begin
    #10
    clk <= ~clk;
  end


  demo
  #(.TIMER_TICK(10))
   DUT
  (.clk_i  (clk),
   .rst_i  (rst),
   .sw_i   (sw),
   .led_o  (led));


endmodule
