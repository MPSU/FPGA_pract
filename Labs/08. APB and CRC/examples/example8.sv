initial
begin
  p_dat_i    = 'hz;
  p_enable_i = 0;
  p_sel_i    = 0;
  p_we_i     = 'hz;
  p_adr_i    = 'hz;
  p_rst_i    = 1;
  #200
  p_rst_i    = 0; // Запись #200 обозначает что смена значения сигнала сброса произойдет через 200нс.
end
