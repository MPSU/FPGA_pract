
module credit_counter_tb;

// Parameters
localparam int CLK_TIME = 5;
localparam int CYCLE    = 2*CLK_TIME;

parameter int DEPTH = CYCLE;

//Ports
logic clk_i;
logic rst_i;
logic valid_i;
logic pop;
logic ready_cred;

credit_counter # (
  .DEPTH(DEPTH)
)
credit_counter_inst (
  .clk_i      ( clk_i      ),
  .rst_i      ( rst_i      ),
  .valid_i    ( valid_i    ),
  .pop        ( pop    ),
  .ready_cred ( ready_cred )
);

initial begin
  rst_i = 1'b1;
  #CYCLE; rst_i = 1'b0;
end

initial begin                                                       // clk_i and rst_i
  clk_i = 1'b1;
  forever begin
    clk_i = ~clk_i; #CLK_TIME;
  end
end

initial begin
  pop     <= 1'b0;
  valid_i <= 1'b0;
  #CYCLE;
  for(int i = 0; i < DEPTH+10; i++)begin
    if(ready_cred)
      tsk1();#CLK_TIME;
  end
  for(int i = 0; i < DEPTH+10; i++)begin
    if(i<DEPTH)
      tsk2();#CLK_TIME;
  end
end

task tsk1();
  @(posedge clk_i)
    valid_i <= 1'b1;
  #CLK_TIME;@(posedge clk_i)
    valid_i <= 1'b0;
endtask

task tsk2();
  @(posedge clk_i)
    pop <= 1'b1;
  #CLK_TIME;@(posedge clk_i)
    pop <= 1'b0;
endtask

endmodule
