package coverage_pkg;

	import trans_pkg::*;
	
	class  FIFO_coverage;
		
		FIFO_transaction F_cvg_txn;

		covergroup cg ;

			cross_0: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.wr_ack;
			cross_1: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.overflow;
			cross_2: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.full;
			cross_3: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.empty;
			cross_4: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostfull;
			cross_5: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostempty;
			cross_6: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.underflow;

		endgroup

		function void sample_data(FIFO_transaction F_txn);
			F_cvg_txn = F_txn;
        	cg.sample();
		endfunction 


		function new();
			cg=new();	
		endfunction

	endclass

endpackage : coverage_pkg