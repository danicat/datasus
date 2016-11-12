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
#' \code{datasus.init} initializes the environment that contains the DATASUS package control variables, like the locations for the DATASUS ftp and the local working directory.
#' 
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
#' @param workdir  character. The local directory where to store de downloaded data. Defaults to \code{tempdir()}.
#' @param language character. Selects the default language for column names. Valid values are: "en" for English and "pt" for Portuguese. Defaults to English.
#' @return nothing
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{read.dbc}}
#' @examples
#'
#' datasus.init("~/datasus")
datasus.init <- function(workdir = tempdir(), language = "en") {
    # Create environment to store parameters
    if( !exists("datasus.env") ) {
        datasus.env <<- new.env()
    }
    
    # Enabled languages
    datasus.env$valid_languages <- c("en","pt")
    
    language <- tolower(language)
    
    # Language used for column names
    if( !(language %in% datasus.env$valid_languages ) ) {
        warning("Invalid language. Using default (english).")
        datasus.env$language <- "en"
    }
    else {
        datasus.env$language <- language    
    }
    
    # Service URLs
    datasus.env$base_url      <- "ftp://ftp.datasus.gov.br/dissemin/publicos"
    datasus.env$territory_url <- "ftp://ftp.datasus.gov.br/territorio/tabelas/base_territorial.zip"
    datasus.env$tabcnes_url   <- "ftp://ftp.datasus.gov.br/dissemin/publicos/CNES/200508_/Auxiliar/tab_cnes_tabelasDBF_201512.zip"
    
    # System URLs
    datasus.env$SIM_url       <- paste(datasus.env$base_url, "SIM", sep = "/")
    datasus.env$CNES_url      <- paste(datasus.env$base_url, "CNES", "200508_", "Dados", sep = "/")
    
    # Local Workspace
    datasus.env$workdir <- path.expand(workdir)
    datasus.env$tempdir <- tempdir()
    
    # Local Paths
    datasus.env$territory_dir <- file.path(datasus.env$workdir, "territory")

    # SIM
    datasus.env$SIM_dir       <- file.path(datasus.env$workdir, "SIM")
    datasus.env$SIM.DORES_dir <- file.path(datasus.env$SIM_dir, "DORES")
    datasus.env$SIM.DOFET_dir <- file.path(datasus.env$SIM_dir, "DOFET")
    datasus.env$SIM.DOEXT_dir <- file.path(datasus.env$SIM_dir, "DOEXT")
    datasus.env$SIM.DOINF_dir <- file.path(datasus.env$SIM_dir, "DOINF")
    datasus.env$SIM.DOMAT_dir <- file.path(datasus.env$SIM_dir, "DOMAT")

    # CNES
    datasus.env$cnes_dir      <- file.path(datasus.env$workdir, "CNES")
    datasus.env$cnes.lt_dir   <- file.path(datasus.env$cnes_dir, "LT")
    datasus.env$cnes.st_dir   <- file.path(datasus.env$cnes_dir, "ST")
    datasus.env$cnes.dc_dir   <- file.path(datasus.env$cnes_dir, "DC")
    datasus.env$cnes.eq_dir   <- file.path(datasus.env$cnes_dir, "EQ")
    datasus.env$cnes.sr_dir   <- file.path(datasus.env$cnes_dir, "SR")
    datasus.env$cnes.hb_dir   <- file.path(datasus.env$cnes_dir, "HB")
    datasus.env$cnes.pf_dir   <- file.path(datasus.env$cnes_dir, "PF")
    datasus.env$cnes.ep_dir   <- file.path(datasus.env$cnes_dir, "EP")
    datasus.env$cnes.rc_dir   <- file.path(datasus.env$cnes_dir, "RC")
    datasus.env$cnes.in_dir   <- file.path(datasus.env$cnes_dir, "IN")
    datasus.env$cnes.ee_dir   <- file.path(datasus.env$cnes_dir, "EE")
    datasus.env$cnes.ef_dir   <- file.path(datasus.env$cnes_dir, "EF")
    datasus.env$cnes.gm_dir   <- file.path(datasus.env$cnes_dir, "GM")

    # Create directory structure
    
    # Helper function
    create.if.not.exists <- function(path, ...) {
        if( !dir.exists(path) )
            dir.create(path, ...)
    }
    
    # Create base directory structure
    create.if.not.exists(datasus.env$workdir, recursive = TRUE)
    
    # Territory
    create.if.not.exists(datasus.env$territory_dir)
    
    # SIM
    create.if.not.exists(datasus.env$SIM_dir)
    create.if.not.exists(datasus.env$SIM.DORES_dir)
    create.if.not.exists(datasus.env$SIM.DOFET_dir)
    create.if.not.exists(datasus.env$SIM.DOEXT_dir)
    create.if.not.exists(datasus.env$SIM.DOINF_dir)
    create.if.not.exists(datasus.env$SIM.DOMAT_dir)
    
    # CNES
    create.if.not.exists(datasus.env$cnes_dir)
    create.if.not.exists(datasus.env$cnes.lt_dir)
    create.if.not.exists(datasus.env$cnes.st_dir)
    create.if.not.exists(datasus.env$cnes.dc_dir)
    create.if.not.exists(datasus.env$cnes.eq_dir)
    create.if.not.exists(datasus.env$cnes.sr_dir)
    create.if.not.exists(datasus.env$cnes.hb_dir)
    create.if.not.exists(datasus.env$cnes.pf_dir)
    create.if.not.exists(datasus.env$cnes.ep_dir)
    create.if.not.exists(datasus.env$cnes.rc_dir)
    create.if.not.exists(datasus.env$cnes.in_dir)
    create.if.not.exists(datasus.env$cnes.ee_dir)
    create.if.not.exists(datasus.env$cnes.ef_dir)
    create.if.not.exists(datasus.env$cnes.gm_dir)
    
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

#' Returns datasus' Package Default Language Setup
#'
#' \code{datasus.lang} returns the current selected language as a two character code.
#' 
#' @details
#' The value returned by this function is set internally by a previous call to \code{\link{datasus.init}}. This value is used as a default language for every data access function of this package to define the language of the dataset column headers.
#' 
#' To provide more flexibility, every data access function has a parameter called \code{language} that can be used to override the initial language setting at runtime.
#' 
#' Current supported languages are "pt" (Brazilian Portuguese) and "en" (English).
#'
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Unified Health System (SUS) and is resposible for publishing public healthcare data. Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data. The name DATASUS is also often used to represent the public datasets they provide.
#'
#' Neither this project, nor its author, has any association with the brazilian government.
#' @return The default language code as set by a previous call to \code{\link{datasus.init}}
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{read.dbc}}
#' @examples
#' # Show current default language
#' datasus.lang()
datasus.lang <- function() {
    # Check if environment is loaded        
    if( !exists("datasus.env") ) {
        stop("DATASUS environment not loaded. Please call datasus.init")
    }

    # Return current default language
    datasus.env$language   
}

datasus.validate.language <- function(language) {
    if( !(tolower(language) %in% datasus.env$valid_languages) ) {
        warning("Invalid 'language' input. Using default.")
        language = datasus.lang()
    }
    language
}