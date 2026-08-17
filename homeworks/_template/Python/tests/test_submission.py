import os
import runpy

import pytest

SUBMISSION_NAME = "TODO_SUBMISSION_NAME.py"  # must match run_autograder below


@pytest.fixture(scope="module")
def submission():
    """Executes the student's submission and returns its top-level variables."""
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "..", SUBMISSION_NAME)
    return runpy.run_path(path)


def test_TODO_describe_this_check(submission):
    # TODO: replace with a real check against the assignment's requirements
    assert "TODO_variable_name" in submission
    assert submission["TODO_variable_name"] == "TODO expected value"
