
import uvm_pkg::*;
`include "uvm_macros.svh"
 import async_fifo_pkg::*;

class write_sequence_random extends uvm_sequence#(write_seq_item);
  `uvm_object_utils(write_sequence_random)

int tx_count_write=1000;
write_seq_item txw;
    
function new(string name = "write_sequence_full");
       super.new(name);
endfunction

task body();
  	for (int i = 0; i < tx_count_write; i++) 
	begin
		txw = write_seq_item::type_id::create("txw");
		start_item(txw);
    		if (!(txw.randomize()));
			//`uvm_error("TX_GENERATION_FAILED", "Failed to randomize write_seq_item")
		finish_item(txw);
    	end
	
endtask

endclass:write_sequence_random

/*****************************Read_sequence*************************************************/


class read_sequence_random extends uvm_sequence#(read_seq_item);
  
`uvm_object_utils(read_sequence_random)

int tx_count_read=1000;
read_seq_item txr;
    
function new(string name = "read_sequence_random");
	super.new(name);
endfunction

task body();
	for (int i = 0; i < tx_count_read; i++) 
	begin
		txr = read_seq_item::type_id::create("txr");
		start_item(txr);
          	if(!(txr.randomize()));	
			//`uvm_fatal("TX_GENERATION_FAILED", "Failed to randomize read_seq_item")
		finish_item(txr);
	end	
endtask

endclass:read_sequence_random
