#!/usr/bin/env bash
# Run this homework's checks against a submission file, on your own machine.
# No Docker, no Gradescope account needed — just Python with pytest installed
# (pip install -r requirements.txt).
#
# Usage:
#   ./test_locally.sh sample_submissions/passing/test.py
#   ./test_locally.sh sample_submissions/failing/test.py
#   ./test_locally.sh path/to/your/own/test.py
set -euo pipefail

# --- must match the filename in run_autograder / tests/test_submission.py ---
SUBMISSION_NAME="test.py"
# ----------------------------------------------------------------------------

if [ -z "${1:-}" ]; then
  echo "Usage: ./test_locally.sh path/to/a/submission.py"
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(mktemp -d)"
cp "$1" "$WORKDIR/$SUBMISSION_NAME"
cp -r "$HERE/tests" "$WORKDIR/tests"

cd "$WORKDIR"
python3 -m pytest tests/ -v
