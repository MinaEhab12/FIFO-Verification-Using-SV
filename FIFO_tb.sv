module FIFO_tb(FIFO_interface.TEST FIFO_IC);

	import shared_pkg::*;
	import trans_pkg::*;

	FIFO_transaction trans = new;

initial begin
    test_finished = 0;
    FIFO_IC.rst_n = 0; 
    @(negedge FIFO_IC.clk);
    FIFO_IC.rst_n = 1;

    @(negedge FIFO_IC.clk);

    for (int i = 0; i < 10000; i++) begin
    	
        assert(trans.randomize());

        FIFO_IC.rst_n = trans.rst_n;
        FIFO_IC.wr_en = trans.wr_en;
        FIFO_IC.rd_en = trans.rd_en;
        FIFO_IC.data_in = trans.data_in;
        

        @(negedge FIFO_IC.clk);
    end

    test_finished = 1; 
end 

	
endmodule