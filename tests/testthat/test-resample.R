library(actigraphcounts)
context("resample")
test_that("resample downsamples the signal to 30 Hz", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actigraphcounts")
  raw = read.csv(file, skip = 10)

  # resample data
  downsample_data = actigraphcounts::resample(raw, sf = 100, verbose = FALSE)

  expect_equal(nrow(downsample_data), 72000)
  expect_equal(ncol(downsample_data), 3)
  expect_equal(round(sum(downsample_data[,1]),2), -32593.27)

})
