library(actigraphcounts)
context("sum_counts")
test_that("sum_counts gets the counts per epoch as expected", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actigraphcounts")
  raw = read.csv(file, skip = 10)

  # resample data
  downsample_data = actigraphcounts::resample(raw, sf = 100, verbose = FALSE)

  # bandpass filter
  bpf_data = bpf_filter(downsample_data, verbose = FALSE)

  # trim data with default filter
  trimmed_data = trim_data(bpf_data, lfe_select = FALSE, verbose = FALSE)

  # downsample the signal to 10 hz
  resample_10hz = resample_10hz(trimmed_data, verbose = FALSE)

  # counts per epoch
  counts_epoch = sum_counts(resample_10hz, epoch = 60, verbose = FALSE)

  expect_equal(nrow(counts_epoch), 40)
  expect_equal(ncol(counts_epoch), 3)
  expect_equal(sum(counts_epoch[,1]), 57404)

})
