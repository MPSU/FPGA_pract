module pow5_pipelined_valid
#(
  parameter DATA_WIDTH = 8
)
(
  input  logic                      clk_i,
  input  logic                      rst_i,
  input  logic [DATA_WIDTH-1:0]     pow_data_i,
  input  logic                      data_valid_i,
  output logic [(5*DATA_WIDTH)-1:0] pow_data_o,
  output logic                      data_valid_o
);


  logic [DATA_WIDTH-1:0] pow_input_ff;

  logic [(2*DATA_WIDTH)-1:0] pow_mul_stage_1;
  logic [(3*DATA_WIDTH)-1:0] pow_mul_stage_2;
  logic [(4*DATA_WIDTH)-1:0] pow_mul_stage_3;
  logic [(5*DATA_WIDTH)-1:0] pow_mul_stage_4;

  logic [(2*DATA_WIDTH)-1:0] pow_data_stage_1_ff;
  logic [(3*DATA_WIDTH)-1:0] pow_data_stage_2_ff;
  logic [(4*DATA_WIDTH)-1:0] pow_data_stage_3_ff;

  logic [DATA_WIDTH-1:0] pow_input_stage_1_ff;
  logic [DATA_WIDTH-1:0] pow_input_stage_2_ff;
  logic [DATA_WIDTH-1:0] pow_input_stage_3_ff;

  logic [(5*DATA_WIDTH)-1:0] pow_output_ff;


  logic input_valid_ff;
  logic data_valid_stage_1_ff;
  logic data_valid_stage_2_ff;
  logic data_valid_stage_3_ff;
  logic output_valid_ff;


    // "Valid" flags
  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      input_valid_ff <= '0;
    else
      input_valid_ff <= data_valid_i;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i) begin
      data_valid_stage_1_ff <= '0;
      data_valid_stage_2_ff <= '0;
      data_valid_stage_3_ff <= '0;
    end
    else begin
      data_valid_stage_1_ff <= input_valid_ff;
      data_valid_stage_2_ff <= data_valid_stage_1_ff;
      data_valid_stage_3_ff <= data_valid_stage_2_ff;
    end

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      output_valid_ff <= '0;
    else
      output_valid_ff <= data_valid_stage_3_ff;


    // Input data pipeline

    // Exercise: 1) remove unnecessary resets here to reduce ASIC area
    //           2) use clock gating to reduce pipeline power consumption

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_input_ff <= '0;
    else
      pow_input_ff <= pow_data_i;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_input_stage_1_ff <= '0;
    else
      pow_input_stage_1_ff <= pow_input_ff;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_input_stage_2_ff <= '0;
    else
      pow_input_stage_2_ff <= pow_input_stage_1_ff;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_input_stage_3_ff <= '0;
    else
      pow_input_stage_3_ff <= pow_input_stage_2_ff;


    // Multiply numbers
    assign pow_mul_stage_1 = pow_input_ff        * pow_input_ff;
    assign pow_mul_stage_2 = pow_data_stage_1_ff * pow_input_stage_1_ff;
    assign pow_mul_stage_3 = pow_data_stage_2_ff * pow_input_stage_2_ff;
    assign pow_mul_stage_4 = pow_data_stage_3_ff * pow_input_stage_3_ff;


    // Exercise: 1) remove unnecessary resets here to reduce ASIC area
    //           2) use clock gating to reduce pipeline power consumption

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_data_stage_1_ff <= '0;
    else
      pow_data_stage_1_ff <= pow_mul_stage_1;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_data_stage_2_ff <= '0;
    else
      pow_data_stage_2_ff <= pow_mul_stage_2;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_data_stage_3_ff <= '0;
    else
      pow_data_stage_3_ff <= pow_mul_stage_3;

  always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
      pow_output_ff <= '0;
    else
      pow_output_ff <= pow_mul_stage_4;


  assign pow_data_o   = pow_output_ff;
  assign data_valid_o = output_valid_ff;

endmodule
