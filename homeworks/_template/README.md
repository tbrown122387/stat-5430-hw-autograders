# TODO: Homework name

> Copy this whole `_template/` folder to `homeworks/hwN/` (rename `hwN` to
> the real homework number) and fill in every TODO. See
> [docs/writing-a-new-autograder.md](../../docs/writing-a-new-autograder.md)
> for the full walkthrough, and look at `homeworks/demo/` for a filled-in
> reference example.

TODO: paste or link the assignment prompt here, so it's clear what these
checks are supposed to verify.

## What's here

- `R/` — checks for the R part of the assignment, using `testthat` + `gradeR`
- `Python/` — checks for the Python part of the assignment, using `pytest`

Delete whichever language folder doesn't apply if the homework is
single-language.

## Before you open a PR

1. Rename `SUBMISSION_NAME` everywhere it appears (`run_autograder`,
   `grade_one_submission.R` / `tests/test_submission.py`, `test_locally.sh`)
   to match the exact filename students are told to submit.
2. Write real checks in `tests/test_submission.R` and/or
   `tests/test_submission.py`.
3. Add at least one submission file to `sample_submissions/passing/` that
   should get full credit, and one to `sample_submissions/failing/` that
   should not. CI will run both and fail the PR if the "failing" one
   somehow passes — that's a sign your checks aren't actually checking
   anything.
4. Run `./test_locally.sh sample_submissions/passing/...` and
   `./test_locally.sh sample_submissions/failing/...` yourself and confirm
   the output looks right.
