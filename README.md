
# actilifecounts

<!-- badges: start -->
<!-- badges: end -->

The goal of actilifecounts is to generate [ActiGraph](https://actigraphcorp.com/)
activity counts as described by [Ali Neishabouri et al.](https://www.researchsquare.com/article/rs-1370418/v1)

The actilifecounts R package is mostly a translation of the python-based [agcounts](https://github.com/actigraph/agcounts) module.

Additional features of the actilifecounts package include the possibility of
calculating activity counts from any accelerometer brand, with a more flexible
approach to handle different sampling frequencies.

## Installation

You can install the development version of actilifecounts from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jhmigueles/actilifecounts")
```

## Generating activity counts

This is a basic example which shows you how to generate activity counts.

``` r
library(actilifecounts)
# read accelerometer data (for example, from a csv file)
filename = "C:/mystudy/mydata/myfile.csv"
raw = data.table::fread(filename)
counts = get_counts(raw, sf = 100, epoch = 60, lfe_select = FALSE, verbose = TRUE)
```

If 3 axes are provided, the code assumes that the columns represent the X, Y, and Z axes in that order.
