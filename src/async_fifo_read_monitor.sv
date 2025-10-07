
import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;

class read_monitor extends uvm_monitor;
	`uvm_component_utils(read_monitor) 
 
	virtual async_fifo_if rd_vif;
	read_seq_item r_seq;
	bit write_complete_flag;

	uvm_analysis_port#(read_seq_item) rd_mon_port;

	int trans_count_read;
	int r_count;

	function new (string name = "read_monitor", uvm_component parent);
		super.new(name, parent);
		`uvm_info("READ_MONITOR_CLASS", "Inside constructor",UVM_LOW)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rd_mon_port = new("rd_mon_port", this);
   	if(!uvm_config_db#(virtual async_fifo_if)::get(this, "", "vif", rd_vif))begin
      `uvm_error("build_phase", "No virtual interface specified for this read_monitor instance")
    end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction  

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		fork 
			begin : read_monitor
				forever @(negedge rd_vif.rclk)begin
        	mon_read();
    		end
			end
			begin
				wait(r_count == trans_count_read);
      end
		join_any		
	endtask
      
	task mon_read();   
		read_seq_item r_seq;
		if(rd_vif.rinc == 1)begin
			r_seq = read_seq_item::type_id::create("r_seq"); 
			fork
				begin
					@(negedge rd_vif.rclk);
					r_seq.rdata = rd_vif.rdata;
			    r_seq.rempty = rd_vif.rempty;
					$display("Read Monitor @(%0t)\nrinc = %0d | rdata = %0d | rempty = %0d",$time,r_seq.rinc,r_seq.rdata,r_seq.rempty);
   				rd_mon_port.write(r_seq);
					r_count= r_count +1;
				end
			join_none	
  	end
	endtask

endclass:read_monitor
