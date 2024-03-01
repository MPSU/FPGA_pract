
// This module describes a Complex Multiplier with accumulation (pr+i.pi) <= (ar+i.ai)*(br+i.bi)
// This can be packed into 3 DSP blocks (Ultrascale architecture)
// Make sure the widths are less than what is supported by the architecture
    
module complex_multiplier_acc#(
  parameter AWIDTH  = 16,  // width of 1st input
  parameter BWIDTH  = 18,  // width of 2nd input 
  parameter SIZEOUT = 40   // output width
)(
  input  clk,                      // clock input 
  input  sload,                    // synchronous load

  input  signed [AWIDTH-1:0]  ar,  // 1st input of multiplier - real part
  input  signed [AWIDTH-1:0]  ai,  // 1st input of multiplier - imaginary part
  input  signed [BWIDTH-1:0]  br,  // 2nd input of multiplier - real part
  input  signed [BWIDTH-1:0]  bi,  // 2nd input of multiplier - imaginary part

  output signed [SIZEOUT-1:0] pr,  // output - Real part
  output signed [SIZEOUT-1:0] pi   // output - Imaginary part
);

  reg signed [AWIDTH-1:0] 	    ai_d, ai_dd, ai_ddd, ai_dddd;
  reg signed [AWIDTH-1:0]	      ar_d, ar_dd, ar_ddd, ar_dddd;
  reg signed [BWIDTH-1:0]	      bi_d, bi_dd, bi_ddd, br_d, br_dd, br_ddd;
  reg signed [AWIDTH:0]	        addcommon;
  reg signed [BWIDTH:0]	        addr, addi;
  reg signed [AWIDTH+BWIDTH:0]	mult0, multr, multi;	 
  reg signed [SIZEOUT-1:0]	    pr_int, pi_int, old_result_real, old_result_im;
  reg signed [AWIDTH+BWIDTH:0]	common, commonr1, commonr2;

  reg sload_reg; 
 
  always @(posedge clk)
  begin
    ar_d      <= ar;
    ar_dd     <= ar_d;
    ai_d      <= ai;
    ai_dd     <= ai_d;
    br_d      <= br;
    br_dd     <= br_d;
    br_ddd    <= br_dd;
    bi_d      <= bi;
    bi_dd     <= bi_d;
    bi_ddd    <= bi_dd;
    sload_reg <= sload;
  end
  
  // Common factor (ar ai) x bi, shared for the calculations of the real and imaginary final products
  // 
  always @(posedge clk)
  begin
    addcommon <= ar_d - ai_d;
    mult0     <= addcommon * bi_dd;
    common    <= mult0;
  end

  // Accumulation loop (combinatorial) for *Real*
  //
  always @(sload_reg or pr_int)
  if (sload_reg)
  old_result_real <= 0;
  else
  // 'sload' is now and opens the accumulation loop.
  // The accumulator takes the next multiplier output
  // in the same cycle.
  old_result_real <= pr_int;

  // Real product
  //
  always @(posedge clk)
  begin
    ar_ddd   <= ar_dd;
    ar_dddd  <= ar_ddd;
    addr     <= br_ddd - bi_ddd;
    multr    <= addr * ar_dddd;
    commonr1 <= common;
    pr_int   <= multr + commonr1 + old_result_real;
  end

  // Accumulation loop (combinatorial) for *Imaginary*
  //
  always @(sload_reg or pi_int)
  if (sload_reg)
  old_result_im <= 0;
  else
  // 'sload' is now and opens the accumulation loop.
  // The accumulator takes the next multiplier output
  // in the same cycle.
  old_result_im <= pi_int;

  // Imaginary product
  //
  always @(posedge clk)
  begin
    ai_ddd   <= ai_dd;
    ai_dddd  <= ai_ddd;
    addi     <= br_ddd + bi_ddd;	 
    multi    <= addi * ai_dddd;
    commonr2 <= common;
    pi_int   <= multi + commonr2 + old_result_im;
  end

  assign pr = pr_int;
  assign pi = pi_int;

endmodule
				
				