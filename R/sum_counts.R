#' sum_counts
#' @description Generate counts per epoch.
#' @param downsample_10hz Matrix containing downsampled to 10hz data
#' @param epoch Used to compute how many raw samples are used for computing an epoch
#' @param verbose Used to compute how many raw samples are used for computing an epoch
#'
#' @return Matrix with counts per epoch in the 3 axes
#' @author Jairo Hidalgo Migueles
#' @references Ali Neishabouri et al. DOI: https://doi.org/10.21203/rs.3.rs-1370418/v1
#' @export
sum_counts = function(downsample_10hz, epoch = 60, verbose = FALSE) {
  if (verbose) cat(paste0(rep('_', options()$width), collapse = ''))
  if (verbose) cat("\nAggregating counts per epoch...")
  # dimensions
  n = nrow(downsample_10hz); m = ncol(downsample_10hz)

  # accumulator for epoch
  block_size = epoch * 10
  epoch_counts = apply(downsample_10hz, MARGIN = 2, FUN = cumsum)

  epoch_counts[(block_size + 1):nrow(epoch_counts), ] = (epoch_counts[(block_size + 1):nrow(epoch_counts), ] -
                                                         epoch_counts[1:(nrow(epoch_counts) - block_size), ])
  epoch_counts = floor(epoch_counts[seq(block_size, nrow(epoch_counts), block_size),])
  epoch_counts = as.matrix(epoch_counts, ncol = m)
  if (verbose) cat(" Done!\n")
  return(epoch_counts)
}
