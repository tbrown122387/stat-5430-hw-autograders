# STAT 5430 Autograder Template

This repo is where **students write the Gradescope autograder checks for
their own homeworks**, instead of only ever seeing checks the instructor
already wrote. It's public: anyone can read it, and any student can open a
pull request, but nobody besides the instructor can push directly to `main`.

## How this works

1. Each homework's assignment prompt tells you what your submission file
   needs to contain.
2. You copy [`homeworks/_template/`](homeworks/_template/) to
   `homeworks/hwN/` and write the checks yourself — see
   [`homeworks/demo/`](homeworks/demo/) for a complete, working example
   first.
3. You test your checks **on your own machine**, with no Docker and no
   Gradescope account needed (`./test_locally.sh ...`).
4. You open a pull request. A GitHub Actions check automatically runs your
   checks against a submission that should pass and one that shouldn't —
   so you get instant feedback on whether your checks actually check
   anything.
5. The instructor reviews and merges the PR. Merging does **not**
   automatically publish anything to Gradescope — once satisfied, the
   instructor builds the zip from your homework's folder and uploads it to
   Gradescope as the real autograder.

See [`docs/writing-a-new-autograder.md`](docs/writing-a-new-autograder.md)
for the full step-by-step, and [`CONTRIBUTING.md`](CONTRIBUTING.md) for the
PR workflow itself.

## Layout

```
homeworks/
├── demo/          # worked example, based on the semester's ungraded practice assignment
├── _template/      # copy this to start a new homework's autograder
└── hwN/            # what you'll add, one per homework
```

Each homework folder has an `R/` subfolder, a `Python/` subfolder, or both
— whichever the assignment requires.

## Why "no push access" doesn't need any special setup

This is a public repo. External contributors on GitHub always contribute
through a fork + pull request, whether or not they're a "collaborator" —
there's nothing to configure to prevent students from pushing directly,
because they never have that ability in the first place. `main` is also
protected so that even the instructor pushes through reviewed PRs in
practice.
