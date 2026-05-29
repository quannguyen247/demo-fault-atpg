.PHONY: help clean
.PHONY: sim-1 fault-1 wave-1 synth-1 atpg-1
.PHONY: sim-2 fault-2 wave-2 synth-2 atpg-2
.PHONY: sim-3 fault-3 wave-3 synth-3 atpg-3
.PHONY: sim-4 wave-4 synth-4 atpg-4
.PHONY: sim-5 wave-5 synth-5 atpg-5
.PHONY: atpg-all

# ==============================================================================
# Help
# ==============================================================================

help:
	@echo "============================================"
	@echo "  DFT / ATPG Demo - Available Commands"
	@echo "============================================"
	@echo ""
	@echo "--- Step 1: Combinational (simple.v) ---"
	@echo "  make sim-1       Run golden simulation"
	@echo "  make fault-1     Run fault injection"
	@echo "  make wave-1      Open waveform"
	@echo "  make synth-1     Synthesize with Yosys"
	@echo "  make atpg-1      Run Fault ATPG"
	@echo ""
	@echo "--- Step 2: Sequential (simple_seq.v) ---"
	@echo "  make sim-2       Run golden simulation"
	@echo "  make fault-2     Run fault injection"
	@echo "  make wave-2      Open waveform"
	@echo "  make synth-2     Synthesize with Yosys"
	@echo "  make atpg-2      Run Fault ATPG"
	@echo ""
	@echo "--- Step 3: DFT Fix (simple_seq_scan.v) ---"
	@echo "  make sim-3       Run golden simulation"
	@echo "  make fault-3     Run fault injection"
	@echo "  make wave-3      Open waveform"
	@echo "  make synth-3     Synthesize with Yosys"
	@echo "  make atpg-3      Run Fault ATPG"
	@echo ""
	@echo "--- Step 4: Redundant Logic (redundant_comb.v) ---"
	@echo "  make sim-4       Run golden simulation"
	@echo "  make wave-4      Open waveform"
	@echo "  make synth-4     Synthesize (no opt, keeps redundancy)"
	@echo "  make atpg-4      Run Fault ATPG"
	@echo ""
	@echo "--- Step 5: Partial Scan (partial_scan.v) ---"
	@echo "  make sim-5       Run golden simulation"
	@echo "  make wave-5      Open waveform"
	@echo "  make synth-5     Synthesize with Yosys"
	@echo "  make atpg-5      Run Fault ATPG"
	@echo ""
	@echo "--- All ---"
	@echo "  make atpg-all    Synth + ATPG for all 5 steps"
	@echo "  make clean       Remove generated files"

# ==============================================================================
# Step 1: Combinational Logic (simple.v)
# ==============================================================================

sim-1:
	mkdir -p results
	iverilog -o results/simple_tb tb/simple_tb.v rtl/simple.v
	vvp results/simple_tb

fault-1:
	mkdir -p results
	iverilog -o results/simple_fault_tb tb/simple_fault_tb.v rtl/simple.v rtl/simple_sa0.v rtl/simple_sa1.v
	vvp results/simple_fault_tb

wave-1:
	gtkwave results/simple.vcd

synth-1:
	mkdir -p netlists
	yosys -p "read_verilog rtl/simple.v; hierarchy -top simple_logic; proc; opt; techmap; opt; write_verilog -noattr -noexpr netlists/simple_synth.v"

atpg-1:
	mkdir -p atpg/work atpg/logs
	cd atpg/work && fault atpg \
		-c /usr/share/yosys/simcells.v \
		--clock clk \
		../../netlists/simple_synth.v \
		2>&1 | tee ../logs/atpg_step1.log

# ==============================================================================
# Step 2: Sequential Logic (simple_seq.v)
# ==============================================================================

sim-2:
	mkdir -p results
	iverilog -o results/simple_seq_tb tb/simple_seq_tb.v rtl/simple_seq.v
	vvp results/simple_seq_tb

fault-2:
	mkdir -p results
	iverilog -o results/simple_seq_fault_tb tb/simple_seq_fault_tb.v rtl/simple_seq.v rtl/simple_seq_sa0.v rtl/simple_seq_sa1.v
	vvp results/simple_seq_fault_tb

