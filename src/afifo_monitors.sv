class async_fifo_write_monitor extends uvm_monitor;

	`uvm_component_utils(async_fifo_write_monitor)
	virtual async_fifo_interface vif;
	write_seq_item write_seq;
	uvm_analysis_port#(write_seq_item) write_mon_port;	

	function new(string name = "async_fifo_write_monitor",uvm_component parent);
		super.new(name,parent);
		write_mon_port = new("write_mon_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		write_seq = write_seq_item::type_id::create("write_seq");
		if(!uvm_config_db#(virtual async_fifo_interface)::get(this,"","vif",vif))
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: ASYNC_FIFO_WRITE_MONITOR ",get_full_name(),".vif"});
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.async_fifo_write_monitor_cb);
		forever begin
			write_monitor();
		end
	endtask

	task write_monitor();
		// write monitor logic
		@(vif.async_fifo_write_monitor_cb);
		write_seq.wrst  = vif.async_fifo_write_monitor_cb.wrst;
		write_seq.winc   = vif.async_fifo_write_monitor_cb.winc;
		write_seq.wdata = vif.async_fifo_write_monitor_cb.wdata;
		write_seq.wfull = vif.async_fifo_write_monitor_cb.wfull;
		write_mon_port.write(write_seq);
	endtask

endclass

//--------------------------------------------- Read Monitor --------------------------------------------//


class async_fifo_read_monitor extends uvm_monitor;

        `uvm_component_utils(async_fifo_read_monitor)
        virtual async_fifo_interface vif;
        read_seq_item read_seq;
        uvm_analysis_port#(read_seq_item) read_mon_port;

        function new(string name = "async_fifo_read_monitor",uvm_component parent);
                super.new(name,parent);
                read_mon_port = new("read_mon_port",this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                read_seq = read_seq_item::type_id::create("read_seq");
                if(!uvm_config_db#(virtual async_fifo_interface)::get(this,"","vif",vif))
                        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ASYNC_FIFO_READ_MONITOR ",get_full_name(),".vif"});
        endfunction

        task run_phase(uvm_phase phase);
                @(vif.async_fifo_read_monitor_cb);
                forever begin
                        read_monitor();
                end
        endtask

        task read_monitor();
                // read monitor logic
                @(vif.async_fifo_read_monitor_cb);
                read_seq.rrst   = vif.async_fifo_read_monitor_cb.rrst;
                read_seq.rinc    = vif.async_fifo_read_monitor_cb.rinc;
                read_seq.rdata  = vif.async_fifo_read_monitor_cb.rdata;
                read_seq.rempty = vif.async_fifo_read_monitor_cb.rempty;
                read_mon_port.write(read_seq);
        endtask

endclass
