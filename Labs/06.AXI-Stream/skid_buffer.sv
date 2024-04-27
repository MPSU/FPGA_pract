module skid_buffer#(
  parameter int DATA_WIDTH = 10
)(
  input  logic                      clk_i,
  input  logic                      rst_i,
    //upstream
  input  logic [DATA_WIDTH - 1 : 0] data_i,
  input  logic                      valid_i,
  output logic                      ready_o,
    //downstream
  output logic [DATA_WIDTH - 1 : 0] data_o,
  output logic                      valid_o,
  input  logic                      ready_i
);

logic [DATA_WIDTH - 1 : 0] skid_buffer;
logic                      buffer_valid;

assign data_o  =  buffer_valid ? skid_buffer : data_i;
assign valid_o =  buffer_valid | valid_i;
assign ready_o = !buffer_valid | ready_i;

always_ff @(posedge clk_i)begin
  if (rst_i) begin
    skid_buffer  <= '0;
    buffer_valid <= '0;
  end else if (!buffer_valid & valid_i & !ready_i) begin
    skid_buffer  <= data_i;        // Если получатель не готов, сохраняем данные в буфере
    buffer_valid <= 1'b1;
  end else if (buffer_valid & ready_i)
    buffer_valid <= '0;             // Если получатель готов, очищаем буфер
end

endmodule
