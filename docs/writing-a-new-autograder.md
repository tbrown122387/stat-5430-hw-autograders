# Writing a new homework's autograder

This walks through building an autograder for a new homework, start to
finish. Read [`homeworks/demo/`](../homeworks/demo/) alongside this — it's
the same steps, already done, for the semester's ungraded practice
assignment.

## 1. Copy the template

```bash
cp -r homeworks/_template homeworks/hw6   # use the real homework number
```

Delete whichever of `R/` or `Python/` doesn't apply if the homework is
single-language.

## 2. Fill in the assignment context

Edit `homeworks/hw6/README.md`: paste or link the actual assignment prompt,
so a reviewer (or you, in three weeks) can tell what the checks are
supposed to verify without guessing.

## 3. Pick the submission filename (R only)

Every `TODO_SUBMISSION_NAME` in the R template needs to become the exact
filename students are told to submit for this assignment (e.g. `hw6.R`).
It has to match in **three** places:

- `run_autograder`
- `grade_one_submission.R`
- `test_locally.sh`

Python doesn't have this step — Otter-Grader finds the submission itself
by file extension (`*.ipynb`, else `*.py`), whatever it's named.

## 4. Write the checks

- **R**: edit `tests/test_submission.R`. These are ordinary `testthat`
  checks — the same tool from Toolkit Module 8. They run *after* your
  submission file has been `source()`-d, so you're asserting against
  whatever variables/functions/side effects it left behind, not calling
  functions directly on it.
- **Python**: add one file per question under `tests/`, in Otter-Grader's
  "OK format" — the same format the main course repo's Python homeworks
  use. Start from `tests/TODO_question_name.py`. Each file is a dict named
  `test` with a doctest-style `code` string per case:

  ```python
  OK_FORMAT = True

  test = {
      "name": "q1",
      "points": 1,
      "suites": [
          {
              "cases": [
                  {
                      "code": r"""
                      >>> my_answer == 42
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
  ```

  Otter runs the submission (notebook or script) first, then evaluates
  `code` against whatever's left in its namespace — so `my_answer` above
  refers to a top-level variable the submission defined, the same way R's
  `testthat` checks assert against `source()`-d variables. Set `"hidden":
  true` for a case you don't want the student to see the result of before
  grades are released.

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
cd homeworks/hw6/R          # or Python
./test_locally.sh sample_submissions/passing/hw6.R
./test_locally.sh sample_submissions/failing/hw6.R
```

No Docker, no Gradescope account — just the grading tool itself installed
(R: `testthat` + `gradeR`; Python: `pip install otter-grader ipykernel` and
a one-time `python -m ipykernel install --user --name python3`). This runs
the exact same grading engine Gradescope will eventually run — just without
Gradescope's specific container environment (that's what CI checks next,
and what the instructor double-checks before uploading).

## 7. Open the PR

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the mechanics. Once it's
merged, your job is done — building the Gradescope zip and uploading it is
the instructor's step, not part of this repo. (For Python, that step is
literally `otter generate -t tests/ -r requirements.txt` run inside your
homework's `Python/` folder — `otter generate` is what produces the
`run_autograder`/`setup.sh`/`environment.yml` Gradescope actually runs, so
you won't find hand-written versions of those in this repo's `Python/`
folders the way you will under `R/`.)
