class afifo_base_sequence extends uvm_sequence#(write_seq_item);
	`uvm_object_utils(afifo_base_sequence)

	function new(string name = "afifo_base_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(`num_of_txns) begin
			req = write_seq_item::type_id::create("write_seq");
			wait_for_grant();
			void'(req.randomize());
			send_request(req);
			wait_for_item_done();
		end
	endtask

endclass

class wrst_sequence extends uvm_sequence#(write_seq_item);
	`uvm_object_utils(wrst_sequence)

	function new(string name = "wrst_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin	 
		$display("------------------------------ write_reset_seq started -----------------------------------\n");
		  `uvm_do_with(req,{ req.wrst == 0 ; req.winc == 0; req.wdata inside {[0:255]}; })
	  end
		repeat(1) begin
		  `uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.wrst == 1 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
		repeat(1) begin
		  `uvm_do_with(req,{ req.wrst == 0 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
	endtask

endclass

class write_cont_seq extends uvm_sequence#(write_seq_item);

	`uvm_object_utils(write_cont_seq)

	function new(string name = "write_cont_seq");
		super.new(name);
	endfunction

	task body();
		$display("------------------------------ write_cont_seq ------------------------\n");
		repeat(`DEPTH) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
	endtask
endclass

class write_along_read_seq extends uvm_sequence#(write_seq_item);

	`uvm_object_utils(write_along_read_seq)

	function new(string name = "write_along_read_seq");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ write_along_read_seq ------------------------\n");
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
		`uvm_do_with(req,{ req.wrst == 0 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
	endtask

endclass

class write_wrap_seq extends uvm_sequence#(write_seq_item);

	`uvm_object_utils(write_wrap_seq)

	function new(string name = "write_wrap_seq");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ write_wrap_seq ------------------------\n");
		repeat( `num_of_txns - 4 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		end
		`uvm_do_with(req,{ req.wrst == 0 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		repeat( `num_of_txns ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		end
	endtask

endclass

class write_random_sequence extends uvm_sequence#(write_seq_item);

	`uvm_object_utils(write_random_sequence)

	function new(string name = "write_random_sequence");
		super.new(name);
	endfunction

	task body();
	  $display("------------------------------ write_random_seq ------------------------\n");
		`uvm_do_with(req,{ req.wrst == 0 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		repeat( `num_of_txns + 1 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
		
		repeat( `num_of_txns - 6 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		end
  	
		repeat( `num_of_txns + 1 ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 1 ; req.wdata inside {[0:255]}; })
		end
		
		repeat( `num_of_txns + 2  ) begin
			`uvm_do_with(req,{ req.wrst == 1 ; req.winc == 0 ; req.wdata inside {[0:255]}; })
		end

	endtask

endclass


//regression test --
/*
class async_fifo_write_regression extends uvm_sequence#(write_seq_item);
	`uvm_object_utils(async_fifo_write_regression)

	wrst_sequence wr_rst;
	write_sequence wr_seq;
	//async_fifo_write_sequence write_seq;

	function new(string name = "async_fifo_write_regression");
		super.new(name);
	endfunction

	task body();
		`uvm_do(wr_rst);
		//`uvm_do(write_seq);
		`uvm_do(wr_seq);
	endtask
endclass

*/
