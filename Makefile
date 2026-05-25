.PHONY: help sim wave inject wave-inject synth fault-atpg clean

help:
	@echo "Available commands:"
	@echo "- make sim: Run golden RTL simulation"
	@echo "- make wave: Open golden waveform"
	@echo "- make inject: Run manual stuck-at fault injection simulation"
	@echo "- make wave-inject: Open fault injection waveform"
	@echo "- make synth: Run Yosys synthesis"
	@echo "- make fault-atpg: Run ATPG using Fault"
	@echo "- make clean: Remove generated files"

sim:
	mkdir -p results
	iverilog -o results/simple_tb tb/simple_tb.v rtl/simple.v
	vvp results/simple_tb

wave:
	gtkwave results/simple.vcd

inject:
	mkdir -p results
	iverilog -o results/fault_injection_tb tb/fault_injection_tb.v rtl/simple.v rtl/simple_sa0.v rtl/simple_sa1.v
	vvp results/fault_injection_tb

wave-inject:
	gtkwave results/fault_injection.vcd

synth:
	mkdir -p netlists
	yosys -p "read_verilog rtl/simple.v; synth -top simple_logic; write_verilog -noattr netlists/simple_synth.v"

fault-atpg:
	mkdir -p atpg/patterns atpg/reports atpg/logs
	fault netlists/simple_synth.v 2>&1 | tee atpg/logs/fault_atpg.log

clean:
	rm -rf results/* netlists/* atpg/patterns/* atpg/reports/* atpg/logs/*