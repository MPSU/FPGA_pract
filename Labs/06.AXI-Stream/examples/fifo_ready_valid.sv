module fifo_ready_valid #(
  parameter int DATA_WIDTH = 5,
  parameter int DEPTH      = 10
) (
  input logic                       clk_i,
  input logic                       rst_i,
    // upstream
  input  logic [DATA_WIDTH - 1 : 0] write_data_i,
  input  logic                      valid_i,
  output logic                      ready_o, // can called: can write
    // downstream
  input  logic                      ready_i,
  output logic                      valid_o, // can called: can read
  output logic [DATA_WIDTH - 1 : 0] read_data_o
);

localparam int                   POINTER_WIDTH = $clog2(DEPTH);
localparam [POINTER_WIDTH - 1:0]   max_pointer = POINTER_WIDTH' (DEPTH - 1);

logic [DATA_WIDTH    - 1 : 0] fifo [DEPTH];                 // fifo data
logic [POINTER_WIDTH - 1 : 0] wr_pointer, rd_pointer;       // pointer to read and write
logic                         empty, full;                  // signal that says: can we read/write ?
logic                         wr_odd_circle, rd_odd_circle; // odd bit for pointer


assign empty = (wr_pointer == rd_pointer) & (wr_odd_circle == rd_odd_circle);// pointer = {wr/rd odd, wr/rd pointer} watch
assign full  = (wr_pointer == rd_pointer) & (wr_odd_circle != rd_odd_circle);// Занятие 17 школа синтеза {23:40}

assign valid_o = ~empty;
assign ready_o = ~full;

assign pop     = ~empty & ready_i; // we reading => pop,  rd_pointer + 1
assign push    = ~full  & valid_i; // we writing => push, wr_pointer + 1


always_ff @(posedge clk_i) begin
  if(rst_i)begin
    wr_pointer    <= '0;
    wr_odd_circle <= '0;
  end else if (push) begin
    if(wr_pointer == max_pointer)begin
      wr_pointer    <= '0;                      // in case that if max pointer != DEPTH
      wr_odd_circle <= ~wr_odd_circle;          // Занятие 17 школа синтеза {23:40}
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
      rd_pointer    <= '0;                      // in case that if max pointer != DEPTH
      rd_odd_circle <= ~rd_odd_circle;          // Занятие 17 школа синтеза {23:40}
    end else
      rd_pointer <= rd_pointer + 1;
  end
end

always_ff @(posedge clk_i) begin : writing_data
  if(push)
    fifo[wr_pointer] <= write_data_i;
end

assign read_data_o = fifo[rd_pointer]; // reading data

endmodule
