#' trim_data
#'
#' @param bpf_data Matrix containing filtered data
#' @param lfe_select False for regular trimming, True for allow more noise
#' @param verbose Print diagnostic messages
#'
#' @return The trimmed/thresholded data
#' @author Jairo Hidalgo Migueles
#' @references Ali Neishabouri et al. DOI: https://doi.org/10.21203/rs.3.rs-1370418/v1
#' @export
trim_data = function(bpf_data = c(), lfe_select = FALSE, verbose = FALSE) {
  if (verbose) cat(paste0(rep('_', options()$width), collapse = ''))
  if (verbose) cat("\nTrimming data...")

  # thresholds
  if (lfe_select) {
    min_count = 1
    max_count = 128
    trim_data = abs(bpf_data)
    trim_data[(trim_data < min_count) & (trim_data >= 4)] = 0
    trim_data[trim_data > max_count] = max_count
    mask = (trim_data < 4) & (trim_data >= min_count)
    trim_data[mask] = abs(trim_data[mask]) - 1
    trim_data = floor(trim_data)
    rm(mask)
  } else if (!lfe_select) {
    min_count = 4
    max_count = 128
    trim_data = abs(bpf_data)
    trim_data[trim_data < min_count] = 0
    trim_data[trim_data > max_count] = max_count
    trim_data = floor(trim_data)
  }
  if (verbose) cat(" Done!\n")

  return(trim_data)
}
