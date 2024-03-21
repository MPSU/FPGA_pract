
module bram_1p_byte_en_tb();

  localparam  NB_COL        = 2;
  localparam  COL_WIDTH     = 8;
  localparam  RAM_ADDR_BITS = 3;
  localparam  RAM_DEPTH     = 2**RAM_ADDR_BITS;

  logic                                clk_i;
  logic [ RAM_ADDR_BITS      - 1 : 0 ] addr_i;
  logic [ (NB_COL*COL_WIDTH) - 1 : 0 ] data_i;
  logic [ (NB_COL*COL_WIDTH) - 1 : 0 ] data_o;
  logic [  NB_COL            - 1 : 0 ] we_i;
  logic                                en_i;

  bram_1p_byte_en # (
    .NB_COL       ( NB_COL        ),
    .COL_WIDTH    ( COL_WIDTH     ),
    .RAM_ADDR_BITS( RAM_ADDR_BITS )
  )
  bram_1p_byte_en_inst (
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
int p;
event end_of_write;

initial begin
  #10;
  p = 0;
  we_i = '0;

  repeat(RAM_DEPTH)begin// заполнение памяти
    requset_write(); #5;
    p = p + 1;
  end

  ->end_of_write; 
  wait(end_of_reading.triggered)
  forever begin
    requset_replace_byte();
    #40;
  end
end

task requset_write();
  @(posedge clk_i)
    we_i   = '1;
    en_i   = '1;
    addr_i = p;
    data_i = $urandom_range(0, 2**(NB_COL*COL_WIDTH) - 1);
  #5; @(posedge clk_i)
    en_i = '0;
    we_i = '0;
endtask

int temp;
task requset_replace_byte();
  @(posedge clk_i)
    addr_i     = $urandom_range(0, RAM_DEPTH    );
    temp       = $urandom_range(0, NB_COL    - 1);
    we_i[temp] = '1;
    en_i       = '1;
    data_i     = $urandom_range(0, 2**(NB_COL*COL_WIDTH) - 1);
  #5; @(posedge clk_i)
    en_i = '0;
    we_i = '0;
endtask
//------------------------------------------------- READ MODULE
event end_of_reading;
initial begin
  wait(end_of_write.triggered)
  #10;
  requset_read();
  #30;
  requset_read();
  #30;
  ->end_of_reading;
end

task requset_read();
  @(posedge clk_i)
    en_i   = 1'b1;
    addr_i = $urandom_range(0, RAM_DEPTH - 1);
  #5; @(posedge clk_i);
    en_i   = 1'b0;
endtask

endmodule
