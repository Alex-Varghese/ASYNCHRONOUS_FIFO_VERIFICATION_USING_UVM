QUESTA := /home/share/questa.csh
SHELL := /bin/csh

IGNORE:
	make clean
	make view

.ONESHELL:

all:
	source $(QUESTA) 
	make clean 
	make compile 
	make simulate

main:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l async_fifo_top.log async_fifo_package.sv top.sv
	clear
	clear
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details

read:
	source $(QUESTA)
	vcover report -details coverage.ucdb

view:
	firefox ./covReport/index.html

compile:
	vlog -sv async_fifo_top.sv

simulate:
	vsim -c top +UVM_VERBOSITY=UVM_MEDIUM -do "run -all;exit"

clean:
	rm -rf transcript work/
	clear
	clear
