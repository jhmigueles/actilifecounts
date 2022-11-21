#' resample_30hz
#' @description Resample the raw data.
#'
#' @param raw Matrix containing raw data
#' @param sf Sample frequency of raw data (Hz)
#' @param verbose Print diagnostic messages
#'
#' @return resampled_data
#' @importFrom pracma Lcm
#' @importFrom GGIRread resample
#' @author Jairo Hidalgo Migueles
#' @references Ali Neishabouri et al. DOI: https://doi.org/10.21203/rs.3.rs-1370418/v1
#' @export
resample_30hz = function(raw = c(), sf = 30, verbose = FALSE) {
  # suppressMessages(require(pracma))

  if (verbose) cat("\nResampling data...")

  # make sure it is a matrix
  raw = as.matrix(raw)
  
  if (sf %% 1 == 0) { # sf is integer
    # define factors using the least common multiple so that any sf can be converted.
    upsample_factor = pracma::Lcm(sf, 30) / sf
    downsample_factor = pracma::Lcm(sf, 30) / 30
    
    # upsample by factor
    n = nrow(raw); m = ncol(raw)
    upsample_data = matrix(rep(0, upsample_factor*n*m), ncol = m)
    fill_i = seq(1, nrow(upsample_data), by = upsample_factor)
    upsample_data[fill_i, ] = raw
    
    # other variables
    a_fp = pi / (pi + 2 * upsample_factor)
    b_fp = (pi - 2 * upsample_factor) / (pi + 2 * upsample_factor)
    up_factor_fp = upsample_factor
    
    # Allocate memory and then LPF.  LPF is only done at non
    # integer multiples of 30 Hz. This LPF is garbage and does a
    # poor job of attenuating higher frequencies that need to be
    # rejected. This is the reason why there is aliasing which
    # causes the "tail" on the epochs.
    if (sf %% 30 != 0) {
      upsample_data_roll = upsample_data[c(nrow(upsample_data), 1:(nrow(upsample_data) - 1)),]
      upsample_data = (a_fp * up_factor_fp) * (upsample_data + upsample_data_roll)
      for (i in 2:nrow(upsample_data)) upsample_data[i,] = upsample_data[i,] - b_fp * upsample_data[i - 1,]
    }
    if (sf == 30) downsample_data = raw
    if (sf != 30) downsample_data = upsample_data[seq(1, nrow(upsample_data), by = downsample_factor),]
    
    if (verbose) cat(" Done!\n")
    downsample_data = matrix(round(downsample_data, 3), ncol = m)
    colnames(downsample_data) = colnames(raw)
  } else { # sf is not integer
    downsample_data = GGIRread::resample(raw = raw, 
                                         rawTime = 1:nrow(raw), 
                                         time = 1:(nrow(raw)/sf*30), 
                                         stop = nrow(raw), 
                                         type = 1)
    colnames(downsample_data) = colnames(raw)
  }
  
  # free memory
  rm(list = setdiff(ls(), c("downsample_data")))
  gc()
  
  # return
  return(downsample_data)
}
