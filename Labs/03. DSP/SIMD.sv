// This module describes SIMD Inference 
// 4 small adders can be packed into signle DSP block

// Note : SV constructs are used, Compile this with System Verilog Mode

(* use_dsp = "simd" *)
module simd#(
  parameter N = 4,    // Number of Adders
  parameter W = 10    // Width of the Adders
)(
  input  clk,

  input  [W-1:0] a [N-1:0],
  input  [W-1:0] b [N-1:0],

  output logic [W-1:0] out [N-1:0]
);
                 
  integer i;
  logic [W-1:0] a_r [N-1:0];
  logic [W-1:0] b_r [N-1:0];

  always @ (posedge clk)
  begin
  for(i=0;i<N;i=i+1)
  begin
    a_r[i] <= a[i];
    b_r[i] <= b[i];
    out[i] <= a_r[i] + b_r[i];
  end
  end
				
endmodule			