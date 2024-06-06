logic [7:0] din_i; // Объявляем провода, которые будут подключаться к сигналам модуля
logic [7:0] crc_o;
logic       crc_rd;
logic       data_valid_i;

crc8
i_crc8
(
  .clk_i        (p_clk_i),  // При подключении модуля указываем имя и название модуля name module_name (...
  .rst_i        (p_rstn_i), // Подключаем к каждому сигналу модуля провод .signal_name(wire_name), ...
  .din_i        (din_i),
  .data_valid_i (data_valid_i),
  .crc_rd       (crc_rd),
  .crc_o        (crc_o)
);
