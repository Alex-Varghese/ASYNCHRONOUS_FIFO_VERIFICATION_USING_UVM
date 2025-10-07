
// ---------------------------------------- Write Driver ---------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
import async_fifo_pkg::*;


class write_driver extends uvm_driver#(write_seq_item);
	`uvm_component_utils(write_driver)

	virtual async_fifo_if wr_drv_if;
	write_seq_item txw;
	int trans_count_write;

	function new(string name = "write_driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(virtual async_fifo_if)::get (this, "*", "vif", wr_drv_if))) 
			`uvm_error(get_type_name(), "FAILED to get data from config DB")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task drive_write(write_seq_item txw);
		@(posedge wr_drv_if.wclk);
  	this.wr_drv_if.winc = txw.winc;
    this.wr_drv_if.wdata = txw.wdata;	
	endtask

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		this.wr_drv_if.wdata <= 0;
		this.wr_drv_if.winc <= 0;
	  repeat(10) @(posedge wr_drv_if.wclk);	
  	for(integer i = 0; i < trans_count_write ; i++) begin 
			txw = write_seq_item::type_id::create("txw");
			seq_item_port.get_next_item(txw);
    	wait(wr_drv_if.wfull == 0);
      drive_write(txw);
      seq_item_port.item_done();
		end
		@(posedge wr_drv_if.wclk);
		this.wr_drv_if.winc = 0;   	
	endtask

endclass:write_driver

//---------------------------------------- Read Driver ------------------------------------------------


class read_driver extends uvm_driver#(read_seq_item);
	`uvm_component_utils(read_driver)

	virtual async_fifo_if rd_drv_if;
	read_seq_item txr;
  int trans_count_read;

	function new(string name = "read_driver", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(virtual async_fifo_if)::get (this, "*", "vif", rd_drv_if))) 
			`uvm_error(get_type_name(), "FAILED to get data from config DB")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task drive_read(read_seq_item txr);
 		@(posedge rd_drv_if.rclk);
  	this.rd_drv_if.rinc = txr.rinc;	
	endtask

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		this.rd_drv_if.rinc <= 0;
    repeat(10) @(posedge rd_drv_if.rclk);	
    for(integer j = 0; j < trans_count_read; j++) begin
        txr = read_seq_item::type_id::create("txr");
				seq_item_port.get_next_item(txr);
        wait(rd_drv_if.rempty == 0);
        drive_read(txr);
        seq_item_port.item_done();
		end
		@(posedge rd_drv_if.rclk);
		this.rd_drv_if.rinc = 0;	
	endtask

endclass:read_driver



