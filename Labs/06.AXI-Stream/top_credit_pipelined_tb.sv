
module top_credit_pipelined_tb;

localparam int CLK_TIME = 5;
localparam int CYCLE    = 2*CLK_TIME;

parameter int DATA_WIDTH = 3;
parameter int DEPTH      = 15;

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
  .DATA_WIDTH ( DATA_WIDTH ),
  .DEPTH      ( DEPTH      )
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
    clk_i = ~clk_i; #CLK_TIME;
  end
end

initial begin
  valid_i <= 1'b0;
  #20;

  for(int i = 0; i < DEPTH+10; i++)begin//writing data
    if(ready_o)begin
      wr_data();#CLK_TIME;
    end else
      #CYCLE;
  end

  for(int i = 0; i < DEPTH-5; i++)begin//reading data
    rd_data();#5;
  end
end

task wr_data();
  @(posedge clk_i)
    data_i  <= $urandom_range(2**DATA_WIDTH-1, 0);
    valid_i <= 1'b1;
  #CLK_TIME;@(posedge clk_i)
    valid_i <= 1'b0;
endtask

task rd_data();
  @(posedge clk_i)
    ready_i <= 1'b1;
  #CLK_TIME;@(posedge clk_i)
    ready_i <= 1'b0;
endtask

endmodule
