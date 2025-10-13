class async_fifo_read_sequence extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(async_fifo_read_sequence)

	function new(string name = "aync_fifo_read_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(`num_of_txns) begin
			req = read_seq_item::type_id::create("read_seq");
			wait_for_grant();
			void'(req.randomize());
			send_request(req);
			wait_for_item_done();
		end
	endtask

endclass

class rrst_sequence extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(rrst_sequence)

	function new(string name = "rrst_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin	 
		  $display("------------------------------ read_reset_seq -----------------------------------\n");
		  `uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 0; })
	  end
		repeat(1) begin
		  `uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 1; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 1; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 1; })
		end
	endtask

endclass

class read_cont_seq extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(read_cont_seq)

	function new(string name = "read_cont_seq");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ read_cont_seq ------------------------\n");
		repeat( `DEPTH ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0 ; })
		end
	endtask

endclass

class read_along_write_seq extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(read_along_write_seq)

	function new(string name = "read_along_write_seq");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ read_along_write_seq ------------------------\n");
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0 ; })
		end
		`uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 0 ; })
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0 ; })
		end
	endtask
endclass

class read_wrap_seq extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(read_wrap_seq)

	function new(string name = "read_wrap_seq");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ read_wrap_seq started ------------------------\n");
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 1 ; })
		end
		`uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 0 ; })
		repeat( `num_of_txns  ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 1 ; })
		end
	endtask
endclass

class read_random_sequence extends uvm_sequence#(read_seq_item);

	`uvm_object_utils(read_random_sequence)

	function new(string name = "read_random_sequence");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ read_seq9 started ------------------------\n");
		`uvm_do_with(req,{ req.rrst == 0 ; req.rinc == 0 ; })
		repeat( `num_of_txns + 1 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0 ; })
		end
		
		repeat( `num_of_txns - 6 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 1 ; })
		end
  	
		repeat( `num_of_txns + 1 ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 0 ; })
		end
		
		repeat( `num_of_txns + 2  ) begin
			`uvm_do_with(req,{ req.rrst == 1 ; req.rinc == 1 ; })
		end

	endtask

endclass



//regression test --

/*
class async_fifo_read_regression extends uvm_sequence#(read_seq_item);
	`uvm_object_utils(async_fifo_read_regression)

	rrst_sequence rd_rst;
	//async_fifo_read_sequence read_seq;
  read_sequence rd_seq;

	function new(string name = "async_fifo_read_regression");
		super.new(name);
	endfunction

	task body();
		`uvm_do(rd_rst);
	 //`uvm_do(read_seq);
		`uvm_do(rd_seq);
	endtask
endclass
*/

