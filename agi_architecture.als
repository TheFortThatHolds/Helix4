/**
 * Alloy model for the Helix-4 AGI Quad Cluster Architecture
 */

/**
 * The four phases of the Cycle of Expression.
 */
enum Phase { LookIn, SpiralUp, FlowOut, Return }

/**
 * A single Helix-4 chip, which has a primary function.
 */
abstract sig Chip {
  primary_function: one Phase
}

/**
 * A Quad Cluster is a set of four chips, one for each phase.
 */
abstract sig Cluster {
  chips: set Chip
}

/**
 * The AGI is composed of a set of clusters.
 */
sig AGI {
  clusters: set Cluster
}

/**
 * There are four types of clusters in the baseline AGI.
 */
one sig MemoryIdentityCluster, WorldModelingCluster, PlanningAgencyCluster, SocialLanguageCluster extends Cluster {}

/**
 * There are four types of chips, one for each phase-specialization.
 */
one sig ReservoirChip, ReactorChip, ApertureChip, LoomChip extends Chip {}

/**
 * Define the primary function of each chip type.
 */
fact ChipFunctions {
  ReservoirChip.primary_function = LookIn
  ReactorChip.primary_function = SpiralUp
  ApertureChip.primary_function = FlowOut
  LoomChip.primary_function = Return
}

/**
 * A fact stating that every cluster must have exactly one of each type of chip.
 */
fact ClusterComposition {
  all c: Cluster | {
    one ReservoirChip in c.chips
    one ReactorChip in c.chips
    one ApertureChip in c.chips
    one LoomChip in c.chips
    #c.chips = 4
  }
}

/**
 * A predicate to define the baseline AGI topology.
 */
pred BaselineAGI(agi: AGI) {
  agi.clusters = MemoryIdentityCluster + WorldModelingCluster + PlanningAgencyCluster + SocialLanguageCluster
}

/**
 * An assertion to check that no chip can have more than one primary function.
 * This is guaranteed by the 'one' keyword in the primary_function relation,
 * but we can assert it to be explicit.
 */
assert NoChipHasMultipleFunctions {
  all c: Chip | one c.primary_function
}
check NoChipHasMultipleFunctions for 5

/**
 * An assertion to check that each cluster is correctly composed.
 */
assert CorrectClusterComposition {
  all c: Cluster | {
    LookIn in c.chips.primary_function
    SpiralUp in c.chips.primary_function
    FlowOut in c.chips.primary_function
    Return in c.chips.primary_function
  }
}
check CorrectClusterComposition for 5

/**
 * A command to find an instance of the baseline AGI.
 */
run BaselineAGI for 5
