# datasus.R: interface for loading Brazil's Public Healthcare data
# 
# Daniela Petruzalek <daniela.petruzalek@gmail.com>
# Jun, 3 2016

library(dplyr)
library(read.dbc)

datasus.init <- function() {
        if( !exists("datasus") ) {
                datasus <<- new.env()
                
                # Service URLs
                datasus$base_url        <- "ftp://ftp.datasus.gov.br/dissemin/publicos"
                datasus$territory_url   <- "ftp://ftp.datasus.gov.br/territorio/tabelas/base_territorial.zip"
                
                # System Names
                datasus$mortality       <- "SIM"
                
                # Local Workspace
                datasus$workdir <- path.expand("~/Rdatasus/data")
                datasus$tempdir <- tempdir()
                
                message("DATASUS environment variables loaded successfuly")
        }
}