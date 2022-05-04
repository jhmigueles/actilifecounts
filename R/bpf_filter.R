#' bpf_filter
#' @description Bandpass filter for actigraph downsampled data
#' @param downsample_data Matrix containing downsampled data
#' @param verbose Print diagnostic messages
#'
#' @return The filtered data
#' @importFrom gsignal filter_zi filter
#' @author Jairo Hidalgo Migueles
#' @references Ali Neishabouri et al. DOI: https://doi.org/10.21203/rs.3.rs-1370418/v1
#' @export
#'
bpf_filter = function(downsample_data = c(), verbose = FALSE) {

  if (verbose) cat(paste0(rep('_', options()$width), collapse = ''))
  if (verbose) cat("\nFiltering data...")

  # input_coeffs and output_coeffs are stored as internal data in the package
  # see data-raw/DATASET for more information on these values
  input_coeffs = as.numeric(input_coeffs)
  output_coeffs = as.numeric(output_coeffs)

  # zi filter
  zi = gsignal::filter_zi(filt = input_coeffs, a = output_coeffs)
  zi = t(matrix(rep(zi, 3), ncol = 3, byrow = F)) * downsample_data[1, ]
  zi = t(zi)
  # colnames(zi) = c("accX", "accY", "accZ")
  x = gsignal::filter(filt = input_coeffs, a = output_coeffs, x = downsample_data[, 1], zi = zi[, 1])
  y = gsignal::filter(filt = input_coeffs, a = output_coeffs, x = downsample_data[, 2], zi = zi[, 2])
  z = gsignal::filter(filt = input_coeffs, a = output_coeffs, x = downsample_data[, 3], zi = zi[, 3])
  bpf_data = as.matrix(cbind(x[[1]], y[[1]], z[[1]]))
  bpf_data = ((3.0 / 4096.0) / (2.6 / 256.0) * 237.5) * bpf_data
  if (verbose) cat(" Done!\n")
  return(bpf_data)
}
