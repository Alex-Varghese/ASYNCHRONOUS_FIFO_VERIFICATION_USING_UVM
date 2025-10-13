`include "defines.sv"
`include "../Design/FIFO.v"
`include "afifo_interface.sv"
`include "afifo_pkg.sv"
`include "afifo_assertions.sv"

import uvm_pkg::*;
import async_fifo_pkg::*;

module top;

	bit wclk, rclk;

	async_fifo_interface vif(wclk,rclk);

	FIFO dut(
		.wclk(vif.wclk),
		.rclk(vif.rclk),
		.wrst_n(vif.wrst),
		.rrst_n(vif.rrst),
		.winc(vif.winc),
		.rinc(vif.rinc),
		.wdata(vif.wdata),
		.rdata(vif.rdata),
		.wfull(vif.wfull),
		.rempty(vif.rempty)
	);

	bind vif async_fifo_assertions ASSERT(
		.wclk(vif.wclk),
		.rclk(vif.rclk),
		.wrst(vif.wrst),
		.rrst(vif.rrst),
		.winc(vif.winc),
		.rinc(vif.rinc),
		.wdata(vif.wdata),
		.rdata(vif.rdata),
		.wfull(vif.wfull),
		.rempty(vif.rempty),
		.write_ptr(dut.raddr),
		.read_ptr(dut.waddr)
	);

	initial begin
		wclk = 1'b0;
		forever #5 wclk = ~wclk;
	end

	initial begin
		rclk = 1'b0;
		forever #10 rclk = ~rclk;
	end

	initial begin
		$dumpfile("wave.vcd");
		$dumpvars;
	end

	initial begin
		uvm_config_db#(virtual async_fifo_interface)::set(null,"*","vif",vif);
	end

	initial begin
		run_test("async_fifo_test");
		#1000 $finish;
	end

endmodule
