module top_credit_pipelined #(
  parameter int DATA_WIDTH = 4,
  parameter int DEPTH      = 10
) (
  input  logic clk_i,
  input  logic rst_i,
  //upstream
  input  logic [DATA_WIDTH - 1 : 0] data_i,
  input  logic                      valid_i,
  output logic                      ready_cred,
  //downstream
  input  logic                      ready_i,
  output logic [DATA_WIDTH - 1 : 0] data_o,
  output logic                      valid_o
  );

  logic [5*DATA_WIDTH - 1 : 0] pow_data_o;
  logic                        pow_valid_o;

  pow5_pipelined_valid # (
    .DATA_WIDTH  (DATA_WIDTH)
  )
  pow5_pipelined_valid_inst (
    .clk_i        ( clk_i        ),
    .rst_i        ( rst_i        ),
    .pow_data_i   ( data_i       ),
    .data_valid_i ( pow_valid_i  ),
    .pow_data_o   ( pow_data_o   ),
    .data_valid_o ( pow_valid_o  )
  );

//  FIFO

  fifo_ready_valid # (
    .DATA_WIDTH( 5*DATA_WIDTH ),
    .DEPTH     ( DEPTH          )
  )
  fifo_ready_valid_inst (
    .clk_i  ( clk_i        ),
    .rst_i  ( rst_i        ),
    .data_i ( pow_data_o   ),
    .valid_i( pow_valid_o  ),
    .ready_o( fifo_ready_o ),
    .ready_i( ready_i      ),
    .valid_o( valid_o      ),
    .data_o ( data_o       )
  );
// credit

  credit_counter # (
    .DEPTH( DEPTH )
  )
  credit_counter_inst (
    .clk_i      ( clk_i       ),
    .rst_i      ( rst_i       ),
    .valid_i    ( pow_valid_i ),
    .pop        ( pop         ),
    .ready_cred ( ready_cred  )
  );

  assign pop         = ready_i & valid_o;
  assign pow_valid_i = valid_i & ready_cred;

endmodule
