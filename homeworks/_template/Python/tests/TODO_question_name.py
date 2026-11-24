# Otter-Grader "OK format" test file — the same format used for every
# Python homework in the main course repo. One file per question. Each
# file defines a dict named `test` with a doctest-style check per case.
# Otter runs the submission first, then evaluates `code` against the
# resulting namespace — so a bare name like `TODO_variable_name` below
# refers to whatever top-level variable/function the submission defined.
#
# TODO: rename this file to describe the question (e.g. q1.py), and fill
# in a real check. Add one file per question/variable you're grading.
OK_FORMAT = True

test = {
    "name": "TODO_question_name",
    "points": 1,
    "suites": [
        {
            "cases": [
                {
                    "code": r"""
                    >>> TODO_variable_name == TODO_expected_value
                    True
                    """,
                    "hidden": False,
                },
            ],
            "scored": True,
            "type": "doctest",
        },
    ],
}
