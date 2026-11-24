#!/usr/bin/env bash
# Run this homework's checks against a submission file, on your own machine.
# No Docker, no Gradescope account needed — just Python with Otter-Grader
# installed:
#   pip install otter-grader ipykernel
#   python -m ipykernel install --user --name python3   # one-time
#
# This runs the exact same grading engine Gradescope uses — `otter generate`
# to build the autograder, then `otter run` to grade a submission with it —
# just without the Docker container, so the results.json this prints is the
# real thing, not an approximation.
#
# Usage:
#   ./test_locally.sh sample_submissions/passing/test.py
#   ./test_locally.sh sample_submissions/failing/test.py
#   ./test_locally.sh path/to/your/own/submission.py
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: ./test_locally.sh path/to/a/submission.py"
  exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# Otter finds the submission itself by extension (*.ipynb, else *.py) — it
# doesn't need a fixed filename the way the R/gradeR side does.
cp "$1" "$WORKDIR/$(basename "$1")"
cp -r "$HERE/tests" "$WORKDIR/tests"
cp "$HERE/otter_config.json" "$WORKDIR/otter_config.json"
cp "$HERE/requirements.txt" "$WORKDIR/requirements.txt"

# Idempotent, offline, and fast — safe to run every time rather than making
# it a separate manual setup step.
python3 -m ipykernel install --user --name python3 >/dev/null 2>&1 || true

cd "$WORKDIR"
otter generate -t tests -r requirements.txt -o autograder.zip
mkdir results
otter run --no-logo -a autograder.zip -o results "$(basename "$1")"

python3 - "$WORKDIR/results/results.json" <<'PYEOF'
import json
import sys

with open(sys.argv[1]) as f:
    data = json.load(f)

scored = [t for t in data["tests"] if "score" in t]
score = sum(t["score"] for t in scored)
possible = sum(t["max_score"] for t in scored)
print(f"\nScore: {score:g}/{possible:g}")
sys.exit(0 if score >= possible else 1)
PYEOF
