// в модуле сначало идет заполнение памяти fill_data     ()
//                            затем чтение requset_read  () 3 раза
//                   затем чтение и запись read_and_write() 3 раза
//                     затем просто запись requset_write () 3 раза

module lutram_tb();


  localparam int RAM_WIDTH     = 16;
  localparam int RAM_ADDR_BITS = 3;
  localparam int RAM_DEPTH     = 2**RAM_ADDR_BITS;

  logic                           clk_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] waddr_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] raddr_i;
  logic [ RAM_WIDTH     - 1 : 0 ] wdata_i;
  logic [ RAM_WIDTH     - 1 : 0 ] rdata_o;
  logic                           we_i;

  lutram # (
    .RAM_WIDTH     ( RAM_WIDTH     ),
    .RAM_ADDR_BITS ( RAM_ADDR_BITS )
  )
  lutram_inst (
    .clk_i   ( clk_i   ),
    .wdata_i ( wdata_i ),
    .waddr_i ( waddr_i ),
    .we_i    ( we_i    ),
    .raddr_i ( raddr_i ),
    .rdata_o ( rdata_o )
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
  we_i = '0;

  repeat(RAM_DEPTH)begin// заполнение памяти
    fill_data(); #5;
    p = p + 1;
  end

  ->end_of_fill;
  wait(end_of_read_write.triggered)// ждем окончания чтения и записи

  #10;                // запись в память
  requset_write();
  #30;
  requset_write();
  #30;
  requset_write();
  #30;
  $finish;
end

task fill_data();
  @(posedge clk_i)
    we_i   = '1;
    waddr_i = p;
    wdata_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    we_i = '0;
endtask

task requset_write();
  @(posedge clk_i)
    waddr_i = $urandom_range(0, RAM_DEPTH - 1);
    we_i   = '1;
    wdata_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    we_i = '0;
endtask
//------------------------------------------------- READ MODULE
event end_of_read;
initial begin
  wait(end_of_fill.triggered) // ждем окончания заполнения памяти
  #10;                        // чтение из памяти
  requset_read();
  #30;
  requset_read();
  #30;
  requset_read();
  #30;
  ->end_of_read;
end

task requset_read();
  @(posedge clk_i);#2.5;
  raddr_i = $urandom_range(0, RAM_DEPTH - 1);
endtask
//------------------------------------------------- Read and write at the same time
event end_of_read_write;

initial begin
  wait(end_of_read.triggered)// ждем окончания чтения
  #10;                       // запись в память и чтение одновременно
  read_and_write();
  #30;
  read_and_write();
  #30;
  read_and_write();
  #30;
  ->end_of_read_write;
end

task read_and_write();
  @(posedge clk_i)
    waddr_i = $urandom_range(0, RAM_DEPTH - 1);
    raddr_i = $urandom_range(0, RAM_DEPTH - 1);
    wdata_i = $urandom_range(0, 2**RAM_WIDTH - 1);
    we_i    = '1;
  #5; @(posedge clk_i)
    we_i    = '0;
endtask
endmodule
