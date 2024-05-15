logic cs_ack1_ff;
logic cs_ack2_ff;

// Формирование сигнала готовности системной шины p_ready
always_ff @ (posedge p_clk_i)
begin
  cs_ack1_ff <= cs_2_ff;
  cs_ack2_ff <= cs_ack1_ff;
end

logic p_ready_ff;

always_ff @ (posedge p_clk_i)
begin
  p_ready_ff <= (cs_ack1_ff & (~cs_ack2_ff));
end
