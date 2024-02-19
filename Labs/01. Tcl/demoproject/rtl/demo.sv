module demo
#(parameter TIMER_TICK = 20000000)

 (input  logic        clk_i,
  input  logic        rst_i,
  input  logic [15:0] sw_i,
  output logic [15:0] led_o
  );

  logic [31:0] clk_timer_ff;

  logic timer_tick;
  assign timer_tick = (clk_timer_ff == TIMER_TICK);

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
      clk_timer_ff <= 32'd0;
    else begin
      if(timer_tick)
        clk_timer_ff <= 32'd0;
      else
        clk_timer_ff <= clk_timer_ff + 1;
    end
  end


  logic [15:0] led_reg_ff;

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      led_reg_ff <= 16'b1000_0000_0000_0000;
    end
    else
      if (timer_tick)
        led_reg_ff <= {led_reg_ff[0], led_reg_ff[15:1]};
  end

  assign led_o = sw_i ^ led_reg_ff;

endmodule
