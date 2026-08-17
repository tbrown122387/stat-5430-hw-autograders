library(gradeR)

calcGradesForGradescope(
  "test.R",                  # must match the filename in run_autograder below
  "tests/test_submission.R"  # the testthat file with all the checks
)
