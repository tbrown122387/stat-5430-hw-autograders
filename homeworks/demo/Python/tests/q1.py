# Otter-Grader "OK format" test file — the same format used for every
# Python homework in the main course repo. Each file in tests/ is one
# question: a dict named `test` with a doctest-style check per case. Otter
# runs the submission, then evaluates `code` against the resulting
# namespace (so `a` below refers to whatever the submission assigned to
# the top-level variable `a`).
OK_FORMAT = True

test = {
    "name": "q1",
    "points": 1,
    "suites": [
        {
            "cases": [
                {
                    "code": r"""
                    >>> a == 1
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
