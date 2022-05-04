library(actigraphcounts)
test_that("pipeline works", {
  # read dummy data (test file with 40 minutes of data sampled at 100 Hz)
  file = system.file("testfiles/testfile.csv", package = "actigraphcounts")
  raw = read.csv(file, skip = 10)

  # resample data to 30 hz
  downsample_data = resample_30hz(raw, sf = 100, verbose = FALSE)
  expect_equal(nrow(downsample_data), 72000)
  expect_equal(ncol(downsample_data), 3)
  expect_equal(round(sum(downsample_data[,1]),2), -32593.27)

  # bandpass filter
  bpf_data = bpf_filter(downsample_data, verbose = FALSE)
  expect_equal(nrow(bpf_data), 72000)
  expect_equal(ncol(bpf_data), 3)
  expect_equal(round(sum(bpf_data[,1]),3), 8.564)

  # trim data with default filter
  trimmed_data = trim_data(bpf_data, lfe_select = FALSE, verbose = FALSE)
  expect_equal(nrow(trimmed_data), 72000)
  expect_equal(ncol(trimmed_data), 3)
  expect_equal(sum(trimmed_data[,1] == 0), 59075)

  # downsample the signal to 10 hz
  resample_10hz = resample_10hz(trimmed_data, verbose = FALSE)
  expect_equal(nrow(resample_10hz), 40*60*10)
  expect_equal(ncol(resample_10hz), 3)
  expect_equal(sum(resample_10hz[,1]), 57404)

  # counts per epoch
  counts_epoch = sum_counts(resample_10hz, epoch = 60, verbose = FALSE)
  expect_equal(nrow(counts_epoch), 40)
  expect_equal(ncol(counts_epoch), 3)
  expect_equal(sum(counts_epoch[,1]), 57404)

})
