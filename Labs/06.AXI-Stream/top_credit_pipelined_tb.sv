
module top_credit_pipelined_tb;

  parameter int DATA_WIDTH = 3;

  logic                      clk_i;
  logic                      rst_i;
  // upstream
  logic [DATA_WIDTH - 1 : 0] data_i;
  logic                      valid_i;
  logic                      ready_o;
  // downstream
  logic                      valid_o;
  logic [DATA_WIDTH - 1 : 0] data_o;
  logic                      ready_i;

  top_credit_pipelined # (
    .DATA_WIDTH(DATA_WIDTH)
  )
  top_credit_pipelined_inst (
    .clk_i      ( clk_i   ),//
    .rst_i      ( rst_i   ),//
    .data_i     ( data_i  ),//
    .valid_i    ( valid_i ),//
    .ready_cred ( ready_o ),//
    .ready_i    ( ready_i ),
    .data_o     ( data_o  ),//
    .valid_o    ( valid_o )//
  );

  initial begin
    rst_i = 1'b1;
    #10; rst_i = 1'b0;
  end

  initial begin
    clk_i = 1'b1;
    forever begin
     clk_i = ~clk_i; #5;
    end
  end

  initial begin
    valid_i <= 1'b0;
    #20;
    for(int i = 0; i < 20; i++)begin
      if(ready_o)
        tsk1();#5;
    end
    // for(int i = 0; i < DEPTH-5; i++)begin
    //   tsk2();#5;
    // end
    // for(int i = 0; i < DEPTH; i++)begin
    //   tsk2();#5;
    //   tsk3();#5;
    // end
  end

  task tsk1();
    @(posedge clk_i)
      data_i  <= $urandom_range(2**DATA_WIDTH-1, 0);
      valid_i <= 1'b1;
    #5;@(posedge clk_i)
      valid_i <= 1'b0;
  endtask

endmodule
