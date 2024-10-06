package scoreboard_pkg;
	import trans_pkg::*;
	import shared_pkg::*;
	
	logic [FIFO_WIDTH-1:0] fifo_queue[$];  

	class FIFO_scoreboard;
		logic [FIFO_WIDTH-1:0] data_out_ref;
		logic wr_ack_ref;
		logic [2:0] wr_ptr, rd_ptr;
		logic [3:0] fifo_count;
		logic full_ref;
		logic empty_ref;
		

		function void check_data(input FIFO_transaction F_txn );

			reference_model(F_txn);
			if (data_out_ref != F_txn.data_out) begin
				$display("Error with data_out_ref = %0d and F_txn.data_out = %0d", data_out_ref,F_txn.data_out);	
				Error_count++;
			end
			else begin
				Correct_count++;
				$display("correct with data_out_ref = %0d and F_txn.data_out = %0d", data_out_ref,F_txn.data_out);
			end
		endfunction



    	function reference_model(input FIFO_transaction F_txn);

    		if (!F_txn.rst_n) begin
        		fifo_queue <= {}; 
        		fifo_count <= 0;
    		end
    		else begin
        		if (F_txn.wr_en && fifo_count < FIFO_DEPTH) begin
            		fifo_queue.push_back(F_txn.data_in);  
            		fifo_count <= fifo_queue.size();       
        		end

        
        		if (F_txn.rd_en && fifo_count != 0) begin
            		data_out_ref <= fifo_queue.pop_front();
            		fifo_count <= fifo_queue.size();          
        		end
    		end

        	full_ref = (fifo_count == FIFO_DEPTH);  
    		empty_ref = (fifo_count == 0);          

		endfunction
	endclass 	
endpackage : scoreboard_pkg