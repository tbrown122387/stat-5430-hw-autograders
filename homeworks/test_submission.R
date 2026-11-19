library(testthat)

# Shared test inputs: non-square matrices catch row/column mix-ups
M <- matrix(1:6, nrow = 2)   # 2 x 3
B <- matrix(1:6, nrow = 3)   # 3 x 2


# Question 1a ------------------------------------------------------------------
test_that("1a: vec() stacks columns into a vector", {
  expect_true(exists("vec"))
  expect_null(dim(vec(M)))                                
  expect_equal(vec(M), c(M[, 1], M[, 2], M[, 3]))         
  expect_length(vec(M), nrow(M) * ncol(M))
})


# Question 1b ------------------------------------------------------------------
# unVec() should undo vec(), filling column by column
test_that("1b: unVec() rebuilds the matrix", {
  expect_true(exists("unVec"))
  expect_identical(unVec(vec(M), 2), M)                   # round trip
  expect_equal(dim(unVec(1:6, 2)), c(2, 3))
  expect_equal(unVec(1:6, 2)[, 1], c(1, 2))               # first column
})


# Question 1c ------------------------------------------------------------------
# stackUp(m, B) should equal 1_m %x% B (m copies of B stacked vertically)
test_that("1c: stackUp() matches 1_m %x% B", {
  expect_true(exists("stackUp"))
  for (m in c(1, 2, 4)) {
    expect_equal(stackUp(m, B), matrix(1, m, 1) %x% B,
                 ignore_attr = TRUE)
  }
  expect_equal(dim(stackUp(3, B)), c(3 * nrow(B), ncol(B)))
})


# Question 1d ------------------------------------------------------------------
test_that("1d: shoulderToShoulder() matches t(1_n) %x% B", {
  expect_true(exists("shoulderToShoulder"))
  for (n in c(1, 2, 4)) {
    expect_equal(shoulderToShoulder(n, B), matrix(1, 1, n) %x% B,
                 ignore_attr = TRUE)
  }
  expect_equal(dim(shoulderToShoulder(3, B)), c(nrow(B), 3 * ncol(B)))
})


# Question 2a ------------------------------------------------------------------
test_that("2a: data sets are read in with -9 as NA", {
  for (nm in c("mida", "midb", "midi", "midp")) {
    expect_true(exists(nm))
    expect_s3_class(get(nm), "data.frame")
    expect_equal(sum(get(nm) == -9, na.rm = TRUE), 0)     # no -9 left
  }
})


# Question 2b ------------------------------------------------------------------
test_that("2b: sameConflict is correct and midb is unchanged", {
  rows2 <- midb[midb$dispnum == 2, ]
  expect_equal(nrow(rows2), 2)
  expect_length(unique(rows2$sidea), 2)                   # opposite sides
  expect_true(sameConflict)
  expect_equal(midb, read.csv("MIDB 5.0.csv", na.strings = "-9",
                              strip.white = TRUE))        # not modified
})


# Question 2c ------------------------------------------------------------------
test_that("2c: join1 has the right rows and columns", {
  expect_true(exists("join1"))
  expect_false(any(duplicated(mida$dispnum)))             # 1 row per dispute
  expect_equal(nrow(join1), sum(midb$dispnum %in% mida$dispnum))
  expect_true(all(c("maxdur", "stabb") %in% names(join1)))  # both sides
})


# Question 2d ------------------------------------------------------------------
test_that("2d: theyAreNotTheSame matches the unmatched dispute count", {
  unmatched <- sum(!mida$dispnum %in% midb$dispnum) +
    sum(!midb$dispnum %in% mida$dispnum)
  expect_type(theyAreNotTheSame, "logical")
  expect_length(theyAreNotTheSame, 1)
  expect_equal(theyAreNotTheSame, unmatched > 0)
})


# Question 2e ------------------------------------------------------------------
test_that("2e: join2 is correct and inner vs outer differ", {
  expect_true(exists("join2"))
  expect_false(any(duplicated(midi$incidnum)))            # 1 row per incident
  expect_equal(nrow(join2), sum(midp$incidnum %in% midi$incidnum))
  unmatched <- sum(!midi$incidnum %in% midp$incidnum) +
    sum(!midp$incidnum %in% midi$incidnum)
  expect_gt(unmatched, 0)                                 # "Yes, a difference"
})


# Question 2f ------------------------------------------------------------------
test_that("2f: midData is a left join of join2 onto join1", {
  expect_true(exists("midData"))
  dispCol <- if ("dispnum" %in% names(midData)) "dispnum" else "dispnum.x"
  expect_true(all(join2$incidnum %in% midData$incidnum))       # all join2 rows kept
  expect_true(all(midData[[dispCol]] %in% join2[[join2Key]]))  # no extra join1 disputes
  expect_gte(nrow(midData), nrow(join2))   # can be larger: some states appear
})


# Question 2g ------------------------------------------------------------------
test_that("2g: scatterplot inputs exist", {
  expect_true(all(c("endyear.x.y", "maxdur", "stabb.x") %in% names(midData)))
  expect_length(countryCol, nlevels(countries))           # 1 color per country
})


# Question 2h ------------------------------------------------------------------
test_that("2h: longData and wideData have the right shape", {
  expect_named(longData, c("incidnum", "stabb", "fatalpre"))
  expect_equal(nrow(longData), nrow(midp))
  expect_equal(nrow(wideData), length(unique(midp$incidnum)))
  expect_false(any(duplicated(wideData$incidnum)))        # unique row ID
  expect_equal(sum(grepl("^fatalpre\\.", names(wideData))),
               length(unique(midp$stabb)))                # 1 col per state
  
  # Spot check: first longData value lands in the right wide cell
  r <- longData[1, ]
  expect_equal(wideData[wideData$incidnum == r$incidnum,
                        paste0("fatalpre.", r$stabb)],
               r$fatalpre)
})


# Bonus Question ---------------------------------------------------------------
test_that("Bonus: duplicate columns removed and names restored", {
  expect_false(any(duplicated(names(midData))))
  expect_true(all(c("dispnum", "version") %in% names(midData)))
  
  base <- gsub("(\\.(x|y))+$", "", names(midData))
  for (b in unique(base[duplicated(base)])) {
    cols <- names(midData)[base == b]
    for (j in seq_along(cols)[-length(cols)]) {
      for (k in (j + 1):length(cols)) {
        expect_false(isTRUE(all.equal(midData[[cols[j]]], midData[[cols[k]]],
                                      check.attributes = FALSE)),
                     label = paste(cols[j], "and", cols[k], "are identical"))
      }
    }
  }
})