module pow5_pipelined
#(
  parameter DATA_WIDTH = 8
)
(
  input  logic                      clk_i,
  input  logic                      rst_i,
  input  logic [DATA_WIDTH-1:0]     pow_data_i,
  output logic [(5*DATA_WIDTH)-1:0] pow_data_o
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

  always_ff @ (posedge clk_i or posedge rst_i) begin
    if (rst_i)
      pow_input_ff <= '0;
    else
      pow_input_ff <= pow_data_i;
  end

  always_ff @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      pow_input_stage_1_ff <= '0;
      pow_input_stage_2_ff <= '0;
      pow_input_stage_3_ff <= '0;
    end
    else begin
      pow_input_stage_1_ff <= pow_input_ff;
      pow_input_stage_2_ff <= pow_input_stage_1_ff;
      pow_input_stage_3_ff <= pow_input_stage_2_ff;
    end
  end

  // Multiply numbers
  assign pow_mul_stage_1 = pow_input_ff        * pow_input_ff;
  assign pow_mul_stage_2 = pow_data_stage_1_ff * pow_input_stage_1_ff;
  assign pow_mul_stage_3 = pow_data_stage_2_ff * pow_input_stage_2_ff;
  assign pow_mul_stage_4 = pow_data_stage_3_ff * pow_input_stage_3_ff;

  always_ff @ (posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      pow_data_stage_1_ff <= '0;
      pow_data_stage_2_ff <= '0;
      pow_data_stage_3_ff <= '0;
    end
    else begin
      pow_data_stage_1_ff <= pow_mul_stage_1;
      pow_data_stage_2_ff <= pow_mul_stage_2;
      pow_data_stage_3_ff <= pow_mul_stage_3;
    end
  end

  always_ff @ (posedge clk_i or posedge rst_i) begin
    if (rst_i)
      pow_output_ff <= '0;
    else
      pow_output_ff <= pow_mul_stage_4;
  end

  assign pow_data_o = pow_output_ff;

endmodule
