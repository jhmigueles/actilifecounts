library(actigraphcounts)
context("trim_data")
test_that("trim_data thresholds the data as expected", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actigraphcounts")
  raw = read.csv(file, skip = 10)

  # resample data
  downsample_data = actigraphcounts::resample(raw, sf = 100, verbose = FALSE)

  # bandpass filter
  bpf_data = bpf_filter(downsample_data, verbose = FALSE)

  # trim data with default filter
  trimmed_data = trim_data(bpf_data, lfe_select = FALSE, verbose = FALSE)

  expect_equal(nrow(trimmed_data), 72000)
  expect_equal(ncol(trimmed_data), 3)
  expect_equal(sum(trimmed_data[,1] == 0), 59075)

  # trim data with lfe filter
  trimmed_data = trim_data(bpf_data, lfe_select = TRUE, verbose = FALSE)

  expect_equal(nrow(trimmed_data), 72000)
  expect_equal(ncol(trimmed_data), 3)
  expect_equal(sum(trimmed_data[,1] == 0), 54139)

})
