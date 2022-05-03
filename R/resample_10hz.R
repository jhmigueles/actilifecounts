#' resample_10hz
#' @description Get data back to 10 Hz for accumulation
#' @param trim_data Matrix containing the trimmed/thresholded data
#' @param verbose Print diagnostic messages
#'
#' @return Resampled data
#' @export
resample_10hz = function(trim_data = c(), verbose = FALSE) {
  if (verbose) cat(paste0(rep('_', options()$width), collapse = ''))
  if (verbose) cat("\nGetting data back to 10 Hz for accumulation...")

  # hackish downsample to 10 Hz
  downsample_10hz = apply(trim_data, MARGIN = 2, FUN = cumsum)
  downsample_10hz[4:nrow(downsample_10hz),] = downsample_10hz[4:nrow(downsample_10hz),]  - downsample_10hz[1:(nrow(downsample_10hz) - 3),]
  downsample_10hz = floor((downsample_10hz[seq(3, nrow(downsample_10hz), 3), ] / 3))
  if (verbose) cat(" Done!\n")

  return(downsample_10hz)
}
