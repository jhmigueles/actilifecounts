#' factors
#' @description Given a sampling frequency, returns the upsample and downsample factors to
#' set the signal to 30 Hz
#' @param sf Integer within seq(30, 100, by = 10)
#'
#' @return upsample and downsample factors
#' @export
#'
#' @examples
#' # not run
#' factors(60)
#' # upsample downsample
#' # 1          2
factors = function(sf) {
  if (!(sf %in% seq(30, 100, by = 10))) stop("agcounts cannot handle the sampling frequency provided at the moment")
  factors = actigraphcounts:::resample_factors
  upsample = factors[which(factors[,1] == sf), "upsample_factor"]
  downsample = factors[which(factors[,1] == sf), "downsample_factor"]
  out = c(upsample, downsample)
  names(out) = c("upsample", "downsample")
  return(out)
}
