
`include "../coverage/subscriber.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;

class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)

virtual async_fifo_if vif;

write_agent wr_agent;
read_agent rd_agent;
async_fifo_sb scb;
asyn_fifo_subscriber subcr;

function new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    wr_agent = write_agent::type_id::create("wr_agent", this);
    rd_agent = read_agent::type_id::create("rd_agent", this);
    scb = async_fifo_sb::type_id::create("scb", this);
		subcr = asyn_fifo_subscriber::type_id::create("subcr", this);
   	if (!uvm_config_db#(virtual async_fifo_if)::get(this, "", "vif", vif))begin
      		 `uvm_fatal("build phase", "No virtual interface specified for this env instance")
    end
endfunction
  
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
     	wr_agent.wr_mon.wr_mon_port.connect(scb.write_port);
     	rd_agent.rd_mon.rd_mon_port.connect(scb.read_port);    
		  wr_agent.wr_mon.write_item_port.connect(subcr.aport_write);
			rd_agent.rd_mon.read_item_port.connect(subcr.aport_read);
endfunction

task run_phase (uvm_phase phase);
	super.run_phase(phase);
endtask

endclass:fifo_env