wave-2:
	gtkwave results/simple_seq.vcd

synth-2:
	mkdir -p netlists
	yosys -p "read_verilog rtl/simple_seq.v; synth -top simple_seq; write_verilog -noattr -noexpr netlists/simple_seq_synth.v"

atpg-2:
	mkdir -p atpg/work atpg/logs
	cd atpg/work && fault atpg \
		-c /usr/share/yosys/simcells.v \
		--clock clk \
		--reset rst \
		../../netlists/simple_seq_synth.v \
		2>&1 | tee ../logs/atpg_step2.log

# ==============================================================================
# Step 3: DFT Fix - Combinational Extraction (simple_seq_scan.v)
# ==============================================================================

sim-3:
	mkdir -p results
	iverilog -o results/simple_seq_scan_tb tb/simple_seq_scan_tb.v rtl/simple_seq_scan.v
	vvp results/simple_seq_scan_tb

fault-3:
	mkdir -p results
	iverilog -o results/simple_seq_scan_fault_tb tb/simple_seq_scan_fault_tb.v rtl/simple_seq_scan.v rtl/simple_seq_scan_sa0.v rtl/simple_seq_scan_sa1.v
	vvp results/simple_seq_scan_fault_tb

wave-3:
	gtkwave results/simple_seq_scan.vcd

synth-3:
	mkdir -p netlists
	yosys -p "read_verilog rtl/simple_seq_scan.v; hierarchy -top simple_seq_comb; proc; opt; techmap; opt; write_verilog -noattr -noexpr netlists/simple_seq_comb_synth.v"

atpg-3:
	mkdir -p atpg/work atpg/logs
	cd atpg/work && fault atpg \
		-c /usr/share/yosys/simcells.v \
		--clock clk \
		../../netlists/simple_seq_comb_synth.v \
		2>&1 | tee ../logs/atpg_step3.log

# ==============================================================================
# Step 4: Redundant Logic (redundant_comb.v)
# ==============================================================================

sim-4:
	mkdir -p results
	iverilog -o results/redundant_comb_tb tb/redundant_comb_tb.v rtl/redundant_comb.v
	vvp results/redundant_comb_tb

wave-4:
	gtkwave results/redundant_comb.vcd

synth-4:
	mkdir -p netlists
	yosys -p "read_verilog rtl/redundant_comb.v; hierarchy -top redundant_comb; proc; techmap; write_verilog -noattr -noexpr netlists/redundant_comb_synth.v"

atpg-4:
	mkdir -p atpg/work atpg/logs
	cd atpg/work && fault atpg \
		-c /usr/share/yosys/simcells.v \
		--clock clk \
		../../netlists/redundant_comb_synth.v \
		2>&1 | tee ../logs/atpg_step4.log

# ==============================================================================
# Step 5: Partial Scan (partial_scan.v)
# ==============================================================================

sim-5:
	mkdir -p results
	iverilog -o results/partial_scan_tb tb/partial_scan_tb.v rtl/partial_scan.v
	vvp results/partial_scan_tb

wave-5:
	gtkwave results/partial_scan.vcd

synth-5:
	mkdir -p netlists
	yosys -p "read_verilog rtl/partial_scan.v; synth -top partial_scan; write_verilog -noattr -noexpr netlists/partial_scan_synth.v"

atpg-5:
	mkdir -p atpg/work atpg/logs
	cd atpg/work && fault atpg \
		-c /usr/share/yosys/simcells.v \
		--clock clk \
		--reset rst \
		../../netlists/partial_scan_synth.v \
		2>&1 | tee ../logs/atpg_step5.log

# ==============================================================================
# Run all ATPG
# ==============================================================================

atpg-all: synth-1 synth-2 synth-3 synth-4 synth-5 atpg-1 atpg-2 atpg-3 atpg-4 atpg-5

# ==============================================================================
# Clean
# ==============================================================================

clean:
	rm -rf results/* netlists/* atpg/work/* atpg/logs/* atpg/patterns/* atpg/reports/*