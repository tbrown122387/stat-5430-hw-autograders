# Writing a new homework's autograder

This walks through building an autograder for a new homework, start to
finish. Read [`homeworks/demo/`](../homeworks/demo/) alongside this — it's
the same steps, already done, for the semester's ungraded practice
assignment.

## 1. Copy the template

```bash
cp -r homeworks/_template homeworks/hw3   # use the real homework number
```

Delete whichever of `R/` or `Python/` doesn't apply if the homework is
single-language.

## 2. Fill in the assignment context

Edit `homeworks/hw3/README.md`: paste or link the actual assignment prompt,
so a reviewer (or you, in three weeks) can tell what the checks are
supposed to verify without guessing.

## 3. Pick the submission filename

Every `TODO_SUBMISSION_NAME` in the template needs to become the exact
filename students are told to submit for this assignment (e.g. `hw3.R`,
`hw3.py`). It has to match in **three** places per language:

- `run_autograder`
- `grade_one_submission.R` (R) or `tests/test_submission.py` (Python)
- `test_locally.sh`

## 4. Write the checks

- **R**: edit `tests/test_submission.R`. These are ordinary `testthat`
  checks — the same tool from Toolkit Module 8. They run *after* your
  submission file has been `source()`-d, so you're asserting against
  whatever variables/functions/side effects it left behind, not calling
  functions directly on it.
- **Python**: edit `tests/test_submission.py`. These are ordinary `pytest`
  tests. The `submission` fixture runs the student's file with
  `runpy.run_path()` and hands you back its top-level namespace as a dict
  — check keys in that dict the same way you'd check variables in R.

Refer to the "Autograding Information" document from the main course
repository for the kinds of mistakes (file paths, overwritten variables,
silently-skipped code after an error) your checks should be robust to —
students will absolutely trip on all of them.

## 5. Add sample submissions

- `sample_submissions/passing/<name>` — something that should earn full
  credit.
- `sample_submissions/failing/<name>` — something that shouldn't.

These aren't optional. CI runs both through your checks and fails the PR if
the "failing" one somehow passes anyway — a cheap sanity check that your
tests aren't accidentally checking nothing (e.g. a typo'd variable name
that just never gets asserted on).

## 6. Test locally

```bash
cd homeworks/hw3/R          # or Python
./test_locally.sh sample_submissions/passing/hw3.R
./test_locally.sh sample_submissions/failing/hw3.R
```

No Docker, no Gradescope account. This runs the exact same test files
Gradescope will eventually run — just without Gradescope's specific
container environment (that's what CI checks next, and what the instructor
double-checks before uploading).

## 7. Open the PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the mechanics. Once it's
merged, your job is done — building the Gradescope zip and uploading it is
the instructor's step, not part of this repo.
