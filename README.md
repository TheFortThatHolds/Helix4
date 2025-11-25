# Helix-4: An Open‑Source Heterogeneous Compute Module

## Overview

Helix‑4 (codename *Ouroboros‑X1*) is a heterogeneous system‑in‑package designed to realize the **Cycle of Expression** in silicon and software.  
This architecture combines four specialized dies—Reservoir, Reactor, Aperture and Loom—linked by an active interposer. Together they embody a complete closed‑loop system for potential → activation → expression → integration.

This repository provides design specifications, diagrams, and pseudocode implementing the **Active Resonance Protocol (ARP)**, a hybrid spiking‑transformer algorithm designed for the Helix‑4 architecture. The project is released under the MIT License to encourage research, modification and community collaboration.

The Cycle of Expression theory proposes that all systems follow a four‑phase process:
1. **Look In** – Potential / structure / latent state.
2. **Spiral Up** – Activation / ignition / expansion.
3. **Flow Out** – Expression / dynamics / event.
4. **Return** – Integration / collapse / encoding.

Helix‑4 maps these phases directly into hardware and software:
- The **Reservoir** stores latent patterns and provides high‑bandwidth associative recall.
- The **Reactor** ignites the latent context and expands it into a high‑dimensional geometry.
- The **Aperture** collapses possibilities into a linear output and transmits it at photonic speeds.
- The **Loom** observes outcomes and physically updates synaptic weights, closing the loop.

See `docs/hardware_spec.md` and `docs/software_spec.md` for full details.

## Contents

- `docs/hardware_spec.md` — Detailed specification of the four Helix‑4 dies and system topology.
- `docs/software_spec.md` — Description of the Active Resonance Protocol (ARP) and pseudocode.
- `src/helix_intelligence.py` — A Pythonic skeleton implementing the ARP main loop.
- `images/hardware_diagram.png` — Diagram of the Helix‑4 hardware architecture.
- `images/software_diagram.png` — Diagram of the ARP algorithm flow.
- `LICENSE` — MIT license.
- `LICENSE2` —CERN-OHL-P v2 license.

## Status

This release is conceptual. It is intended to spark discussion about closed‑loop hardware/software design inspired by the Cycle of Expression. There is no working silicon yet; the files here serve as a reference architecture and learning resource.

## License

This project is dual-licensed:

* **Software:** All software code (e.g., Python files, firmware) is licensed under the **MIT License**. See the `LICENSE` file for details.
* **Hardware:** All hardware designs (e.g., schematics, diagrams, specifications) are licensed under the **CERN-OHL-P v2**. See the `LICENSE2` file for details.

## Open‑Source Guidelines

The project follows best practices described by OSHWA for open‑source hardware projects, including providing a clear overview, original design files, supplementary documentation and software.  
Feedback, pull requests and forks are welcome.

