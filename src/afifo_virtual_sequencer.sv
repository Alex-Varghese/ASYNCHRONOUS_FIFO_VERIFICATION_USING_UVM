class async_fifo_virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(async_fifo_virtual_sequencer)

	async_fifo_write_sequencer write_seqr;
	async_fifo_read_sequencer read_seqr;

	function new(string name = "async_fifo_virtual_sequencer", uvm_component parent );
		super.new(name, parent);
	endfunction

endclass
