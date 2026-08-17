#!/usr/bin/env bash
set -e

# This runs once, when Gradescope builds the autograder image from this
# folder. Add anything this homework's submissions need to requirements.txt
# (e.g. pandas, numpy) rather than here.

apt-get update -qq
apt-get install -y --no-install-recommends python3 python3-pip

pip3 install -r requirements.txt
