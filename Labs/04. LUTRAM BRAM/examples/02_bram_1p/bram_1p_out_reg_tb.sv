// в модуле сначало идет заполнение памяти fill_data()
//                            затем чтение requset_read()  3 раза
//                            затем запись requset_write() 3 раза

module bram_1p_out_reg_tb();

  localparam int RAM_WIDTH     = 16;
  localparam int RAM_ADDR_BITS = 3;
  localparam int RAM_DEPTH     = 2**RAM_ADDR_BITS;

  logic                           clk_i;
  logic                           rst_i;
  logic [ RAM_ADDR_BITS - 1 : 0 ] addr_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_i;
  logic [ RAM_WIDTH     - 1 : 0 ] data_o;
  logic                           we_i;
  logic                           reg_en_i;
  logic                           en_i;

  bram_1p_out_reg # (
    .RAM_WIDTH     ( RAM_WIDTH     ),
    .RAM_ADDR_BITS ( RAM_ADDR_BITS )
  )
  bram_1p_out_reg_inst (
    .clk_i    ( clk_i    ),
    .rst_i    ( rst_i    ),
    .addr_i   ( addr_i   ),
    .reg_en_i ( reg_en_i ),
    .we_i     ( we_i     ),
    .en_i     ( en_i     ),
    .data_i   ( data_i   ),
    .data_o   ( data_o   )
  );
//------------------------------------------------- clk_i and rst_i
initial begin
  clk_i = 1'b0;
  forever begin
    clk_i = ~clk_i; #5;
  end
end
initial begin
  rst_i = 1'b1;
  #10;
  rst_i = 1'b0;
end
//------------------------------------------------- WRITE MODULE
int p;
event end_of_fill;

initial begin
  #10;
  p = 0;
  we_i = '0;

  repeat(RAM_DEPTH)begin// заполнение памяти
    fill_data(); #5;
    p = p + 1;
  end

  ->end_of_fill;
  wait(end_of_read.triggered)// ждем окончания чтения

  #10;                  // запись в память
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
    en_i   = '1;
    addr_i = p;
    data_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    en_i = '0;
    we_i = '0;
endtask

task requset_write();
  @(posedge clk_i)
    addr_i = $urandom_range(0, RAM_DEPTH - 1);
    we_i   = '1;
    en_i   = '1;
    data_i = $urandom_range(0, 2**RAM_WIDTH - 1);
  #5; @(posedge clk_i)
    en_i = '0;
    we_i = '0;
endtask
//------------------------------------------------- READ MODULE
event end_of_read;
initial begin
  wait(end_of_fill.triggered) // ждем окончания заполнения памяти
  #10;                        // чтение из памяти
  requset_read();
  #10;
  requset_read();
  #10;
  requset_read();
  #10;
  ->end_of_read;
end

task requset_read();
  @(posedge clk_i)
    en_i     = 1'b1;
    addr_i = $urandom_range(0, RAM_DEPTH - 1);
  #5; @(posedge clk_i);
    en_i     = 1'b0;
  #15; @(posedge clk_i);
    reg_en_i = 1'b1;
  #5; @(posedge clk_i);
    reg_en_i = 1'b0;
endtask

endmodule
