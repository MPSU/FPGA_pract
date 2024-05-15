initial
begin
  p_clk_i=0;
  forever #50 p_clk_i = ~p_clk_i; // Сигнал инвертируется каждые 50нс
end
