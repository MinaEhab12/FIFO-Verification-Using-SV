interface FIFO_interface (clk);

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

	input clk;


	logic [FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;


	modport TEST (output rst_n, data_in, wr_en, rd_en,
					input clk,data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

	modport DUT (input rst_n, data_in, wr_en, rd_en, clk,
					output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

	modport MONITOR (input rst_n, data_in, wr_en, rd_en,clk,
					data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

endinterface 