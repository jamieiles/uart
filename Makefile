all:	testbench

testbench:	$(wildcard *.v)
	iverilog -Wall testbench.v -o $@

test:	testbench
	vvp ./testbench

clean:
	rm -f testbench *.vcd
