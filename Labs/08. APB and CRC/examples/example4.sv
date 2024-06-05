logic cs_1_ff;
logic cs_2_ff;

// Формирование строба cs цикла чтения или записи по системной шине
always_ff @ (posedge p_clk_i)
begin
  cs_1_ff <= p_enable_i & p_sel_i;
  cs_2_ff <= cs_1_ff;
end

logic cs;
assign cs = cs_1_ff & (~cs_2_ff);
