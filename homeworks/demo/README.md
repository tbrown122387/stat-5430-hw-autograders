# Demo: "Test Assignment"

This is the **worked example**. It's the autograder for the actual ungraded
"Test Assignment" every student completes at the start of the semester to
get comfortable with Gradescope. Read through everything in this folder
before you build your own homework's autograder — it's the reference
implementation that `homeworks/_template/` is copied from.

## The assignment being graded

> This assignment is easy, but it's just to get you used to using
> Gradescope.com.
>
> **R Part** — All answers to questions related to R should be written in
> a file named `test.R`.
> 1. Assign `1` to `a` by writing `a <- 1`
>
> **Python Part** — All answers to questions related to Python should be
> written in a file named `test.py`.
> 1. Assign `1` to `a` by writing `a = 1`

## What's here

```
demo/
├── R/
│   ├── setup.sh                    # installs R + testthat + gradeR (Gradescope build step)
│   ├── run_autograder              # entrypoint Gradescope runs against each submission
│   ├── grade_one_submission.R      # turns testthat results into Gradescope's results.json
│   ├── tests/test_submission.R     # the actual checks, written with testthat
│   ├── test_locally.sh             # run the same checks on your own machine, no Gradescope needed
│   └── sample_submissions/
│       ├── passing/test.R          # a <- 1   (should pass every check)
│       └── failing/test.R          # a <- 2   (should fail — proves the checks aren't fake)
└── Python/
    ├── setup.sh
    ├── run_autograder
    ├── requirements.txt
    ├── tests/test_submission.py    # the actual checks, written with pytest
    ├── gradescope_json.py          # turns pytest's JUnit report into Gradescope's results.json
    ├── test_locally.sh
    └── sample_submissions/
        ├── passing/test.py         # a = 1
        └── failing/test.py         # a = 2
```

## Try it yourself

```bash
cd R    # or Python
./test_locally.sh sample_submissions/passing/test.R   # should report all tests passing
./test_locally.sh sample_submissions/failing/test.R   # should report a failing test
```

No Docker, no Gradescope account needed for this step — see
[docs/writing-a-new-autograder.md](../../docs/writing-a-new-autograder.md)
for what happens after that (PR review, then the instructor building the
real Gradescope zip from this same folder).
