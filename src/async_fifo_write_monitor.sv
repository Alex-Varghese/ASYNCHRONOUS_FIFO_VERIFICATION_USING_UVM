

import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;


class write_monitor extends uvm_monitor;
	`uvm_component_utils(write_monitor) 
 
	virtual async_fifo_if vif;
	write_seq_item w_seq;

	uvm_analysis_port#(write_seq_item) wr_mon_port;

	int trans_count_write;
	int w_count;

	function new (string name = "write_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wr_mon_port = new("wr_mon_port", this);
    if(!uvm_config_db#(virtual async_fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_error(get_full_name(),"cannot get() from uvm_config_db")
    end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction 
 
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
    fork
     	begin : write_monitor
      	forever@(negedge vif.wclk)begin
           mon_write();
        end
      end
      begin : write_completion
     		wait (w_count == trans_count_write);
     	end
  	join
	endtask
        
	task mon_write();   
		write_seq_item w_seq;
   	if(vif.winc==1 && vif.wfull==0) begin
 			w_seq = write_seq_item::type_id::create("w_seq");  
 			w_seq.winc = vif.winc;
  		w_seq.wdata = vif.wdata;
			w_seq.wfull = vif.wfull;
			$display("Write Monitor @(%0t)\nwinc = %0d | wdata = %0d | wfull = %0d",$time,w_seq.winc, w_seq.wdata, w_seq.wfull);
   		wr_mon_port.write(w_seq);
		end
	endtask

endclass:write_monitor
