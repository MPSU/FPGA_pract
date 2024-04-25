module credit_counter #(
  parameter int DEPTH = 10
) (
  input  logic clk_i,
  input  logic rst_i,

  input  logic valid_i,
  input  logic pop,
  output logic ready_cred
);

logic [$clog2(DEPTH+1) - 1 : 0 ] counter;

always_ff @(posedge clk_i) begin
  if(rst_i)
    counter <= DEPTH;
  else if(pop & valid_i)
    counter <= counter;
  else begin
    if(valid_i)
      counter <= counter - 1;
    if(pop)
      counter <= counter + 1;
  end
end

assign ready_cred = (counter == 0)? 1'b0 : 1'b1;

endmodule
