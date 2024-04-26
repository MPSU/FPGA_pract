module fifo_ready_valid_tb;

localparam int CLK_TIME = 5;
localparam int CYCLE    = 2*CLK_TIME;

parameter int DATA_WIDTH = 4;
parameter int DEPTH = 10;


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
  .clk_i        ( clk_i   ),
  .rst_i        ( rst_i   ),
  .write_data_i ( data_i  ),
  .valid_i      ( valid_i ),
  .ready_o      ( ready_o ),
  .ready_i      ( ready_i ),
  .valid_o      ( valid_o ),
  .read_data_o  ( data_o  )
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
  ready_i <= 1'b0;
  valid_i <= 1'b0;
  #CYCLE;
  for(int i = 0;i<DEPTH+10;i++)begin
    if(ready_o)
      wr_fifo();
    else
      #CYCLE;
  end
  #CYCLE;
  forever begin
    fork
      wr_fifo();
      rd_fifo();
    join
  end
end


task automatic wr_fifo();
  @(posedge clk_i)
    data_i  <= $urandom_range(2**DATA_WIDTH-1, 0);
    valid_i <= 1'b1;
  #CLK_TIME;@(posedge clk_i)
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
