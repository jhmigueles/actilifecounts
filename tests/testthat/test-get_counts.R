library(actilifecounts)
testthat::test_that("get_counts calculates counts as expected", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actilifecounts")
  raw = read.csv(file, skip = 10)

  # get counts with default filter
  counts = get_counts(raw, sf = 100, epoch = 60, lfe_select = FALSE, verbose = TRUE)

  expect_equal(nrow(counts), 40)
  expect_equal(ncol(counts), 4)
  expect_equal(sum(counts[,1]), 57404)

  # get counts with lfe filter
  counts = get_counts(raw, sf = 100, epoch = 60, lfe_select = TRUE, verbose = FALSE)

  expect_equal(nrow(counts), 40)
  expect_equal(ncol(counts), 4)
  expect_equal(sum(counts[,1]), 59213)

})
