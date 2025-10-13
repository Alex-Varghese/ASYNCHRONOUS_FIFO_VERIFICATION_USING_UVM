class write_seq_item extends uvm_sequence_item;

  rand logic wrst;
  rand logic winc;
  rand logic [`DSIZE - 1:0] wdata;
  logic wfull;

  `uvm_object_utils_begin(write_seq_item)
  `uvm_field_int(wrst , UVM_ALL_ON)
  `uvm_field_int(winc , UVM_ALL_ON)
  `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_field_int(wfull, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "write_seq_item");
  	super.new(name);
	endfunction

endclass

// ------------------------------- Read Sequence Item ----------------------------------- //

class read_seq_item extends uvm_sequence_item;

	rand logic rrst;
	rand logic rinc;
	logic [`DSIZE - 1:0]rdata;
	logic rempty;

	`uvm_object_utils_begin(read_seq_item)
	`uvm_field_int(rrst  , UVM_ALL_ON)
	`uvm_field_int(rinc  , UVM_ALL_ON)
	`uvm_field_int(rdata , UVM_ALL_ON)
	`uvm_field_int(rempty, UVM_ALL_ON)
	`uvm_object_utils_end	

	function new(string name = "read_seq_item");
		super.new(name);
	endfunction

endclass
