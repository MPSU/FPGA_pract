// в модуле сначало идет чтение requset_read()  3 раза
//                 затем запись requset_write() 3 раза

module bram_1p_no_change_init_tb();

  localparam int RAM_WIDTH     = 16;
  localparam int RAM_ADDR_BITS = 5;
  localparam int RAM_DEPTH     = 2**RAM_ADDR_BITS;
  localparam string INIT_FILE  = "bram_1p_no_change_memory.txt";

  logic                           clk_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] addr_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_o;
  logic                           we_i;
  logic                           en_i;

  bram_1p_no_change_init # (
    .RAM_WIDTH     ( RAM_WIDTH     ),
    .RAM_ADDR_BITS ( RAM_ADDR_BITS ),
    .INIT_FILE     ( INIT_FILE     )
  )
  bram_1p_no_change_init_inst (
    .clk_i  ( clk_i  ),
    .addr_i ( addr_i ),
    .we_i   ( we_i   ),
    .en_i   ( en_i   ),
    .data_i ( data_i ),
    .data_o ( data_o )
  );
//------------------------------------------------- clk_i
initial begin
  clk_i = 1'b0;
  forever begin
    clk_i = ~clk_i; #5;
  end
end
//------------------------------------------------- WRITE MODULE
initial begin
  #10;
  we_i = '0;

  wait(end_of_read.triggered) // ждем окончания чтения

  #10;                  // запись в память
  requset_write();
  #30;
  requset_write();
  #30;
  requset_write();

  $finish;
end

task requset_write();
  @(posedge clk_i)
    addr_i = $urandom_range(0, RAM_DEPTH - 1);
    we_i   = '1;
    en_i   = '1;
    data_i = $urandom_range(0, ((2**RAM_WIDTH) - 1));
  #5; @(posedge clk_i)
    en_i = '0;
    we_i = '0;
endtask
//------------------------------------------------- READ MODULE
event end_of_read;
initial begin
  #10;                            // чтение из памяти
  requset_read();
  #30;
  requset_read();
  #30;
  requset_read();
  #30;
  ->end_of_read;
end

task requset_read();
  @(posedge clk_i)
    en_i   = 1'b1;
    addr_i = $urandom_range(0, RAM_DEPTH - 1);
  #5; @(posedge clk_i);
    en_i   = 1'b0;
endtask

endmodule
