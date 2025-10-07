`include "defines.svh"

import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;

`uvm_analysis_imp_decl(_port_a)
`uvm_analysis_imp_decl(_port_b)

int empty_count;
int match, mismatch;

class async_fifo_sb extends uvm_scoreboard;

	`uvm_component_utils(async_fifo_sb)
 	uvm_analysis_imp_port_a#(write_seq_item,async_fifo_sb) write_port;
	uvm_analysis_imp_port_b#(read_seq_item,async_fifo_sb) read_port; 

	write_seq_item write_q[$];
	read_seq_item read_q[$]; 
	write_seq_item w_seq;
	read_seq_item r_seq; 
	
	reg [`DSIZE-1:0] next [1:0];
	reg [`DSIZE-1:0] tmp;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction  
               
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		write_port = new("write_port",this);
		read_port = new("read_port",this);  
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction 
 
	function void write_port_a(write_seq_item w_seq); 
		write_q.push_back(w_seq);
	endfunction

	function void write_port_b(read_seq_item r_seq);
		logic [`DSIZE-1:0] dut_wdata;
		empty_count = write_q.size;
		if(write_q.size() > 0) begin
			get_next(r_seq);
    	dut_wdata = write_q.pop_front().wdata;
    	if(dut_wdata == next[1]) begin
				$display("------------------------ Pass ----------------------------\n  Expected Data: %0d Read Data(DUT): %0d", next[1], dut_wdata);
			  match++;
			end
			else begin
				$display("------------------------ Fail ----------------------------\n Expected Data: %0d Does not match DUT Read Data: %0d", next[1], dut_wdata);
				mismatch++;
			end
		end
		$display("\n\n");			
	endfunction

	function void get_next(read_seq_item r_seq);
		tmp = next[0];
		next[0] = r_seq.rdata;
		next[1] = tmp;
	endfunction

	task compare_flags();	
		if(write_q.size > 2**(`ASIZE-1)) begin
    	`uvm_info("SCOREBOARD", "FIFO IS FULL", UVM_MEDIUM);
  	end 
	  if(empty_count == 1) begin
  		`uvm_info("SCOREBOARD", "FIFO IS EMPTY", UVM_MEDIUM);
	  end
	endtask
    
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask
  
endclass:async_fifo_sb
