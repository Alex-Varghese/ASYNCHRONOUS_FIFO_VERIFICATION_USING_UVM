`include "uvm_macros.svh"
package async_fifo_pkg;
  import uvm_pkg::*;
	`include "defines.sv"
  
  `include "afifo_seq_item.sv"
  `include "afifo_write_sequence.sv"
  `include "afifo_read_sequence.sv" 
	`include "afifo_sequencers.sv"
  
	`include "afifo_drivers.sv"
	`include "afifo_monitors.sv"
  
	`include "afifo_agents.sv"

	`include "afifo_subscriber.sv"
  `include "afifo_scoreboard.sv"
  `include "afifo_virtual_sequencer.sv"
  `include "afifo_environment.sv"
  `include "afifo_virtual_sequence.sv"
  `include "afifo_tests.sv"
endpackage
