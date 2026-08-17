import os
import runpy

import pytest

SUBMISSION_NAME = "test.py"  # must match run_autograder below


@pytest.fixture(scope="module")
def submission():
    """Executes the student's submission and returns its top-level variables."""
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "..", SUBMISSION_NAME)
    return runpy.run_path(path)


def test_a_equals_1(submission):
    assert "a" in submission, "variable `a` was never defined"
    assert submission["a"] == 1
