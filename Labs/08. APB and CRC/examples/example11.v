task read_register;
  input [31:0] reg_addr;
  begin
    @ (posedge p_clk_i);

    p_adr_i    = reg_addr;
    p_enable_i = 0;
    p_sel_i    = 1;
    p_we_i     = 0;

    @ (posedge p_clk_i);

    p_enable_i = 1;

    wait (p_ready);

    $display("(%0t) Reading register [%0d] = 0x%0x", $time, p_adr_i, p_dat_o);

    @ (posedge p_clk_i);

    p_adr_i    = 'hz;
    p_enable_i = 0;
    p_sel_i    = 0;
    p_we_i     = 'hz;
  end
endtask
