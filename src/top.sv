

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_interface.sv"
`ifdef BASE_TEST
	`include "async_fifo_test1.sv"
`else
	`include "async_fifo_test2.sv"
`endif
`include "../coverage/assertion.sv"
`include "../design/FIFO.v"

module top;

	bit rclk,wclk,rrst,wrst;
  	
	always #4 wclk = ~wclk;
	always #10 rclk = ~rclk;
 
	async_fifo_if DUV_IF (wclk,rclk,wrst,rrst);
 
	FIFO DUT(.rdata(DUV_IF.rdata),
				   .wfull(DUV_IF.wfull),
				   .rempty(DUV_IF.rempty),
				   .wdata(DUV_IF.wdata),
				   .winc(DUV_IF.winc),
				   .wclk(wclk),
				   .wrst_n(wrst),
				   .rinc(DUV_IF.rinc),
				   .rclk(rclk),
				   .rrst_n(rrst)
				   );
	bind async_fifo_if asyn_fifo_assertions ASSERTION (
										 .rdata(DUV_IF.rdata),
					           .wfull(DUV_IF.wfull),
					           .rempty(DUV_IF.rempty),
					           .wdata(DUV_IF.wdata),
					           .winc(DUV_IF.winc),
					           .wclk(wclk),
					           .wrst_n(wrst),
					           .rinc(DUV_IF.rinc),
					           .rclk(rclk),
					           .rrst_n(rrst)
					           );

	initial begin
		uvm_config_db#(virtual async_fifo_if)::set(null, "*","vif", DUV_IF);
		`uvm_info("tb_top","uvm_config_db set for uvm_tb_top", UVM_LOW);
	end

	initial begin
		`ifdef BASE_TEST
			run_test("fifo_base_test");	
		`else
	 		run_test("fifo_random_test");
		`endif
	end

	initial begin
		wclk = 0;
		rclk = 0;
		wrst = 0;
		rrst = 0;
		DUV_IF.rinc=0;
		DUV_IF.winc=0;
		#1;
		rrst = 1;
		wrst = 1;
	end
	initial begin
		assert (!DUV_IF.rinc) else
  		`uvm_error("ASSERTION", "Read increment is active at the beginning of simulation");
  
		assert (!DUV_IF.winc) else
 		 `uvm_error("ASSERTION", "Write increment is active at the beginning of simulation");

		assert (wclk === 0 || wclk === 1) else
 		 `uvm_error("ASSERTION", "Write clock has unexpected value");

		assert (rclk === 0 || rclk === 1) else
 		 `uvm_error("ASSERTION", "Read clock has unexpected value");

		assert (!wrst || (wclk && DUV_IF.wdata)) else
  	 `uvm_error("ASSERTION", "Unexpected sequencing of write events");

		assert (!rrst || (rclk && DUV_IF.rdata)) else
 		 `uvm_error("ASSERTION", "Unexpected sequencing of read events");

		while(!wclk) begin
    	#1;
			assert (!DUV_IF.wfull) else
    			`uvm_error("ASSERTION", "Write FIFO is full at the beginning of simulation");
		end
 		while(!rclk) begin
    	#1;
			assert (DUV_IF.rempty) else
  			`uvm_error("ASSERTION", "Read FIFO is not empty at the beginning of simulation");
			end
	end

	//`include "async_fifo_coverage.sv"
  //FIFO_coverage fifo_coverage_inst;
 /* 
	initial begin
		fifo_coverage_inst = new();
    forever begin 
			@(posedge wclk or posedge rclk)
      	fifo_coverage_inst.sample();
    end
	end 
*/
endmodule:top
