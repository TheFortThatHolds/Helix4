import pytest

from helix_intelligence import HelixIntelligence


class InstrumentedHelix(HelixIntelligence):
    """Deterministic subclass for exercising the ARP skeleton."""

    def __init__(self, feedback_sequence):
        super().__init__()
        self.feedback_sequence = list(feedback_sequence)
        self.hebbian_log = []

    def sparse_search(self, user_input):
        return sum(ord(ch) for ch in str(user_input))

    def transformer_expand(self, thought):
        return thought * 2

    def emit(self, prediction):
        return prediction % 256

    def listen_to_user(self):
        if not self.feedback_sequence:
            raise RuntimeError("No feedback left for test harness")
        return self.feedback_sequence.pop(0)

    def hebbian_update(self, error):
        self.hebbian_log.append(error)

    def integrate_experience(self, thought, error):
        return thought + error


def test_live_cycle_updates_state_and_action():
    agent = InstrumentedHelix([10, 20])

    action1 = agent.live_cycle("hi")
    assert action1 == 162
    assert agent.hebbian_log[-1] == -408
    assert agent.state == -199

    action2 = agent.live_cycle("bye")
    assert action2 == 242
    assert agent.hebbian_log[-1] == -222
    assert agent.state == -101
    assert agent.hebbian_log == [-408, -222]

