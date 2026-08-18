#!/usr/bin/env bash
set -e

# This runs once, when Gradescope builds the autograder image from this
# folder. It needs to install everything both the student's code and the
# grading code depend on.

apt-get update -qq
apt-get install -y --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
apt-get install -y r-base

Rscript -e "install.packages(c('testthat', 'gradeR'), repos='https://cloud.r-project.org')"
