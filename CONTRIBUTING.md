# Contributing

## Workflow

1. **Fork this repository** to your own GitHub account (top-right "Fork"
   button). You don't need — and won't be granted — push access to this
   repo directly; forking is the normal way to contribute to any public
   GitHub repo.
2. Clone your fork, and create a branch for the homework you're working on:
   ```bash
   git checkout -b hw6-autograder
   ```
3. Do your work under `homeworks/hw6/` (see
   [docs/writing-a-new-autograder.md](docs/writing-a-new-autograder.md)).
4. Test locally before you push:
   ```bash
   cd homeworks/hw6/R      # or Python
   ./test_locally.sh sample_submissions/passing/...
   ./test_locally.sh sample_submissions/failing/...
   ```
5. Push your branch to your fork, then open a pull request against this
   repo's `main` branch.
6. A GitHub Actions check runs automatically on your PR. Fix anything it
   flags before asking for review.
7. The instructor reviews the PR and merges (or requests changes). Merging
   is the end of this repo's involvement — the instructor separately builds
   the Gradescope zip from the merged folder and uploads it.

## Ground rules

- One homework's autograder per PR — keeps review small and focused.
- Don't touch other students' `homeworks/hwN/` folders.
- If your checks need a package beyond what's already listed
  (`testthat`/`gradeR` for R, `pytest` for Python), add it to `setup.sh` (R)
  or `requirements.txt` (Python) in your own homework folder — not the
  shared template.
