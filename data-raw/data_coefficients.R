# BPF. There are extraneous coefficients as to match constants ------------
# in ActiLife.
# Input data coefficients.
input_coeffs = matrix(data = c(-0.009341062898525,
                               -0.025470289659360,
                               -0.004235264826105,
                               0.044152415456420,
                               0.036493718347760,
                               -0.011893961934740,
                               -0.022917390623150,
                               -0.006788163862310,
                               0.000000000000000), nrow = 1)
# output data coefficients
output_coeffs = matrix(data = c(1.00000000000000000000,
                                -3.63367395910957000000,
                                5.03689812757486000000,
                                -3.09612247819666000000,
                                0.50620507633883000000,
                                0.32421701566682000000,
                                -0.15685485875559000000,
                                0.01949130205890000000,
                                0.00000000000000000000), nrow = 1)



# RESAMPLING FACTORS ------------------------------------------------------

resample_factors = as.matrix(data.frame(sf = seq(30, 100, by = 10),
                                        upsample_factor = c(1, 3, 3, 1, 3, 3, 1, 3), # upsample to multiple of 3
                                        downsample_factor = c(1, 4, 5, 2, 7, 8, 3, 10))) # downsample to 30 Hz


usethis::use_data(input_coeffs, output_coeffs, resample_factors, internal = TRUE)
