module monitor (FIFO_interface.MONITOR FIFO_IC);

	import coverage_pkg::*;
	import scoreboard_pkg::*;
	import trans_pkg::*;
	import shared_pkg::*;
	
	FIFO_transaction transaction=new;
	FIFO_scoreboard score=new;
	FIFO_coverage coverage=new;

	initial begin
		
		forever begin

			@(negedge  FIFO_IC.clk);
			

			transaction.rd_en = FIFO_IC.rd_en;
			transaction.wr_en = FIFO_IC.wr_en;
			transaction.wr_ack = FIFO_IC.wr_ack;
			transaction.full = FIFO_IC.full;
			transaction.empty = FIFO_IC.empty;
			transaction.almostfull = FIFO_IC.almostfull;
			transaction.almostempty = FIFO_IC.almostempty;
			transaction.overflow = FIFO_IC.overflow;
			transaction.underflow = FIFO_IC.underflow;
			transaction.data_in = FIFO_IC.data_in;
			transaction.rst_n = FIFO_IC.rst_n;
			transaction.data_out = FIFO_IC.data_out;

			fork
				begin
					coverage.sample_data(transaction);
				end

				begin
					score.check_data(transaction);
				end
			join


			if (test_finished) begin
				$display("Error count  = %0d, correct count = %0d",Error_count, Correct_count);
				$stop;
			end

		end			
	end 
endmodule 
