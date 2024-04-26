module fifo_ready_valid_tb;

  // Parameters
  parameter int DATA_WIDTH = 4;
  parameter int DEPTH = 10;

  //Ports
  logic                      clk_i;
  logic                      rst_i;

  logic                      ready_o;
  logic                      ready_i;

  logic                      valid_i;
  logic                      valid_o;

  logic [DATA_WIDTH - 1 : 0] data_i;
  logic [DATA_WIDTH - 1 : 0] data_o;

  fifo_ready_valid # (
    .DATA_WIDTH( DATA_WIDTH ),
    .DEPTH     ( DEPTH      )
  )
  fifo_ready_valid_inst (
    .clk_i  ( clk_i     ),
    .rst_i  ( rst_i     ),
    .data_i ( data_i  ),
    .valid_i( valid_i ),
    .ready_o( ready_o ),
    .ready_i( ready_i ),
    .valid_o( valid_o ),
    .data_o ( data_o  )
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
    ready_i <= 1'b0;
    valid_i <= 1'b0;
    #20;
    for(int i = 0;i<DEPTH+10;i++)begin
      if(ready_o)
        wr_fifo();
      else
        #10;
    end
    #20;
    forever begin
      fork
        wr_fifo();
        rd_fifo();
      join
    end
  end


task automatic wr_fifo();
  if(ready_o)begin
  @(posedge clk_i)
    data_i  <= $urandom_range(2**DATA_WIDTH-1, 0);
    valid_i <= 1'b1;
  #5;@(posedge clk_i)
    valid_i <= 1'b0;
  end else
    valid_i <= 1'b0;
endtask

task automatic rd_fifo();
  if(valid_o)
    @(posedge clk_i)
    ready_i <= 1'b1;
  else
    @(posedge clk_i)
    ready_i <= 1'b0;
endtask

initial begin
  #200;
  $finish;
end

endmodule
