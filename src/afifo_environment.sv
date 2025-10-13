class async_fifo_environment extends uvm_env;

	`uvm_component_utils(async_fifo_environment)

	async_fifo_write_agent wr_agt;
	async_fifo_read_agent  rd_agt;
	async_fifo_subscriber  sub;
	async_fifo_scoreboard  scb;
	async_fifo_virtual_sequencer v_seqr;

	function new(string name = "async_fifo_environment" , uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wr_agt = async_fifo_write_agent::type_id::create("wr_agt",this);
		rd_agt = async_fifo_read_agent::type_id::create("rd_agt",this);
		sub    = async_fifo_subscriber::type_id::create("sub",this);
		scb    = async_fifo_scoreboard::type_id::create("scb",this);
		v_seqr = async_fifo_virtual_sequencer::type_id::create("v_seqr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		wr_agt.write_mon.write_mon_port.connect(scb.write_scb_port);
		wr_agt.write_mon.write_mon_port.connect(sub.cov_write_mon_port);
		rd_agt.read_mon.read_mon_port.connect(scb.read_scb_port);
		rd_agt.read_mon.read_mon_port.connect(sub.cov_read_mon_port);
		v_seqr.write_seqr = wr_agt.write_seqr;
		v_seqr.read_seqr  = rd_agt.read_seqr;	
	endfunction

endclass
