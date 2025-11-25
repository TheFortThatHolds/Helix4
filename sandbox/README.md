# Sandbox Usage Notes

- `sim/` doubles as a sandboxed RTL environment. Builds happen under `sim/build` so gate-level or waveform artifacts never pollute the repo root.
- `tests/` is isolated for Python-driven ARP/firmware sims. Use `python -m venv sandbox/.venv && sandbox/.venv/Scripts/activate` before running `pytest` if you want to keep dependencies scoped.
- When heavier EDA flows are available, create sibling folders under `sandbox/` (e.g., `sandbox/asic`, `sandbox/fpga`) to house tool-specific databases, floorplans, and scratch files.
- Nothing inside `sandbox/` is required for tape-out; feel free to add it to `.gitignore` entries if you produce large experimental datasets.