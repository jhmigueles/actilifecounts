library(actigraphcounts)
context("resample_10hz")
test_that("resample_10hz downsamples the signal to 10 Hz", {
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

  expect_equal(nrow(resample_10hz), 40*60*10)
  expect_equal(ncol(resample_10hz), 3)
  expect_equal(sum(resample_10hz[,1]), 57404)

})
