// в модуле сначало идет заполнение памяти fill_data     ()
//                            затем чтение requset_read  () 3 раза
//                   затем чтение и запись read_and_write() 3 раза
//                     затем просто запись requset_write () 3 раза

module bram_dp_simple_1clk_tb();
  localparam int RAM_WIDTH     = 16;
  localparam int RAM_ADDR_BITS = 3;
  localparam int RAM_DEPTH     = 2**RAM_ADDR_BITS;

  logic                           clk_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] addr_a_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] addr_b_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_a_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_b_o;
  logic                           we_a_i;
  logic                           en_b_i;

  bram_dp_simple_1clk # (
    .RAM_WIDTH     ( RAM_WIDTH     ),
    .RAM_ADDR_BITS ( RAM_ADDR_BITS )
  )
  bram_dp_simple_1clk_inst (
    .clk_i    ( clk_i    ),
    .addr_a_i ( addr_a_i ),
    .addr_b_i ( addr_b_i ),
    .data_a_i ( data_a_i ),
    .we_a_i   ( we_a_i   ),
    .en_b_i   ( en_b_i   ),
    .data_b_o ( data_b_o )
  );
//------------------------------------------------- clk_i
initial begin
  clk_i = 1'b0;
  forever begin
    clk_i = ~clk_i; #5;
  end
end
//------------------------------------------------- WRITE MODULE
int p;
event end_of_fill;

initial begin
  #10;
  p    = 0;
  we_a_i = '0;

  repeat(RAM_DEPTH)begin      // заполнение памяти
    fill_data(); #5;
    p = p + 1;
  end

  ->end_of_fill;
  wait(end_of_read_write.triggered)// ждем окончания чтения и записи
  #10;
  requset_write();                 // запись в память
  #30;
  requset_write();
  #30;
  requset_write();
  #30;
  $finish;
end

task fill_data();
  @(posedge clk_i)
    we_a_i   = '1;
    addr_a_i = p;
    data_a_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    we_a_i = '0;
endtask

task requset_write();
  @(posedge clk_i)
    addr_a_i = $urandom_range(0, RAM_DEPTH - 1);
    we_a_i   = '1;
    data_a_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    we_a_i = '0;
endtask
//------------------------------------------------- READ MODULE
event end_of_read;
initial begin
  wait(end_of_fill.triggered) // ждем окончания заполнения памяти
  #10;                        // чтение памяти
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
    en_b_i   = 1'b1;
    addr_b_i = $urandom_range(0, RAM_DEPTH - 1);
  #5; @(posedge clk_i);
    en_b_i   = 1'b0;
endtask
//------------------------------------------------- Read and write at the same time
event end_of_read_write;

initial begin
  wait(end_of_read.triggered) // ждем окончания чтения
  #10;
  read_and_write();           // чтение и запись одновременно
  #30;
  read_and_write();
  #30;
  read_and_write();
  #30;
  ->end_of_read_write;
end

task read_and_write();
  @(posedge clk_i)
    addr_a_i = $urandom_range(0, RAM_DEPTH - 1);
    addr_b_i = $urandom_range(0, RAM_DEPTH - 1);
    data_a_i = $urandom_range(0, 2**RAM_WIDTH - 1);
    we_a_i   = '1;
    en_b_i   = '1;
  #5; @(posedge clk_i)
    en_b_i = '0;
    we_a_i = '0;
endtask

endmodule
