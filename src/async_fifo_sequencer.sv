
/*****************************Write_sequencer*************************************************/


import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;

class write_sequencer extends uvm_sequencer #(write_seq_item);
`uvm_component_utils(write_sequencer)

function new (string name = "write_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase(phase);
endfunction

function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
endfunction

endclass:write_sequencer

/*****************************Read_sequencer*************************************************/


class read_sequencer extends uvm_sequencer #(read_seq_item);
`uvm_component_utils(read_sequencer)

function new (string name = "read_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase(phase);
endfunction

function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
endfunction

endclass:read_sequencer

