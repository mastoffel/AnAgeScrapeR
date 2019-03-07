
<!-- README.md is generated from README.Rmd. Please edit that file -->
AnAgeScrapeR
============

AnAgeScrapeR lets you extract data for one or more species from the AnAge database: <http://genomics.senescence.info/species/>. The official citation is:

Tacutu, R., Thornton, D., Johnson, E., Budovsky, A., Barardo, D., Craig, T., Diana, E., Lehmann, G., Toren, D., Wang, J., Fraifeld, V. E., de Magalhaes, J. P. (2018) "Human Ageing Genomic Resources: new and updated databases." Nucleic Acids Research 46(D1):D1083-D1090.

Installation
------------

You can install AnAgeScrapeR from GitHub. Dependencies are all from the [tidyverse](https://www.tidyverse.org/).

``` r
# install.packages("remotes")
remotes::install_github("mastoffel/AnAgeScrapeR", dependencies = TRUE)
```

Example
-------

So far, only the latin species names can be used (case insensitive). By default, there should be a space between Genus and Species name, but other delimiters can be used with the name\_sep argument. The database is downloaded into your working directory (as it's a zip file which is difficult to directly read into R) when you extract data for the first time. Afterwards you can set download\_data to FALSE, except for you want to download it again to be sure you have the newest version.

``` r
library(AnAgeScrapeR)
species <- c("felis catus", "Sterna paradisaea")
dat <- scrape_AnAge(latin_name = species,
                    vars = c("maximum_longevity_yrs","female_maturity_days"))
dat
#> # A tibble: 2 x 3
#>   genus_species     maximum_longevity_yrs female_maturity_days
#>   <chr>             <chr>                 <chr>               
#> 1 sterna paradisaea 34                    1095                
#> 2 felis catus       30                    289
```

There are quite a few more life history traits to extract, which can be found in AnAge\_variables. The unit in which a variable is measured is simply the last bit of the variable name.

``` r
data(AnAge_variables)
AnAge_variables
#>  [1] "female_maturity_days"            "male_maturity_days"             
#>  [3] "gestation_incubation_days"       "weaning_days"                   
#>  [5] "litter_clutch_size"              "litters_clutches_per year"      
#>  [7] "interlitter_interbirth_interval" "birth_weight_g"                 
#>  [9] "weaning_weight_g"                "adult_weight_g"                 
#> [11] "growth_rate_1_days"              "maximum_longevity_yrs"          
#> [13] "source"                          "specimen_origin"                
#> [15] "sample_size"                     "data_quality"                   
#> [17] "imr_per_year"                    "mrdt_yrs"                       
#> [19] "metabolic_rate_w"                "body_mass_g"                    
#> [21] "temperature_k"                   "references"
```
