
`include "defines.svh"
import uvm_pkg::*;
`include "uvm_macros.svh"

//------------------------------ Write_seq_item --------------------------------------------

class write_seq_item extends uvm_sequence_item;
	`uvm_object_utils(write_seq_item)

	rand bit [`DSIZE-1:0] wdata;
	rand bit winc;
	bit wfull;

	function new(string name = "write_seq_item");
  	super.new(name);
	endfunction

endclass:write_seq_item

//--------------------------------- Read_seq_item -------------------------------------------

class read_seq_item extends uvm_sequence_item;
	`uvm_object_utils(read_seq_item)

	rand bit rinc;
	logic [`DSIZE-1:0] rdata;
	bit rempty;

	function new(string name = "read_seq_item");
  	super.new(name);
	endfunction

endclass:read_seq_item
