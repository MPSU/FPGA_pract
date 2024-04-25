
module credit_counter_tb;

  // Parameters
  localparam int DEPTH = 10;

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
    #10; rst_i = 1'b0;
  end

  initial begin                                                       // clk_i and rst_i
    clk_i = 1'b1;
    forever begin
     clk_i = ~clk_i; #5;
    end
  end

  initial begin
    pop     <= 1'b0;
    valid_i <= 1'b0;
    #20;
    for(int i = 0; i < 20; i++)begin
      if(ready_cred)
        tsk1();#5;
    end
    for(int i = 0; i < DEPTH-5; i++)begin
      tsk2();#5;
    end
    for(int i = 0; i < DEPTH; i++)begin
      tsk2();#5;
      tsk3();#5;
    end
  end

  task tsk1();
    @(posedge clk_i)
      valid_i <= 1'b1;
    #5;@(posedge clk_i)
      valid_i <= 1'b0;
  endtask

  task tsk2();
    @(posedge clk_i)
      pop <= 1'b1;
    #5;@(posedge clk_i)
      pop <= 1'b0;
  endtask
  task tsk3();
    @(posedge clk_i)
      pop <= 1'b1;
      valid_i <= 1'b1;
    #5;@(posedge clk_i)
      valid_i <= 1'b0;
      pop <= 1'b0;
  endtask
endmodule
