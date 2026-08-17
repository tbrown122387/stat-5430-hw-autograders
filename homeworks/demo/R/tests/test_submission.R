library(testthat)

test_that("a is equal to 1 (visible)", {
  expect_true(exists("a"), info = "variable `a` was never defined")
  expect_equal(a, 1)
})
