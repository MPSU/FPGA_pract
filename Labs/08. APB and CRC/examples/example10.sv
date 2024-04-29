task write_register; // Название task
  input [31:0] reg_addr; // Параметры передаваемые в task, в нашем случае адрес и данные
  input [31:0] reg_data;

  begin
    @ (posedge p_clk_i); // Ожидаем один такт

    // Формируем посылку согласно документации на APB
    p_adr_i    = reg_addr; // Выставляем значения на шины адреса и данных
    p_dat_i    = reg_data;
    p_enable_i = 0;
    p_sel_i    = 1;
    p_we_i     = 1;

    @ (posedge p_clk_i); // Ожидаем один такт

    p_enable_i = 1;

    wait (p_ready); // Ожидаем появление сигнала p_ready

    // Вывод информации о совершенной операции
    $display("(%0t) Writing register [%0d] = 0x%0x", $time, p_adr_i, reg_data);
    @ (posedge p_clk_i);

    // Возвращаем сигналы в исходное состояние
    p_adr_i    = 'hz;
    p_dat_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
  end
endtask
