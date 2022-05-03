#' get_counts
#'
#' @param raw Matrix containing raw data
#' @param sf Sample frequency of raw data (Hz)
#' @param epoch Epoch length to aggregate activity counts
#' @param lfe_select False for regular trimming, True for allow more noise
#' @param verbose Print diagnostic messages
#'
#' @return
#' @export
#'
#' @examples
get_counts <- function(raw, sf, epoch, lfe_select = FALSE, verbose = FALSE) {

  # Pipeline as in https://www.researchsquare.com/article/rs-1370418/v1

  # 1 - resample data to 30 Hz (steps 1 to 3 in results)
  downsample_data = resample(raw = raw, sf = sf, verbose = verbose)
  # 2 - bandpass filter (step 4)
  bpf_data = bpf_filter(downsample_data, verbose = verbose)
  # 3 - rescale, rectify and threshold the signal (steps 5 to 7)
  trim_data = trim_data(bpf_data, lfe_select = lfe_select, verbose = verbose)
  # 4 - downsample the signal to 10 hz (step 8)
  resample_10hz = resample_10hz(trim_data, verbose = verbose)
  # 5 - sum counts per epoch (step 9)
  epoch_counts = sum_counts(resample_10hz, epoch = epoch, verbose = verbose)

  return(epoch_counts)
}
