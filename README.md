# datasus - An interface for the Brazilian Public Healthcare datasets in the R language

Author: Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
License: GPLv3

## Introduction

This project is an R package that provides an interface to the Public Healthcare Data repositories made available by the Brazil's Ministry of Health. The government agency responsible for publishing this data is called [DATASUS](http://datasus.saude.gov.br/), hence the name of the collection. Also, often the name 'datasus' is used by the community as an alias to refer the datasets.

My motivation for this project is pretty much summarized by this article: http://simplystatistics.org/2016/04/20/data-repositories/

This project's current status is **Work in Progress (WIP)**. If you have any questions, suggestions and improvement requests, please feel free to contact me and I'll do my best to reply.

## Code Book

Since most of the original documentation is written in Portuguese, I'm providing a CodeBook with the details of the most relevant fields of the dataset. I encourage the community to contribute to this work by documenting other parts of the dataset or any missing columns in my original work.

See [CodeBook.md](/inst/CodeBook.md)

## Installation

The best way to install this package is using `devtools`. See below an example of how to install this package directly from GitHub using `devtools::install_github`:

    > devtools::install_github("danicat/datasus")
    Downloading GitHub repo danicat/datasus@master
    from URL https://api.github.com/repos/danicat/datasus/zipball/master
    Installing datasus
    '/usr/lib/R/bin/R' --no-site-file --no-environ --no-save --no-restore --quiet CMD INSTALL  \
      '/tmp/RtmpKjIBxj/devtools713e2faa8a65/danicat-datasus-c0ef52c'  \
      --library='/home/dani/R/x86_64-pc-linux-gnu-library/3.3' --install-tests 
    
    * installing *source* package ‘datasus’ ...
    ** R
    ** inst
    ** preparing package for lazy loading
    ** help
    *** installing help indices
    ** building package indices
    ** testing if installed package can be loaded
    * DONE (datasus)

## Usage Notes

Before calling any function of the package, please call `datasus.init`. This will ensure the right environment variables are loaded and force the user (you) to specify a working directory.

The working directory is a local folder on your machine that will store all downloaded files. It's highly recommended that you store locally all the data you are going to use for your analysis to not over-stress the DATASUS' FTP server. Using a local working directory will ensure the downloaded data will be available between sessions without re-downloading everything, assuming you always use the same `workdir`.

If you call `datasus.init` without specifying a working directory it will use a `tempdir()`. While this behaviour is ok for simple tests it is not advisable for anything other than that by the reasons stated above.

## Examples

TBD

## Dependencies

This code depends on the [read.dbc](https://github.com/danicat) package (also available on CRAN).

## Contact Info

If you have any questions, please contact me at daniela.petruzalek@gmail.com. You may also follow me on [Twitter](https://twitter.com/danicat83).
