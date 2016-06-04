# datasus

Author: Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
License: GPLv3

# Introduction

This project is a collection of R scripts to create an interface to the Public Healthcare Data repositories made available by the Brazil's Ministry of Health. The government agency responsible for publishing this data is called [DATASUS](http://datasus.saude.gov.br/), hence the name of the collection.

My motivation for this project is pretty much summarized by this article: http://simplystatistics.org/2016/04/20/data-repositories/

This project's current status is **Work in Progress (WIP)**. This means it is far from complete and, for now at least, I can't guarantee that the most recent commit is not broken. I know it's not a best practice to commit non-working code, but it is a worst practice to lose all your work because you didn't commit, so... :)

If you have any questions, suggestions and improvement requests, please feel free to contact me and I'll do my best to reply. But please, don't submit bug reports (yet). As far as I know this project **IS** a bug.

# Code Book

See [CodeBook.md](/inst/CodeBook.md)

# Demo

Currently this code doesn't do too much, but I have a very basic structure working that loads data from the SIM (Mortality Information System). Here's an example:

        source("R/datasus.R")
        source("R/brstates.R")
        source("R/mortality.R")
        
        > m.prsc.2013 <- datasus.mortality(2013, states = c("PR","SC"))
        trying URL 'ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOPR2013.dbc'
        Content type 'unknown' length 4837023 bytes (4.6 MB)
        ==================================================
        downloaded 4.6 MB

        trying URL 'ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DOSC2013.dbc'
        Content type 'unknown' length 2392468 bytes (2.3 MB)
        ==================================================
        downloaded 2.3 MB

         > str(m.prsc.2013)
        'data.frame':	106215 obs. of  13 variables:
         $ dd_num        : chr  "00417021" "00146747" "00305485" "00417022" ...
         $ type          : chr  "2" "2" "2" "2" ...
         $ date          : chr  "18072013" "01072013" "09042013" "24042013" ...
         $ time          : chr  "1700" "0730" "0230" "1730" ...
         $ birthplace    : chr  NA "842" NA NA ...
         $ birthdate     : chr  "03011946" "27071968" "03082010" "15021939" ...
         $ age           : chr  "467" "444" "402" "474" ...
         $ sex           : chr  "2" "1" "2" "1" ...
         $ race          : chr  "1" "1" "1" "1" ...
         $ marital.status: chr  "2" "1" NA "3" ...
         $ education     : chr  NA "1" NA NA ...
         $ profession    : chr  "999993" NA NA NA ...
         $ cause.of.death: chr  "E109" "Q909" "Q289" "R98" ...
         - attr(*, "data_types")= chr  "C" "C" "C" "C" ...      
         
The code basically automates the data download and loading process. You can use any year and any state combination and it will load a table.data.frame with the desired content.

Note: I'm still translating the column names, so a lot of data is being filtered out in this first version.

## Dependencies

It may worth to note that this code depends on my [read.dbc](https://github.com/danicat) package and the `dplyr` package.

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](https://twitter.com/danicat83).