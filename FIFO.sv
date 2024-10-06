////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////


module FIFO(FIFO_interface.DUT FIFO_IC);

localparam max_fifo_addr = $clog2(FIFO_IC.FIFO_DEPTH);

reg [FIFO_IC.FIFO_WIDTH-1:0] mem [FIFO_IC.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count; 

always @(posedge FIFO_IC.clk or negedge FIFO_IC.rst_n) begin
    if (!FIFO_IC.rst_n) begin
        wr_ptr <= 0;
        FIFO_IC.overflow<=0;
    end
    else if (FIFO_IC.wr_en && count < FIFO_IC.FIFO_DEPTH) begin
        mem[wr_ptr] <= FIFO_IC.data_in;
        FIFO_IC.wr_ack <= 1;
        wr_ptr <= wr_ptr + 1;
    end
    else begin 
        FIFO_IC.wr_ack <= 0; 
        if (FIFO_IC.full & FIFO_IC.wr_en)
            FIFO_IC.overflow <= 1;
        else
            FIFO_IC.overflow <= 0;
    end
end

always @(posedge FIFO_IC.clk or negedge FIFO_IC.rst_n) begin
    if (!FIFO_IC.rst_n) begin
        rd_ptr <= 0;
        FIFO_IC.underflow<=0;
    end
    else if (FIFO_IC.rd_en && count != 0) begin
        FIFO_IC.data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end
    else begin 
        if (FIFO_IC.empty && FIFO_IC.rd_en)begin
        	FIFO_IC.underflow <= 1;
        end     
        else begin
            FIFO_IC.underflow <= 0;   // underflow was modified to be sequential instead of combinational 	
        end
    end
end

always @(posedge FIFO_IC.clk or negedge FIFO_IC.rst_n) begin
    if (!FIFO_IC.rst_n) begin
        count <= 0;
    end
    else begin
        if	(({FIFO_IC.wr_en, FIFO_IC.rd_en} == 2'b10) && !FIFO_IC.full)
            count <= count + 1;
        else if (({FIFO_IC.wr_en, FIFO_IC.rd_en} == 2'b01) && !FIFO_IC.empty)
            count <= count - 1;
        else if ({FIFO_IC.wr_en, FIFO_IC.rd_en} == 2'b11) begin // if condition was added to handle if the wr_en , rd_en are asserted at the same time
    		if (FIFO_IC.full) begin
        		count <= count - 1;
    		end
            else if (FIFO_IC.empty) begin
        		count <= count + 1;
    		end
		end
	end
end

assign FIFO_IC.full = (count == FIFO_IC.FIFO_DEPTH)? 1 : 0;
assign FIFO_IC.empty = (count == 0)? 1 : 0;
assign FIFO_IC.almostfull = (count == FIFO_IC.FIFO_DEPTH-1)? 1 : 0;  // corrected to be -1  instead of -2
assign FIFO_IC.almostempty = (count == 1)? 1 : 0;


// Assertion and cover for FIFO full flags

property p_count_wr;
  @(posedge FIFO_IC.clk) disable iff (!FIFO_IC.rst_n) 
  (FIFO_IC.wr_en && !FIFO_IC.full && !FIFO_IC.rd_en) |=> (count == $past(count) + 1'b1);
endproperty

property p_count_rd;
  @(posedge FIFO_IC.clk) disable iff (!FIFO_IC.rst_n)
  (FIFO_IC.rd_en && !FIFO_IC.empty && !FIFO_IC.wr_en) |=> (count == $past(count) - 1'b1);
endproperty

property p_w_ack;
  @(posedge FIFO_IC.clk) disable iff (!FIFO_IC.rst_n)
  (FIFO_IC.wr_en && !FIFO_IC.full) |=> (FIFO_IC.wr_ack == 1);
endproperty

property p_full;
  @(posedge FIFO_IC.clk)
  (count == FIFO_IC.FIFO_DEPTH) |-> (FIFO_IC.full == 1);
endproperty

property p_empty;
  @(posedge FIFO_IC.clk)
  (count == 0) |-> (FIFO_IC.empty == 1);
endproperty

property p_almostfull;
  @(posedge FIFO_IC.clk)
  (count == FIFO_IC.FIFO_DEPTH - 1) |-> (FIFO_IC.almostfull == 1);
endproperty

property p_almostempty;
  @(posedge FIFO_IC.clk)
  (count == 1) |-> (FIFO_IC.almostempty == 1);
endproperty

property p_underflow;
  @(posedge FIFO_IC.clk) disable iff (!FIFO_IC.rst_n)
  (FIFO_IC.empty && FIFO_IC.rd_en) |=> (FIFO_IC.underflow == 1);
endproperty

property p_overflow;
  @(posedge FIFO_IC.clk) disable iff (!FIFO_IC.rst_n)
  (FIFO_IC.full && FIFO_IC.wr_en) |=> (FIFO_IC.overflow == 1);
endproperty

property p_count_check;
  @(posedge FIFO_IC.clk)
  (count <= FIFO_IC.FIFO_DEPTH);
endproperty

property p_wr_ptr_check;
  @(posedge FIFO_IC.clk)
  (wr_ptr < FIFO_IC.FIFO_DEPTH);
endproperty

property p_rd_ptr_check;
  @(posedge FIFO_IC.clk)
  (rd_ptr < FIFO_IC.FIFO_DEPTH);
endproperty


A_count_wr: assert property (p_count_wr);
C_count_wr: cover property (p_count_wr);

// Assertions and Cover for Read Count

A_count_rd: assert property (p_count_rd);
C_count_rd: cover property (p_count_rd);

// Assertions and Cover for Write Acknowledge

A_w_ack: assert property (p_w_ack);
C_w_ack: cover property (p_w_ack);

// Assertions and Cover for Full Condition

A_full: assert property (p_full);
C_full: cover property (p_full);

// Assertions and Cover for Empty Condition

A_empty: assert property (p_empty);
C_empty: cover property (p_empty);

// Assertions and Cover for Almost Full Condition

A_almostfull: assert property (p_almostfull);
C_almostfull: cover property (p_almostfull);

// Assertions and Cover for Almost Empty Condition

A_almostempty: assert property (p_almostempty);
C_almostempty: cover property (p_almostempty);

// Assertions and Cover for Underflow Condition

A_underflow: assert property (p_underflow);
C_underflow: cover property (p_underflow);

// Assertions and Cover for Overflow Condition

A_overflow: assert property (p_overflow);
C_overflow: cover property (p_overflow);

// Assertions and Cover for Counter Check

A_count_check: assert property (p_count_check);
C_count_check: cover property (p_count_check);

// Assertions and Cover for Write Pointer Check

A_wr_ptr_check: assert property (p_wr_ptr_check);
C_wr_ptr_check: cover property (p_wr_ptr_check);

// Assertions and Cover for Read Pointer Check

A_rd_ptr_check: assert property (p_rd_ptr_check);
C_rd_ptr_check: cover property (p_rd_ptr_check);                 

always_comb begin
    if (!FIFO_IC.rst_n) begin

        p_wr_ptr_reset: assert final (wr_ptr == 0);
        c_wr_ptr_reset: cover (wr_ptr == 0);

        p_rd_ptr_reset: assert final (rd_ptr == 0);
        c_rd_ptr_reset: cover (rd_ptr == 0);

        p_count_reset: assert final (count == 0);
        c_count_reset: cover (count == 0);

    end
end

endmodule
