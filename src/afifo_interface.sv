interface async_fifo_interface(input bit wclk , rclk);

	logic wrst , rrst;
	logic winc  , rinc;
	logic [ `DSIZE - 1 : 0 ] wdata , rdata;
	logic wfull , rempty;

	//always@(wclk or rclk) $display(" DUT : write_ptr = %b , read_ptr = %b", dut.waddr , dut.raddr );
	
	clocking async_fifo_read_driver_cb@(posedge rclk);
		default input #1 output #1;
		output rrst , rinc;	
	endclocking

	clocking async_fifo_write_driver_cb@(posedge wclk);
		default input #1 output #1;
		output wrst , winc , wdata;	
	endclocking

	clocking async_fifo_read_monitor_cb@(posedge rclk);
		default input #1 output #1;
		input rrst , rinc, rdata, rempty;	
	endclocking

	clocking async_fifo_write_monitor_cb@(posedge wclk);
		default input #1 output #1;
		input wrst , winc , wdata, wfull;	
	endclocking

	modport READ_DRIVER(clocking async_fifo_read_driver_cb);
	modport WRITE_DRIVER(clocking async_fifo_write_driver_cb);
	modport READ_MONITOR(clocking async_fifo_read_monitor_cb);
	modport WRITE_MONITOR(clocking async_fifo_write_monitor_cb);

endinterface
