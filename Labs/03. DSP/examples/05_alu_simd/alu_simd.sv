(* use_dsp = "simd" *)
module alu_simd
#(
  parameter N = 4,    // Number of Adders
  parameter W = 10    // Width of the Adders
)
(
  input  logic         clk_i,
  input  logic         rst_i,
  input  logic [W-1:0] a_i   [N-1:0],
  input  logic [W-1:0] b_i   [N-1:0],
  output logic [W-1:0] res_o [N-1:0]
);

  integer i;
  logic [W-1:0] a_ff   [N-1:0];
  logic [W-1:0] b_ff   [N-1:0];
  logic [W-1:0] res_ff [N-1:0];


  always_ff @(posedge clk_i) begin
    for(i=0; i<N; i=i+1)
      begin
        if (rst_i) begin
          a_ff[i]   <= '0;
          b_ff[i]   <= '0;
          res_ff[i] <= '0;
        end
        else begin
          a_ff[i]   <= a_i[i];
          b_ff[i]   <= b_i[i];
          res_ff[i] <= a_ff[i] + b_ff[i];
        end
      end
  end

  assign res_o = res_ff;

endmodule
