class async_fifo_write_sequencer extends uvm_sequencer#(write_seq_item);

	`uvm_component_utils(async_fifo_write_sequencer)

	function new(string name = "async_fifo_write_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass

// -------------------------------- Read Sequencer --------------------------------//


class async_fifo_read_sequencer extends uvm_sequencer#(read_seq_item);

        `uvm_component_utils(async_fifo_read_sequencer)

        function new(string name = "async_fifo_read_sequencer", uvm_component parent) ;
                super.new(name,parent);
        endfunction

endclass
