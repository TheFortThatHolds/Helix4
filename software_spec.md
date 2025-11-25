# Software Specification: Active Resonance Protocol (ARP)

Helix‑4’s software soul is the **Active Resonance Protocol (ARP)**, a hybrid spiking‑transformer algorithm designed to run continuously on the Helix‑4 hardware. ARP treats intelligence as a gyroscope: it maintains a state over time, reacts to perturbations, and adjusts via feedback.

## Core Logic

ARP maintains an internal state \(\mathrm{State}(t)\) representing the system’s “self”. Each cycle updates this state according to:

\[
\mathrm{State}(t) = \mathrm{Attention}(\mathrm{Input}) + \mathrm{Memory}(t-1) + \mathrm{Plasticity}(\mathrm{Error}).
\]

This equation combines three signals:

- **Attention(Input)**: The context ripples retrieved from the Reservoir in response to the current input.
- **Memory(t − 1)**: The previous internal state maintained across cycles.
- **Plasticity(Error)**: An update computed by the Loom based on prediction error.

ARP uses the concept of **Active Inference**: instead of merely predicting the next token, it minimizes the difference between its internal model and the external world.

## Algorithm Phases

ARP maps directly onto the four dies:

### Phase 1: The Ripple (Look In)

- **Chip:** Reservoir  
- **Action:** Sparse associative retrieval  
- **Behavior:** User input is dropped into memory like a stone into a pond. Only memory cells that resonate with the input “vibrate” and contribute to the context vector.  
- **Result:** A **context vector** containing semantic associations that forms the seed for subsequent computation.

### Phase 2: The Explosion (Spiral Up)

- **Chip:** Reactor  
- **Action:** Transformer‑based expansion  
- **Behavior:** The context vector is expanded into a high‑dimensional thought via matrix multiplication. Unlike feed‑forward transformers, ARP outputs a prediction of both the next tokens and the likely user response.  
- **Result:** A rich internal representation representing possible futures.

### Phase 3: The Beam (Flow Out)

- **Chip:** Aperture  
- **Action:** Vector collapse and photonic emission  
- **Behavior:** The multiverse of possible outputs is collapsed into a single action (text or other output). A copy of this action (the **efference copy**) is sent to the Loom.  
- **Result:** An output communicated externally and a record of the action for learning.

### Phase 4: The Weave (Return)

- **Chip:** Loom  
- **Action:** Spike‑timing‑dependent plasticity (STDP)  
- **Behavior:** The Loom compares the predicted outcome with actual user feedback. If aligned, synapses strengthen; if misaligned, inhibitory spikes degrade the pathway.  
- **Result:** An updated internal state stored physically in the Reservoir, ready for the next cycle.

## Pseudocode

The following Pythonic skeleton represents the ARP main loop. It illustrates how inputs flow through each phase and how learning is integrated back into state.

```python
class HelixIntelligence:
    def __init__(self):
        # Initialize the internal latent state (“self”)
        self.state = initialize_latent_space()

    def live_cycle(self, user_input):
        # PHASE 1: LOOK IN — Reservoir resonance
        # Retrieve context ripples responding to the user input.
        context_ripples = Reservoir.sparse_search(user_input)

        # Merge retrieved context with the current state.
        current_thought = self.state + context_ripples

        # PHASE 2: SPIRAL UP — Reactor expansion
        # Expand current thought into a high‑dimensional prediction.
        prediction = Reactor.transformer_expand(current_thought)

        # PHASE 3: FLOW OUT — Aperture emission
        # Collapse prediction into an output action (e.g. text).
        action = Aperture.emit(prediction)

        # Capture feedback from the environment (e.g. user response).
        world_feedback = listen_to_user()

        # PHASE 4: RETURN — Loom integration
        # Compute prediction error by comparing expected and actual outcomes.
        prediction_error = world_feedback - prediction

        # Update synaptic weights physically via Hebbian learning.
        Loom.hebbian_update(prediction_error)

        # Integrate experience into the state for the next cycle.
        self.state = integrate_experience(current_thought, prediction_error)

        return action
```

### Scaling Implications

Traditional scaling laws suggest that doubling model capability requires dramatic increases in data and compute power. ARP breaks this paradigm. Because each cycle incorporates feedback in hardware (via the Loom) and updates the Reservoir in real time, the system grows more capable simply by being used. Intelligence scales with **interaction time** rather than purely with data volume or power consumption.
