`include "defines.svh"

interface async_fifo_if(input logic wclk,rclk,wrst,rrst);
	logic [`ASIZE-1:0] wdata;
	logic winc;
	logic rinc;  
	logic [`ASIZE-1:0] rdata;
	logic rempty;
	logic wfull;

// clocking block
	clocking monw_cs@(posedge wclk);
		default input #1 output #1;
  	input winc,wrst,wdata,wfull;
	endclocking

// clocking block
	clocking monr_cs@(posedge rclk);
		default input #0 output #1;
  	input rinc, rrst,rdata,rempty;
	endclocking
 
endinterface
