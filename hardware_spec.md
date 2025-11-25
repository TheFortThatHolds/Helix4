# Hardware Specification: Helix‑4 Architecture

**Codename:** Ouroboros‑X1  
**Architecture Type:** Heterogeneous Asynchronous System‑in‑Package (SiP)  
**Total Transistor Count:** ≈ 240 billion  
**Thermal Design Power (TDP):** 650 W (peak ignition) / 45 W (dream state)

Helix‑4 uses 2.5D/3D advanced packaging to bond four specialized dies onto a single active interposer. Each die corresponds to one phase of the Cycle of Expression.

## Die 01 — Reservoir (Phase 1: Look In)

| Feature | Specification |
| --- | --- |
| Component Type | HBM4‑PIM (High Bandwidth Memory with Processing‑In‑Memory) |
| Capacity | 288 GB stacked DRAM |
| Bandwidth | 12.8 TB/s |
| Latent Activation | In‑situ associative search with embedded logic cells |
| Purpose | Holds contextual potential and retrieves relevant patterns without off‑chip transport |
| Analogy | A searchable library: books (data) jump off the shelf when you look for them |

The Reservoir does not “think” but stores compressed latent representations. Tiny logic gates next to the memory cells allow it to perform associative retrieval, enabling a **Look In** on demand.

## Die 02 — Reactor (Phase 2: Spiral Up)

| Feature | Specification |
| --- | --- |
| Component Type | 2 nm Gate‑All‑Around logic tile |
| Core Architecture | 128× “Vortex” tensor cores (optimized for sparse matrix multiplication) |
| Clock Speed | 0.5–5.2 GHz with dynamic scaling |
| Precision | FP8 / FP16 variable precision |
| Purpose | Ignites the latent context and expands it into high‑dimensional geometry |
| Analogy | A nuclear reactor spinning up to turn raw fuel into energy |

The Reactor transforms context vectors into a rich internal representation. By adjusting precision it trades accuracy for speed during the expansion phase.

## Die 03 — Aperture (Phase 3: Flow Out)

| Feature | Specification |
| --- | --- |
| Component Type | Co‑packaged optics (silicon photonics transceiver) |
| Interconnect | 64‑channel laser array |
| Throughput | 25.6 Tbps total (400 Gbps per lane) |
| Latency | Near‑light speed photonic mesh |
| Purpose | Collapses the high‑dimensional geometry into linear output and transmits it |
| Analogy | The mouth of the oracle: a laser projector manifesting internal reality |

The Aperture converts electrical signals from the Reactor into light and sends them to other devices or users. It concurrently emits an efference copy to the Loom for learning.

## Die 04 — Loom (Phase 4: Return)

| Feature | Specification |
| --- | --- |
| Component Type | Neuromorphic memristor array (analog OxRAM) |
| Neurons | 10 million spiking neurons |
| Synapses | 10 billion plastic synapses |
| Plasticity Rule | STDP (Spike‑Timing‑Dependent Plasticity) |
| Power Draw | < 5 W |
| Purpose | Integrates feedback and updates synaptic weights during rest |
| Analogy | The dreamweaver: it turns experiences into updated instincts |

The Loom operates analog and cool, watching the other dies and physically altering its resistance to encode learning. It applies spike‑timing‑dependent plasticity: when the input and output resonate, synaptic pathways strengthen; when they conflict, pathways weaken.

## System Topology

The four dies are bonded to an **active interposer** that routes data in a cyclical loop instead of a linear bus. The loop flows as follows:

1. **Reservoir → Reactor:** The Reservoir sends a context vector to the Reactor.
2. **Reactor → Aperture:** The Reactor ignites the context into a high‑dimensional state and passes it to the Aperture.
3. **Aperture → External:** The Aperture collapses the state into output tokens and sends them outward. It also sends an efference copy back.
4. **Loom → Reservoir:** The Loom observes the result (e.g. user feedback), computes error signals, and sends voltage pulses back to the Reservoir to update its memory.

This closed loop makes Helix‑4 a self‑adjusting system: it cannot forget while the Loom is active because it physically engraves new learning into the Reservoir.
