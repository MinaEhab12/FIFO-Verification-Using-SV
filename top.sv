module top ();

  bit clk;

  initial begin
    clk = 0;
    forever 
      #2 clk = ~clk;

  end

  FIFO_interface FIFO_IC (clk);
  FIFO_tb tb (FIFO_IC);
  FIFO DUT (FIFO_IC);
  monitor MONITOR (FIFO_IC);

endmodule 

