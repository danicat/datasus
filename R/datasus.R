# datasus.R: Interface for the Brazilian Public Healthcare datasets
# Copyright (C) 2016 Daniela Petruzalek
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Initialize DATASUS environment
#'
#' This function initializes the environment that contains the DATASUS package control variables, like the locations for the DATASUS ftp and the local working directory.
#' @details
#' This function prepares the \code{datasus.env} environment. You can specify the DATASUS working directory with the parameter \code{workdir} to set the local directory where to store the downloaded DATASUS files.
#' 
#' If the working directory is not specified, the default behaviour is to create a temporary directory. Please beware that when working with massive amounts of data, it's highly recommendable to set a local working directory,
#' to preserve both local and DATASUS bandwidth. Please use this behaviour wisely!
#'
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Unified Health System (SUS) and is resposible for publishing public healthcare data. Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data. The name DATASUS is also often used to represent the public datasets they provide.
#'
#' Neither this project, nor its author, has any association with the brazilian government.
#' @param workdir The local directory where to store de downloaded data. Defaults to \code{tempdir()}.
#' @return nothing
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{read.dbc}}
#' @examples
#'
#' datasus.init("~/datasus")
datasus.init <- function(workdir = tempdir()) {
    # Create environment to store parameters
    if( !exists("datasus.env") ) {
        datasus.env <<- new.env()
    }
    
    # Service URLs
    datasus.env$base_url      <- "ftp://ftp.datasus.gov.br/dissemin/publicos"
    datasus.env$territory_url <- "ftp://ftp.datasus.gov.br/territorio/tabelas/base_territorial.zip"
    
    # System URLs
    datasus.env$SIM_url       <- paste(datasus.env$base_url, "SIM", sep = "/")
    datasus.env$CNES_url      <- ""
    
    # Local Workspace
    datasus.env$workdir <- path.expand(workdir)
    datasus.env$tempdir <- tempdir()
    
    datasus.env$territory_dir <- file.path(datasus.env$workdir, "territory")
    datasus.env$SIM_dir       <- file.path(datasus.env$workdir, "SIM")
    datasus.env$SIM.DORES_dir <- file.path(datasus.env$SIM_dir, "DORES")
    datasus.env$SIM.DOFET_dir <- file.path(datasus.env$SIM_dir, "DOFET")
    datasus.env$SIM.DOEXT_dir <- file.path(datasus.env$SIM_dir, "DOEXT")
    datasus.env$SIM.DOINF_dir <- file.path(datasus.env$SIM_dir, "DOINF")
    datasus.env$SIM.DOMAT_dir <- file.path(datasus.env$SIM_dir, "DOMAT")
    datasus.env$CNES_dir      <- file.path(datasus.env$workdir, "CNES")
    
    # Create local directory structure
    dir.create(datasus.env$workdir, recursive = TRUE)
    dir.create(datasus.env$territory_dir)
    dir.create(datasus.env$SIM_dir)
    dir.create(datasus.env$SIM.DORES_dir)
    dir.create(datasus.env$SIM.DOFET_dir)
    dir.create(datasus.env$SIM.DOEXT_dir)
    dir.create(datasus.env$SIM.DOINF_dir)
    dir.create(datasus.env$SIM.DOMAT_dir)
    dir.create(datasus.env$CNES_dir)

    # Misc
    datasus.env$br.uf <- c('AC', 'AL', 'AP', 'AM',
                           'BA', 'CE', 'DF', 'ES',
                           'GO', 'MA', 'MT', 'MS',
                           'MG', 'PA', 'PB', 'PR',
                           'PE', 'PI', 'RJ', 'RN',
                           'RS', 'RO', 'RR', 'SC',
                           'SP', 'SE', 'TO')
    
    message("DATASUS environment loaded successfuly")
}