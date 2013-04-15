all:	lint testbench

lint:	$(wildcard *.v)
	verilator --lint-only uart.v

testbench:	$(wildcard *.v)
	iverilog -Wall testbench.v -o $@

check:	testbench
	vvp ./testbench

clean:
	rm -f testbench *.vcd
