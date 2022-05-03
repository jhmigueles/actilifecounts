library(actigraphcounts)
context("bpf_filter")
test_that("bpf_filter bandpass filters the data as expected", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actigraphcounts")
  raw = read.csv(file, skip = 10)

  # resample data
  downsample_data = actigraphcounts::resample(raw, sf = 100, verbose = FALSE)

  # bandpass filter
  bpf_data = bpf_filter(downsample_data, verbose = FALSE)

  expect_equal(nrow(bpf_data), 72000)
  expect_equal(ncol(bpf_data), 3)
  expect_equal(round(sum(bpf_data[,1]),3), 8.564)

})
