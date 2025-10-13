`include "defines.sv"

class async_fifo_virtual_sequence extends uvm_sequence;

	`uvm_object_utils(async_fifo_virtual_sequence)
	`uvm_declare_p_sequencer(async_fifo_virtual_sequencer)

	wrst_sequence wrst_seq;
	rrst_sequence rrst_seq;
	write_cont_seq w_cont_seq;
	read_cont_seq r_cont_seq;
	write_along_read_seq w_and_r_seq;
	read_along_write_seq r_and_w_seq;
	write_wrap_seq w_wrap_seq;
	read_wrap_seq r_wrap_seq;
	write_random_sequence w_rand_seq;
	read_random_sequence r_rand_seq;

	function new(string name = "async_fifo_virtual_sequence");
		super.new(name);
		wrst_seq =	wrst_sequence::type_id::create("wrst_seq");
		rrst_seq =	rrst_sequence::type_id::create("rrst_seq");
		w_cont_seq =	write_cont_seq::type_id::create("w_cont_seq");
		r_cont_seq =	read_cont_seq::type_id::create("r_cont_seq");
		w_and_r_seq =	write_along_read_seq::type_id::create("w_and_r_seq");
		r_and_w_seq =	read_along_write_seq::type_id::create("r_and_w_seq");
		w_wrap_seq =	write_wrap_seq::type_id::create("w_wrap_seq");
		r_wrap_seq =	read_wrap_seq::type_id::create("r_wrap_seq");
		w_rand_seq =	write_random_sequence::type_id::create("w_rand_seq");
		r_rand_seq =	read_random_sequence::type_id::create("r_rand_seq");
	endfunction 

	task body();
		//reset swquence 1
		if( `test == 1 || `run_all) begin
		//fork
				wrst_seq.start(p_sequencer.write_seqr);
				rrst_seq.start(p_sequencer.read_seqr);
		//join
    end
		// continous read write
  	if (`test == 2 || `run_all) begin
		//fork
				w_cont_seq.start(p_sequencer.write_seqr);
				r_cont_seq.start(p_sequencer.read_seqr);
		//join
		end
		
		// sinultaneous read write sequence
	  if (`test == 3 || `run_all) begin
		//fork
				w_and_r_seq.start(p_sequencer.write_seqr);
				r_and_w_seq.start(p_sequencer.read_seqr);
		//join
		end

		// wrap sequence
	  if (`test == 4 || `run_all) begin
		//fork
				r_wrap_seq.start(p_sequencer.read_seqr);
				w_wrap_seq.start(p_sequencer.write_seqr);
		//join
		end

		// random sequence
	  if (`test == 5 || `run_all) begin
		//fork
				r_rand_seq.start(p_sequencer.read_seqr);
				w_rand_seq.start(p_sequencer.write_seqr);
		//join
    end
	endtask
endclass

