module pow5_mult_single_cycle
#(
  parameter DATA_WIDTH = 8
)
(
  input  logic [DATA_WIDTH-1:0]     pow_data_i,
  output logic [(5*DATA_WIDTH)-1:0] pow_data_o
);

  logic [w_sw_actual-1:0]     pow_input_ff;
  logic [(5*w_sw_actual)-1:0] pow5_mult;
  logic [(5*w_sw_actual)-1:0] pow_output_ff;

  always_ff @ (posedge clk or posedge rst) begin
    if (rst)
      pow_input_ff <= '0;
    else
      pow_input_ff <= sw;
  end

  assign pow5_mult = pow_input_ff * pow_input_ff * pow_input_ff * pow_input_ff * pow_input_ff;

  always_ff @ (posedge clk or posedge rst) begin
    if (rst)
      pow_output_ff <= '0;
    else
      pow_output_ff <= pow5_mult;
  end

  assign pow_data_o = pow_output_ff;

endmodule
