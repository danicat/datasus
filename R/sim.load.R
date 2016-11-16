# sim.load.R 
# Copyright (C) 2016 Daniela Petruzalek
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Provides Access to the Declarations of Death (Children) Dataset from the Mortality Information System (SIM).
#'
#' \code{sim.load} returns a data.frame with a subset of the Declarations of Death dataset from the selected types (categories).
#' 
#' @details
#' The Mortality Information System (SIM) offers health managers, researchers and institutions highly relevant information for defining priorities for disease prevention and control programmes, based on death statement information collected by the State Health Departments. The national Database generated from this information is administered by the Health Surveillance Secretariat in cooperation with DATASUS.
#'
#' The system works through the filling in and collection of a standard document, the Death Statement (Declaration of Death), which is entered onto the system in the states and municipalities. The data collected is of great importance for health surveillance and epidemiological analysis, as well as health and demographical statistics.
#'
#' This system contains data divided in the following categories:
#' 
#' \itemize{
#'  \item DO: Declarations of death  
#'  \item DOFET: Declarations of death (Fetal)  
#'  \item DOEXT: Declarations of death (External Causes)  
#'  \item DOINF: Declarations of death (Children)  
#'  \item DOMAT: Declarations of death (Maternal)
#' }
#' 
#' The \code{sim.*} functions are provided for each available subsystem, for example, \code{sim.dofet}, \code{sim.doext} and so on.
#' 
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Unified Health System (SUS) and is resposible for publishing public healthcare data. Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data. The name DATASUS is also often used to represent the public datasets they provide.
#'
#' Neither this project, nor its author, has any association with the brazilian government.
#' @param types    character; an array with any combination of the supported types: DO, DOFET, DOINF, DOMAT, DOEXT.
#' @param years    numeric; one or more years representing the data to be read
#' @param states   character; one or more state (UF) representing the location of the data to be read, or 'ALL' if you want to read data from all states (UFs) at the same time. Only valid for the DO type.
#' @param language character; column names in Portuguese ("pt") or English ("en"). Default is "en".
#' @return a data.frame with Brazil's mortality data
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{datasus.init}} \code{\link{read.dbc}}
#' @examples
#'
#' # Loads Maternal Deaths for 2010
#' domat10 <- sim.load('DOMAT', 2010)
#' 
#' # Loads Fetal Deaths for 2012
#' dofet12 <- sim.load('DOFET', 2012)
#' 
#' # Loads Fetal and Infant Deaths for 2010 with ALL fields selected (field naming only available in Portuguese)
#' do2010  <- sim.load(c('DOFET','DOINF'), 2010, fields = 'ALL')
#' 
sim.load <- function(types, years, states = "", language = datasus.lang(), fields = NA) {
    # Check if environment is loaded        
    if( !exists("datasus.env") ) {
        stop("DATASUS environment not loaded. Please call datasus.init")
    }
    
    # Validate Input
    language   <- datasus.validate.language(language)
    
    states     <- toupper(states)
    
    sel_types <- types[ types %in% c('DO','DORES', 'DOFET','DOMAT','DOINF','DOEXT') ]
    
    if( length(sel_types) == 0 )
        stop("Invalid 'types' input.")
        
    suppressWarnings(
    if( any(c("DO", "DORES") %in% sel_types) )
        if( states == "ALL")
            sel_states <- datasus.env$br.uf
        else
            sel_states <- states[states %in% datasus.env$br.uf]
    )
     
    if( any(c("DO", "DORES") %in% sel_types) && length(sel_states) == 0 )
        stop("Invalid 'states' input.")

    # Select which fields of the files will be loaded
    if( is.na(fields) ) {
        if( any(c("DOFET", "DOMAT", "DOINF") %in% sel_types) ) {
            # This is a temporary fix for file incompatibilities
            fields.ptb <- setdiff(datasus.env$SIM.fields.pt, c('HORAOBITO',
                                                              'CODESTAB',
                                                              'NUMERODN',
                                                              'DTATESTADO',
                                                              'TPPOS',
                                                              'DTINVESTIG',
                                                              'CAUSABAS_O',
                                                              'DTCADASTRO',
                                                              'ATESTANTE',
                                                              'FONTEINV',
                                                              'DTRECEBIM',
                                                              'CODINST',
                                                              'OBITOGRAV',
                                                              'OBITOPUERP')
                                 )
            fields.eng <- datasus.env$SIM.fields.en[ datasus.env$SIM.fields.pt %in% fields.ptb ]
        }
        else {
            fields.ptb <- datasus.env$SIM.fields.pt
            fields.eng <- datasus.env$SIM.fields.en
        }
    }
    else if( fields == 'ALL' ) {
        fields.ptb <- NA
        language   <- "pt" # currently not all columns have translations
    }
    else {
        fields.ptb <- datasus.env$SIM.fields.pt[ fields ]
        fields.eng <- datasus.env$SIM.fields.en[ fields ]
    }
    
    sim <- data.frame()
    
    for(t in sel_types) {
        for(i in years) {
            # Prepare local file names and remote download paths
            if( i < 1996 )
                cid <- "CID9"
            else
                cid <- "CID10"
            
            if( t == "DO" || t == "DORES" ) {
                filenames  <- paste0("DO", sel_states, strftime(paste0(i,"-01-01"), format = "%Y"), ".dbc")
                localnames <- file.path(datasus.env$SIM.DORES_dir, filenames)
                url.base   <- paste(datasus.env$SIM_url, cid, "DORES", sep = "/" )
            } 
            else if( t == "DOFET" ) {
                filenames  <- paste0("DOFET", strftime(paste0(i,"-01-01"), format = "%y"), ".dbc")
                localnames <- file.path(datasus.env$SIM.DOFET_dir, filenames)
                url.base   <- paste(datasus.env$SIM_url, cid, "DOFET", sep = "/" )
            }
            else if( t == "DOEXT" ) {
                filenames  <- paste0("DOEXT", strftime(paste0(i,"-01-01"), format = "%y"), ".dbc")
                localnames <- file.path(datasus.env$SIM.DOEXT_dir, filenames)
                url.base   <- paste(datasus.env$SIM_url, cid, "DOFET", sep = "/" ) # DOFET -> not a bug!
            }
            else if( t == "DOINF") {
                filenames  <- paste0("DOINF", strftime(paste0(i,"-01-01"), format = "%y"), ".dbc")
                localnames <- file.path(datasus.env$SIM.DOINF_dir, filenames)
                url.base   <- paste(datasus.env$SIM_url, cid, "DOFET", sep = "/" ) # DOFET -> not a bug!
            }
            else if( t == "DOMAT") {
                filenames  <- paste0("DOMAT", strftime(paste0(i,"-01-01"), format = "%y"), ".dbc")
                localnames <- file.path(datasus.env$SIM.DOMAT_dir, filenames)
                url.base   <- paste(datasus.env$SIM_url, cid, "DOFET", sep = "/" ) # DOFET -> not a bug!
            }
            
            # Download required files (if needed)
            for(i in 1:length(localnames) ) {
                if( !file.exists(localnames[i]) ) {
                    # Try default path
                    url <- paste(url.base, filenames[i], sep = "/" )
                    
                    if( download.file(url, destfile = localnames[i]) ) {
                        # Some of the files are postfixed as .DBC (uppercase), try again on error
                        url <- paste(url.base, toupper(filenames[i]), sep = "/" )
                        download.file(url, destfile = localnames[i], mode = "wb")
                    }
                }
            }

            # Load downloaded files into a data.frame
            for(i in 1:length(localnames)) {
                df <- read.dbc::read.dbc(localnames[i], as.is = TRUE)

                # Select only applicable fields
                if( !is.na(fields.ptb) )
                    df <- df[, fields.ptb]
                
                # This column is used as an indicator of which file originated the data
                df$dataset <- filenames[i]
                
                sim <- rbind(df, sim, make.row.names = FALSE)
            }
        }
    }
        
    # Translate field names to English
    if( language == "en" ) {
        names(sim) <- fields.eng
    }
    
    # Returns data.frame
    sim
}