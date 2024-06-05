// Формирование выходных данных системной шины
always_comb
begin //Для чтения crc используем адрес 1
  if (cs & (~p_we_i) & (p_adr_i[3:0] == 4'd4))
    p_dat_o <= {24'd0, crc_o};
end

// Формирование сигналов на модуль-вычислитель

//Для записи данных для расчета crc используем адрес 0
assign data_valid_i = (cs &  p_we_i & (p_adr_i[3:0] == 4'd0));

//Для записи данных для расчета crc используем адрес 0
assign din_i = (cs & p_we_i & (p_adr_i[3:0] == 4'd0));

//Для чтения crc используем адрес 4
assign crc_rd = (cs & ~p_we_i & (p_adr_i[3:0] == 4'd4));
