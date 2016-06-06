# Rdatasus

Author: Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
License: GPLv3

## Introduction

This project is a collection of R scripts to create an interface to the Public Healthcare Data repositories made available by the Brazil's Ministry of Health. The government agency responsible for publishing this data is called [DATASUS](http://datasus.saude.gov.br/), hence the name of the collection.

My motivation for this project is pretty much summarized by this article: http://simplystatistics.org/2016/04/20/data-repositories/

This project's current status is **Work in Progress (WIP)**. If you have any questions, suggestions and improvement requests, please feel free to contact me and I'll do my best to reply.

## Code Book

See [CodeBook.md](/inst/CodeBook.md)

## Usage Notes

The function `datasus.mortality` loads the mortality data set for any given `year`. You can also specify the type of mortality data to load with parameter `type`. If not specified, the default `DO` type is loaded. (See [Code Book](/inst/CodeBook.md) for supported types)

You can also specify which States to load data, but this information granularity is only available for the `DO` file type. For all others even if you specify the `states` parameter, data will be loaded for the entire country.

In order to use the scripts, you need to source them first:

        source("R/datasus.R")
        source("R/brstates.R")
        source("R/mortality.R")

The script `datasus.R` contains the setup for the work variables. Please make sure that the local cache directory (`datasus$workdir`) is set up correctly before running the `datasus.mortality` funcion.

## Examples

Loading 'DO' mortality data for the state of PR in year 2011:

        > df <- datasus.mortality(2011, state = "PR")
        trying URL 'ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOPR2011.dbc'
        Content type 'unknown' length 4110944 bytes (3.9 MB)
        ==================================================
        downloaded 3.9 MB
        
        > str(df)
        'data.frame':	68598 obs. of  52 variables:
         $ dec.death.id    : chr  "00139859" "00302513" "00302514" "00302515" ...
         $ inst.code       : chr  "MPR4113700001" "MPR4112400001" "MPR4112400001" "MPR4112400001" ...
         $ type            : chr  "2" "2" "2" "2" ...
         (...)

Loading child mortality data for the year of 2011:

        > doinf <- datasus.mortality(2011, type = "DOINF")
        trying URL 'ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DOFET/DOINF11.dbc'
        Content type 'unknown' length 2936573 bytes (2.8 MB)
        ==================================================
        downloaded 2.8 MB
        
        > str(doinf)
        'data.frame':	39716 obs. of  52 variables:
         $ dec.death.id    : chr  "05809556" "05809986" "05809988" "09550990" ...
         $ inst.code       : chr  "MRO1100090001" "MRO1100040001" "MRO1100040001" "MRO1100200003" ...
         $ type            : chr  "2" "2" "2" "2" ...
        (...)
        
## Dependencies

It may worth to note that this code depends on my [read.dbc](https://github.com/danicat) package and the `dplyr` package.

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](https://twitter.com/danicat83).
