#!/usr/bin/env bash
# Run this homework's checks against a submission file, on your own machine.
# No Docker, no Gradescope account needed — just R with testthat installed.
#
# Usage:
#   ./test_locally.sh sample_submissions/passing/TODO_SUBMISSION_NAME.R
#   ./test_locally.sh sample_submissions/failing/TODO_SUBMISSION_NAME.R
#   ./test_locally.sh path/to/your/own/submission.R
set -euo pipefail

# TODO: must match the filename in run_autograder / grade_one_submission.R
SUBMISSION_NAME="TODO_SUBMISSION_NAME.R"

if [ -z "${1:-}" ]; then
  echo "Usage: ./test_locally.sh path/to/a/submission.R"
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(mktemp -d)"
cp "$1" "$WORKDIR/$SUBMISSION_NAME"
cp -r "$HERE/tests" "$WORKDIR/tests"

cd "$WORKDIR"
Rscript -e "
  source('$SUBMISSION_NAME')
  testthat::test_file('tests/test_submission.R', reporter = 'summary')
"
