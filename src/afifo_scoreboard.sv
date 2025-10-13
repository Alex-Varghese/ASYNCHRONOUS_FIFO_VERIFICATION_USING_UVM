`uvm_analysis_imp_decl(_write_mon_scb)
`uvm_analysis_imp_decl(_read_mon_scb)

class async_fifo_scoreboard extends uvm_scoreboard;

	write_seq_item write_mon_queue[$];
	read_seq_item  read_mon_queue[$];

	reg [`DSIZE-1:0] fifo_model[$];

	uvm_analysis_imp_write_mon_scb#(write_seq_item, async_fifo_scoreboard) write_scb_port;
	uvm_analysis_imp_read_mon_scb#(read_seq_item,  async_fifo_scoreboard) read_scb_port;

	int w_match = 0;
	int w_mismatch = 0;
	int r_match  = 0;
	int r_mismatch  = 0;
	static bit read = 1;

	`uvm_component_utils(async_fifo_scoreboard)

	function new(string name = "async_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		write_scb_port = new("write_scb_port", this);
		read_scb_port  = new("read_scb_port", this);
	endfunction

	function void write_write_mon_scb(write_seq_item wr_seq);
		write_mon_queue.push_back(wr_seq);
	endfunction

	function void write_read_mon_scb(read_seq_item rd_seq);
		read_mon_queue.push_back(rd_seq);
	endfunction
	
	task run_phase(uvm_phase phase);
		forever begin
			fork
				begin
					wait(write_mon_queue.size() - 0);
					extract_signals_from_write_monitor();
				end
				begin
					wait(read_mon_queue.size() - 0);
					extract_signals_from_read_monitor();
				end
			join_any
		end
	endtask

	task extract_signals_from_write_monitor();
		
		bit wfull;
		write_seq_item write_seq;
		write_seq = write_mon_queue.pop_front();

		wfull = (fifo_model.size() == (`DEPTH ));
		$display("--------------------------------------------------------------------------------------------");
		$display("\nWRITE_MON: %0t | RST=%b | WINC = %b | DATA = %0d | FULL = %b", $time, write_seq.wrst, write_seq.winc,write_seq.wdata, wfull);

		if (!write_seq.wrst) begin
			fifo_model.delete();
			w_match++;
			$display("--------------------------- write reset condition matched -------------------------------------\n");
			$display("----------------------------------------------------------------------------------------------\n");
		end
		
		else if (write_seq.winc) begin
			if( wfull ) begin
				if( write_seq.wfull ) begin
					w_match++;
				end
				else
				begin
					 $display("--------------------------- write reset condition failed -------------------------------------\n");  
					w_mismatch++;
					`uvm_error(get_type_name(),$sformatf("DUT : FULL = %b", write_seq.wfull));
				end
			end
			
			else begin
				fifo_model.push_back(write_seq.wdata);
				$display("--------------------------- data written into fifo -------------------------------------\n");
				$display("----------------------------------------------------------------------------------------------\n");
			end
		end
	endtask

	task extract_signals_from_read_monitor();
		bit rempty;
		read_seq_item read_seq;  
		read_seq = read_mon_queue.pop_front();

		rempty = (fifo_model.size() == 0);

		$display("--------------------------------------------------------------------------------------------");
		$display("\nDUT @ (%0t) \n RRST = %b | WINC = %b | READ_DATA = %0d | REMPTY = %b",
			$time, read_seq.rrst, read_seq.rinc, read_seq.rdata, rempty);

		if (!read_seq.rrst) begin
		 $display("--------------------------- read reset condition matched -------------------------------------\n");	
			r_match++;
			$display("--------------------------------------------------------------------------------------------\n");
		end
	
		else if (read_seq.rinc) begin

			if (read) begin
				read = 0;  
			end
			else begin
				logic [`DSIZE-1:0] expected_data;
				if (fifo_model.size() - 0)
					expected_data = fifo_model.pop_front();
				else
					expected_data = 'hx;

				if (rempty) begin
					if (read_seq.rempty) begin
						r_match++;
					end
					
					else begin
						r_mismatch++;
						`uvm_error(get_type_name(), $sformatf("DUT : REMPTY = %0b", read_seq.rempty));
						$display("------------------- READ FAIL: rempty mismatch ------------------------\n");
					end
				end
				else begin
					if (read_seq.rdata == expected_data) begin
						 $display("--------------------------- read data condition matched -------------------------------------\n");
						r_match++;
						`uvm_info(get_type_name(), $sformatf("READ PASSED : Expected=%0d | Received=%0d",
							expected_data, read_seq.rdata), UVM_LOW)
						$display("-------------------------------------------------------------------------------------------\n");
					end
					
					else begin
						 $display("--------------------------- read condition failed data not matching -------------------------------------\n");
						r_mismatch++;
						`uvm_error(get_type_name(), $sformatf("READ FAILED: Expected = %0d | Received = %0d",
							expected_data, read_seq.rdata))
						$display("----------------------------------------------------------------------------------------\n");
					end
				
				end
			end
		end
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		$display("\n\n---------------------------------------------\nTotal transactions: %0d\nMATCH = %0d | MISMATCH = %0d ",((w_match+r_match)+(w_mismatch+r_mismatch)),(w_match+r_match), (w_mismatch+r_mismatch));
		$display("\n---------------------------------------------\n");
	endfunction

endclass
