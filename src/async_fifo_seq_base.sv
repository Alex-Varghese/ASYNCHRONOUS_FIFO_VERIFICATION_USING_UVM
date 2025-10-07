`include "defines.svh"
//------------------------------------ Write_sequence ----------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;


class write_sequence extends uvm_sequence#(write_seq_item);
	`uvm_object_utils(write_sequence)

	int tx_count_write = 2**(`ASIZE)-1;
	write_seq_item w_seq;
    
	function new(string name = "write_sequence");
  	super.new(name);
	endfunction

	task body();
    repeat(tx_count_write) begin
			w_seq = write_seq_item::type_id::create("w_seq");
			start_item(w_seq);
    	if (!(w_seq.randomize() with {w_seq.winc == 1;}));
				finish_item(w_seq);    
		end

endtask

endclass:write_sequence

//------------------------------------------------ Read_sequence ------------------------------------------------


class read_sequence extends uvm_sequence#(read_seq_item);
	`uvm_object_utils(read_sequence)

	int tx_count_read = 2**(`ASIZE-1);
	read_seq_item r_seq;
    
	function new(string name = "read_sequence");
  	super.new(name);
	endfunction

	task body();
		for (int i = 0; i < tx_count_read; i++) begin
			r_seq = read_seq_item::type_id::create("r_seq");
			start_item(r_seq);
     	if(!(r_seq.randomize() with {r_seq.rinc == 1;}));
				finish_item(r_seq);
		end
	endtask

endclass:read_sequence
