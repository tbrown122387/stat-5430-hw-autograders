#!/usr/bin/env bash
set -e

# This runs once, when Gradescope builds the autograder image from this
# folder. Install everything both the student's code and the grading code
# depend on (e.g. add more R packages to the install.packages() call below
# if this homework needs them, like dplyr or ggplot2).

apt-get update -qq
apt-get install -y --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev libuv1-dev
apt-get install -y r-base

# TODO: add any extra packages this homework's submissions need
Rscript -e "install.packages(c('testthat', 'gradeR'), repos='https://cloud.r-project.org')"

# install.packages() doesn't make Rscript exit non-zero on failure, so
# without this check a broken/missing package build here would silently
# "succeed" and only show up later as a runtime error grading a real
# submission. Fail loudly now instead.
Rscript -e "library(testthat); library(gradeR)"
