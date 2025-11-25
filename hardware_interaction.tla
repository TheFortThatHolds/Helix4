---------------- MODULE hardware_interaction ----------------

EXTENDS Naturals, Sequences, Reals

(* This module formalizes the hardware interaction and data flow between the four Helix-4 dies. *)

(* --algorithm hardware_interaction

variables
  (* Data flowing between dies *)
  res_to_rea_data = 0,     (* Context vector from Reservoir to Reactor *)
  rea_to_ape_data = 0,     (* Expanded state from Reactor to Aperture *)
  ape_to_ext_data = 0,     (* Output tokens to external systems *)
  ape_to_loo_data = 0,     (* Efference copy from Aperture to Loom *)
  loo_to_res_data = 0,     (* Error signals from Loom to Reservoir *)

  (* Control flags to manage data flow and readiness *)
  res_data_ready = FALSE,  (* True when Reservoir has data for Reactor *)
  rea_data_ready = FALSE,  (* True when Reactor has data for Aperture *)
  ape_ext_data_ready = FALSE, (* True when Aperture has data for external *)
  ape_loo_data_ready = FALSE, (* True when Aperture has data for Loom *)
  loo_data_ready = FALSE;  (* True when Loom has data for Reservoir *)

fair process Reservoir = "Reservoir"
variables pc_res = "Init"
begin
  Init:
    while TRUE do
      (* Look In: Receive error signals from Loom *)
      await loo_data_ready;
      pc_res := "ReceiveError";
      (* Process error signals to update internal memory (not explicitly modeled here) *)
      loo_data_ready := FALSE;

      (* Look In / Spiral Up: Generate context vector *)
      pc_res := "GenerateContext";
      (* Simulate generating a context vector *)
      res_to_rea_data := res_to_rea_data + 1; (* Placeholder for actual computation *)
      res_data_ready := TRUE;
      pc_res := "SendContext";
    end while;
end process;

fair process Reactor = "Reactor"
variables pc_rea = "Init"
begin
  Init:
    while TRUE do
      (* Look In: Receive context vector from Reservoir *)
      await res_data_ready;
      pc_rea := "ReceiveContext";
      (* Process context vector *)
      res_data_ready := FALSE;

      (* Spiral Up: Expand state *)
      pc_rea := "ExpandState";
      (* Simulate expanding the state *)
      rea_to_ape_data := rea_to_ape_data + 1; (* Placeholder *)
      rea_data_ready := TRUE;
      pc_rea := "SendExpandedState";
    end while;
end process;

fair process Aperture = "Aperture"
variables pc_ape = "Init"
begin
  Init:
    while TRUE do
      (* Look In: Receive expanded state from Reactor *)
      await rea_data_ready;
      pc_ape := "ReceiveExpandedState";
      (* Process expanded state *)
      rea_data_ready := FALSE;

      (* Flow Out: Generate external output and efference copy *)
      pc_ape := "GenerateOutput";
      (* Simulate generating output tokens and efference copy *)
      ape_to_ext_data := ape_to_ext_data + 1; (* Placeholder *)
      ape_to_loo_data := ape_to_loo_data + 1; (* Placeholder *)
      ape_ext_data_ready := TRUE;
      ape_loo_data_ready := TRUE;
      pc_ape := "SendOutput";
    end while;
end process;

fair process Loom = "Loom"
variables pc_loo = "Init"
begin
  Init:
    while TRUE do
      (* Look In: Receive efference copy from Aperture *)
      await ape_loo_data_ready;
      pc_loo := "ReceiveEfferenceCopy";
      (* Process efference copy and compute error signals *)
      ape_loo_data_ready := FALSE;

      (* Return: Generate error signals *)
      pc_loo := "GenerateError";
      (* Simulate generating error signals *)
      loo_to_res_data := loo_to_res_data + 1; (* Placeholder *)
      loo_data_ready := TRUE;
      pc_loo := "SendErrorSignals";
    end while;
end process;

end algorithm; *)

\* Translation of the above PlusCal algorithm to TLA+
=============================================================================
VARIABLES res_to_rea_data, rea_to_ape_data, ape_to_ext_data, ape_to_loo_data, loo_to_res_data, 
          res_data_ready, rea_data_ready, ape_ext_data_ready, ape_loo_data_ready, loo_data_ready,
          pc_res, pc_rea, pc_ape, pc_loo

