IVERILOG ?= iverilog
VVP      ?= vvp
BUILD    := build
RTL_DIR  := ../rtl

SV_SRCS := \
	$(RTL_DIR)/helix_pkg.sv \
	$(RTL_DIR)/helix_reservoir.sv \
	$(RTL_DIR)/helix_reactor.sv \
	$(RTL_DIR)/helix_aperture.sv \
	$(RTL_DIR)/helix_loom.sv \
	$(RTL_DIR)/helix4_die.sv \
	tb_helix4.sv

all: run

$(BUILD):
	@mkdir -p $(BUILD)

$(BUILD)/tb_helix4.vvp: $(BUILD) $(SV_SRCS)
	$(IVERILOG) -g2012 -s tb_helix4 -o $@ $(SV_SRCS)

run: $(BUILD)/tb_helix4.vvp
	$(VVP) $<

clean:
	rm -rf $(BUILD)

.PHONY: all run clean