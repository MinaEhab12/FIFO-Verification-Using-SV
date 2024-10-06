package trans_pkg;

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	
	class  FIFO_transaction;
		
		rand logic [FIFO_WIDTH-1:0] data_in;
		logic clk; 
		rand logic rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow;
		logic full, empty, almostfull, almostempty, underflow;

		int RD_EN_ON_DIST, WR_EN_ON_DIST;

		function new(int x = 30, int y = 70);

			RD_EN_ON_DIST = x;
			WR_EN_ON_DIST = y;

		endfunction

		constraint  A {rst_n dist {1:/90, 0:/10};}
		constraint  B {wr_en dist {1:/WR_EN_ON_DIST, 0:/100-WR_EN_ON_DIST};}
		constraint  C {rd_en dist {1:/RD_EN_ON_DIST, 0:/100-RD_EN_ON_DIST};}



	endclass

endpackage : trans_pkg