vars == << res_to_rea_data, rea_to_ape_data, ape_to_ext_data, ape_to_loo_data, loo_to_res_data,
            res_data_ready, rea_data_ready, ape_ext_data_ready, ape_loo_data_ready, loo_data_ready,
            pc_res, pc_rea, pc_ape, pc_loo >>

ProcSet == {"Reservoir", "Reactor", "Aperture", "Loom"}

Init == (* Global variables *)
        /\ res_to_rea_data = 0
        /\ rea_to_ape_data = 0
        /\ ape_to_ext_data = 0
        /\ ape_to_loo_data = 0
        /\ loo_to_res_data = 0

        (* Control flags *)
        /\ res_data_ready = FALSE
        /\ rea_data_ready = FALSE
        /\ ape_ext_data_ready = FALSE
        /\ ape_loo_data_ready = FALSE
        /\ loo_data_ready = FALSE

        (* Process program counters *)
        /\ pc_res = "Init"
        /\ pc_rea = "Init"
        /\ pc_ape = "Init"
        /\ pc_loo = "Init"

ReservoirProcess ==
    /\ pc_res = "Init"
    /\ pc_res' = "Init"
    /\ IF loo_data_ready
       THEN /\ loo_data_ready' = FALSE
            /\ res_to_rea_data' = res_to_rea_data + 1
            /\ res_data_ready' = TRUE
            /\ UNCHANGED << rea_to_ape_data, ape_to_ext_data, ape_to_loo_data, loo_to_res_data, rea_data_ready, ape_ext_data_ready, ape_loo_data_ready >>
       ELSE /\ UNCHANGED vars

ReactorProcess ==
    /\ pc_rea = "Init"
    /\ pc_rea' = "Init"
    /\ IF res_data_ready
       THEN /\ res_data_ready' = FALSE
            /\ rea_to_ape_data' = rea_to_ape_data + 1
            /\ rea_data_ready' = TRUE
            /\ UNCHANGED << res_to_rea_data, ape_to_ext_data, ape_to_loo_data, loo_to_res_data, ape_ext_data_ready, ape_loo_data_ready, loo_data_ready >>
       ELSE /\ UNCHANGED vars

ApertureProcess ==
    /\ pc_ape = "Init"
    /\ pc_ape' = "Init"
    /\ IF rea_data_ready
       THEN /\ rea_data_ready' = FALSE
            /\ ape_to_ext_data' = ape_to_ext_data + 1
            /\ ape_to_loo_data' = ape_to_loo_data + 1
            /\ ape_ext_data_ready' = TRUE
            /\ ape_loo_data_ready' = TRUE
            /\ UNCHANGED << res_to_rea_data, rea_to_ape_data, loo_to_res_data, res_data_ready, rea_data_ready, loo_data_ready >>
       ELSE /\ UNCHANGED vars

LoomProcess ==
    /\ pc_loo = "Init"
    /\ pc_loo' = "Init"
    /\ IF ape_loo_data_ready
       THEN /\ ape_loo_data_ready' = FALSE
            /\ loo_to_res_data' = loo_to_res_data + 1
            /\ loo_data_ready' = TRUE
            /\ UNCHANGED << res_to_rea_data, rea_to_ape_data, ape_to_ext_data, ape_to_loo_data, res_data_ready, rea_data_ready, ape_ext_data_ready >>
       ELSE /\ UNCHANGED vars

Next == ReservoirProcess \/ ReactorProcess \/ ApertureProcess \/ LoomProcess

Spec == Init /\ [][Next]_vars

TypeOK ==
    /\ res_to_rea_data \in Int
    /\ rea_to_ape_data \in Int
    /\ ape_to_ext_data \in Int
    /\ ape_to_loo_data \in Int
    /\ loo_to_res_data \in Int
    /\ res_data_ready \in BOOLEAN
    /\ rea_data_ready \in BOOLEAN
    /\ ape_ext_data_ready \in BOOLEAN
    /\ ape_loo_data_ready \in BOOLEAN
    /\ loo_data_ready \in BOOLEAN
    /\ pc_res \in {"Init"}
    /\ pc_rea \in {"Init"}
    /\ pc_ape \in {"Init"}
    /\ pc_loo \in {"Init"}

\* Liveness property: The system should always eventually process data.
Liveness == <>(res_data_ready' = TRUE) ~> <>(rea_data_ready' = TRUE)

\* Safety property: Data should not be overwritten.
NoDataOverwrite == [](res_data_ready' => res_data_ready = FALSE)

=============================================================================
