#!/usr/bin/env bash
set -e

# This runs once, when Gradescope builds the autograder image from this
# folder. It needs to install everything both the student's code and the
# grading code depend on.

apt-get update -qq
apt-get install -y --no-install-recommends python3 python3-pip

pip3 install -r requirements.txt
