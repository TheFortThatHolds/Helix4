# Helix-4 RTL + Tape-Out Readiness Plan

## RTL Block Hierarchy
1. `helix_pkg.sv` captures canonical bus widths and packet structs shared across the design.
2. `helix_reservoir.sv`: models HBM4-PIM look-in behavior with feedback mixing, exposes ready/valid context streaming and accepts Loom deltas.
3. `helix_reactor.sv`: parameterized transformer/tensor expansion surrogate that reacts to `precision_mode` signals for dynamic FP8/FP16 analogs.
4. `helix_aperture.sv`: collapses thought vectors into actions plus an efference copy that flows to the Loom, enforcing fan-out health via ready/valid coupling.
5. `helix_loom.sv`: calculates prediction error by comparing environment feedback with efference data and produces memristor-style deltas for the Reservoir.
6. `helix4_die.sv`: integrates the four dies into a closed loop with automatic precision stepping, representing a single Helix-4 package with external stimuli and action ports.
7. `helix4_quad_cluster.sv`: tiles four dies to represent one cognitive organ within the Quad Cluster architecture document.

## Interface Summary
- **Clock/Reset:** single `clk`, active-low `rst_n` for synchronous RTL; future revisions can split per-die power domains but the handshake remains cycle-accurate.
- **Stimulus Bus:** `user_valid`, `user_ready`, `user_data[INPUT_W-1:0]` drive the Reservoir; semantics map to "Look In" requests.
- **Phase Handshakes:** every boundary uses ready/valid semantics with width parameters set in `helix_pkg.sv`.
- **Precision Control:** Reactor exposes `precision_mode[1:0]` from the top level; hooking into DVFS hooks later is straightforward.
- **Action Interface:** `action_valid/ready/action_data` from Aperture support optical serdes encapsulation; efference copy uses identical handshake toward the Loom.
- **Feedback Bus:** Loom emits `feedback_delta[FEEDBACK_W-1:0]` with ready/valid semantics; currently looped back internally but the port is available for chip-to-chip routing.

## Verification Strategy
1. **Module-Level:** Develop SVUnit/UVM agents per block validating handshake compliance, latency, and deterministic placeholder math (e.g., XOR mixing, precision rotation).
2. **Top-Level Cycle Tests:** Build a constrained-random testbench that injects user stimuli, provides stochastic world feedback, and ensures the loop never deadlocks; scoreboard ensures actions reflect known transforms of stimuli.
3. **Quad Cluster Emulation:** Compose four-die models and introduce phase-offset clocks to ensure CDC wrappers behave; create portable Stimulus/Expectation library for multi-organ gating.
4. **Formal LINT + CDC:** Run Spyglass or Ascent linting plus CDC on each module to ensure handshake correctness and metastability safety before we swap placeholders for true compute macros.
5. **Analog/Photonic Co-Simulation Hooks:** Replace Aperture and Loom placeholders with black-box wrappers featuring RNM/Verilog-A ports for photonic Tx and memristor arrays; plan cosim harness with Cadence AMS Designer.

## Tape-Out Checklist
- [ ] Freeze RTL drop (`rtl/` contents) after coverage > 95% functional.
- [ ] Synthesize `helix4_die` through DC/Nexus to validate 650 W ceiling under slow-corner libraries.
- [ ] Floorplan four die macros + interposer TSV map; ensure thermal islands (Reservoir hot, Loom cool) align with packaging spec.
- [ ] Integrate photonic IO macros (25.6 Tbps) at Aperture edges, with serpentine waveguide clearances.
- [ ] Embed neuromorphic memristor macro abstracts for Loom, including STDP bias rails.
- [ ] Run EM/IR on interposer loop to confirm simultaneous switching noise for 12.8 TB/s HBM bus is mitigated.
- [ ] Sign-off: STA (multi-corner), DRC/LVS (TSMC 2 nm), package-coupled SI analysis, reliability (electromigration, TDDB) for 45 W dream state + 650 W ignition.
- [ ] Prepare GDS export + photonic mask set + memristor BEOL stack instructions and deliver to foundry partner.

## Next Steps
- Instantiate behavioral transactors for DNA/quantum extensions to exercise alternative workloads.
- Attach software-controller stub (from `helix_intelligence.py`) via DPI to test the ARP across RTL.
- Define register map for firmware configuration (precision, gating, STDP parameters) to unblock bring-up firmware.