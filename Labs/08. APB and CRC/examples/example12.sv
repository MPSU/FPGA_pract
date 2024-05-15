initial
begin
  write_register(32'd0, 32'hAA);
  #1200 write_register(32'd0, 32'h33);
  #1200 read_register(32'd4);
end
