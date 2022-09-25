#' bpf_filter
#' @description Bandpass filter for actigraph downsampled data
#' @param downsample_data Matrix containing downsampled data
#' @param verbose Print diagnostic messages
#'
#' @return The filtered data
#' @author Jairo Hidalgo Migueles
#' @references Ali Neishabouri et al. DOI: https://doi.org/10.21203/rs.3.rs-1370418/v1
#' @export
#'
bpf_filter = function(downsample_data = c(), verbose = FALSE) {
  
  suppressMessages(requireNamespace("gsignal"))

  if (verbose) cat(paste0(rep('_', options()$width), collapse = ''))
  if (verbose) cat("\nFiltering data...")

  # input_coeffs and output_coeffs are stored as internal data in the package
  # see data-raw/DATASET for more information on these values
  input_coeffs = as.numeric(input_coeffs)
  output_coeffs = as.numeric(output_coeffs)

  # dimensions
  n = nrow(downsample_data); m = ncol(downsample_data)

  # zi filter
  zi = gsignal::filter_zi(filt = input_coeffs, a = output_coeffs)
  zi = t(matrix(rep(zi, m), ncol = m, byrow = F)) * downsample_data[1, ]
  zi = t(zi)

  # loop to bpf-filter the axes
  filtered = list()
  for (axis in 1:m) filtered[[axis]] = gsignal::filter(filt = input_coeffs, a = output_coeffs,
                                                       x = downsample_data[, axis], zi = zi[, axis])$y
  # names
  names(filtered) = colnames(downsample_data)

  # to matrix
  bpf_data = as.matrix(do.call(cbind.data.frame, filtered))
  # bpf_data = as.matrix(cbind(x[[1]], y[[1]], z[[1]]))
  bpf_data = ((3.0 / 4096.0) / (2.6 / 256.0) * 237.5) * bpf_data
  if (verbose) cat(" Done!\n")
  return(bpf_data)
}
