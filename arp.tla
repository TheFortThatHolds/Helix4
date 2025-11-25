---------------- MODULE arp ----------------

EXTENDS Naturals, Sequences, Reals

(* --algorithm arp

variables
  state = 0,
  user_input = "",
  world_feedback = 0,
  pc = "LiveCycle"

define
  \* Type invariants
  TypeOK ==
    /\ state \in Real
    /\ user_input \in STRING
    /\ world_feedback \in Real

  \* Placeholder functions for each subsystem
  SparseSearch(input) == 0
  TransformerExpand(thought) == 0
  Emit(prediction) == prediction
  ListenToUser() == 0
  HebbianUpdate(error) == TRUE
  IntegrateExperience(thought, error) == thought
end define;

process LiveCycle = "LiveCycle"
variables
  context_ripples = 0,
  current_thought = 0,
  prediction = 0,
  action = 0,
  prediction_error = 0

begin
  LookIn:
    context_ripples := SparseSearch(user_input);
    current_thought := state + context_ripples;
  SpiralUp:
    prediction := TransformerExpand(current_thought);
  FlowOut:
    action := Emit(prediction);
    world_feedback := ListenToUser();
  Return:
    prediction_error := world_feedback - prediction;
    assert HebbianUpdate(prediction_error);
    state := IntegrateExperience(current_thought, prediction_error);
    pc := "LiveCycle";
end process

end algorithm; *)

\* Translation of the above PlusCal algorithm to TLA+
=============================================================================
VARIABLES state, user_input, world_feedback, pc

(* Let's define some dummy values for the things we don't have a type for *)
STRING == {""}

vars == << state, user_input, world_feedback, pc >>

ProcSet == {"LiveCycle"}

Init == (* Global variables *)
        /\ state = 0
        /\ user_input = ""
        /\ world_feedback = 0
        /\ pc = "LiveCycle"

LookIn == /\ pc = "LiveCycle"
          /\ pc' = "SpiralUp"
          /\ UNCHANGED << state, user_input, world_feedback >>

SpiralUp == /\ pc = "SpiralUp"
            /\ pc' = "FlowOut"
            /\ UNCHANGED << state, user_input, world_feedback >>

FlowOut == /\ pc = "FlowOut"
           /\ pc' = "Return"
           /\ world_feedback' = 0
           /\ UNCHANGED << state, user_input >>

Return == /\ pc = "Return"
          /\ LET prediction_error == world_feedback - (0) \* expand(current_thought) is 0
             IN LET current_thought == state + 0 \* sparse_search is 0
                IN state' = current_thought
          /\ pc' = "LiveCycle"
          /\ UNCHANGED << user_input, world_feedback >>

Next == LookIn \/ SpiralUp \/ FlowOut \/ Return

Spec == Init /\ [][Next]_vars

=============================================================================
