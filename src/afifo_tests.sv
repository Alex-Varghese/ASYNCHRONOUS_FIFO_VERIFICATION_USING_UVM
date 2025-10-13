class async_fifo_test extends uvm_test;

	`uvm_component_utils(async_fifo_test)

	async_fifo_environment env;
	async_fifo_virtual_sequence v_seq;

	function new(string name = "async_fifo_test", uvm_component parent);
		super.new(name,parent);
	endfunction 

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = async_fifo_environment::type_id::create("env",this);
		v_seq = async_fifo_virtual_sequence::type_id::create("v_seq");
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		v_seq.start(env.v_seqr);
		phase.drop_objection(this);
	endtask
endclass


