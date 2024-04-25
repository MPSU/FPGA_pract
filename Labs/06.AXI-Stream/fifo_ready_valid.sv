module fifo_ready_valid #(
  parameter int DATA_WIDTH = 5,
  parameter int DEPTH      = 10
) (
input logic                       clk_i,
input logic                       rst_i,
  // upstream
input  logic [DATA_WIDTH - 1 : 0] data_i,
input  logic                      valid_i,
output logic                      ready_o,
  // downstream
input  logic                      ready_i,
output logic                      valid_o,
output logic [DATA_WIDTH - 1 : 0] data_o
);

localparam int POINTER_WIDTH = $clog2(DEPTH);
localparam [POINTER_WIDTH - 1:0] max_pointer = POINTER_WIDTH' (DEPTH - 1);

logic                         can_read, can_write; // can called: empty, full
logic [DATA_WIDTH    - 1 : 0] fifo [DEPTH];
logic [POINTER_WIDTH - 1 : 0] wr_pointer,    rd_pointer;
logic                         wr_odd_circle, rd_odd_circle;



assign can_read   = (wr_pointer == rd_pointer) & (wr_odd_circle == rd_odd_circle);// pointer = {wr/rd odd, wr/rd pointer} watch
assign can_write  = (wr_pointer == rd_pointer) & (wr_odd_circle != rd_odd_circle);// Занятие 17 школа синтеза {23:40}

assign pop     = ~can_read & ready_i;
assign push    = ~can_write  & valid_i;

assign valid_o = ~can_read;
assign ready_o = ~can_write;

always_ff @(posedge clk_i) begin
  if(rst_i)begin
    wr_pointer    <= '0;
    wr_odd_circle <= '0;
  end else if (push) begin
    if(wr_pointer == max_pointer)begin
      wr_pointer    <= '0;                      // in case that we max pointer != DEPTH
      wr_odd_circle <= ~wr_odd_circle;
    end else
      wr_pointer <= wr_pointer + 1;
  end
end

always_ff @(posedge clk_i) begin
  if(rst_i)begin
    rd_pointer    <= '0;
    rd_odd_circle <= '0;
  end else if(pop) begin
    if(rd_pointer == max_pointer)begin
      rd_pointer    <= '0;
      rd_odd_circle <= ~rd_odd_circle;
    end else
      rd_pointer <= rd_pointer + 1;
  end
end

always_ff @(posedge clk_i) begin
  if(push)
    fifo[wr_pointer] <= data_i;
end

assign data_o = fifo[rd_pointer];

endmodule
