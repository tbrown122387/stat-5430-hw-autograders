#!/usr/bin/env python3
"""Convert a pytest JUnit-XML report into Gradescope's results.json format.

Usage: gradescope_json.py <junit-report.xml> <results.json>

Deliberately uses only the standard library (xml.etree, json) — pytest's
JUnit-XML output is a stable, built-in feature (`pytest --junitxml=...`),
so this has no extra pip dependencies beyond pytest itself.
"""
import json
import sys
import xml.etree.ElementTree as ET


def convert(junit_path: str, results_path: str) -> None:
    tree = ET.parse(junit_path)
    root = tree.getroot()

    tests = []
    for case in root.iter("testcase"):
        name = case.get("name")
        failure = case.find("failure")
        error = case.find("error")
        skipped = case.find("skipped")

        if skipped is not None:
            score = 0.0
            output = "SKIPPED: " + (skipped.get("message") or "")
        elif failure is not None:
            score = 0.0
            output = (failure.get("message") or "") + "\n" + (failure.text or "")
        elif error is not None:
            score = 0.0
            output = "ERROR: " + (error.get("message") or "") + "\n" + (error.text or "")
        else:
            score = 1.0
            output = "PASSED"

        tests.append(
            {
                "name": name,
                "score": score,
                "max_score": 1.0,
                "output": output.strip(),
            }
        )

    with open(results_path, "w") as f:
        json.dump({"tests": tests}, f, indent=2)


if __name__ == "__main__":
    convert(sys.argv[1], sys.argv[2])
