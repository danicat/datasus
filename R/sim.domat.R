# sim.domat.R 
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

#' Provides Access to the Declarations of Death (Children) Dataset from the Mortality Information System (SIM).
#'
#' \code{sim.domat} returns a data.frame with a subset of the Declarations of Death - Maternal (DOMAT) dataset
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
#' @param years  numeric; one or more years representing the data to be read
#' @param english logical; translates column names from Portuguese (Brazil) to English. Default is TRUE.
#' @return a data.frame with Brazil's mortality data
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{datasus.init}} \code{\link{read.dbc}}
#' @examples
#'
#' pr10 <- sim.domat(2010)
sim.domat <- function(years, english = TRUE) {
    
    # Check if environment is loaded        
    if( !exists("datasus.env") ) {
        stop("DATASUS environment not loaded. Please call datasus.init")
    }
    
    sim <- data.frame()
    
    for(i in years) {
        # Prepare local file names and remote download paths
        if( i < 1996 )
            cid <- "CID9"
        else
            cid <- "CID10"
        
        filenames  <- paste0("DOMAT", strftime(paste0(i,"-01-01"), format = "%y"), ".dbc")
        localnames <- file.path(datasus.env$SIM.DOMAT_dir, filenames)
        
        url.base   <- paste(datasus.env$SIM_url, cid, "DOFET", sep = "/" ) # DOFET -> not a bug!
        
        # Download required files (if needed)
        for(i in 1:length(localnames) ) {
            if( !file.exists(localnames[i]) ) {
                # Try default path
                url <- paste(url.base, filenames[i], sep = "/" )
                
                if( download.file(url, destfile = localnames[i]) ) {
                    # Some of the files are postfixed as .DBC (uppercase), try again on error
                    url <- paste(url.base, toupper(filenames[i]), sep = "/" )
                    download.file(url, destfile = localnames[i])
                }
            }
        }
        
        # Select which fields of the files will be loaded
        fields     <- c('NUMERODO',
                        'TIPOBITO',
                        'DTOBITO',
                        'HORAOBITO',
                        'NATURAL',
                        'DTNASC',
                        'IDADE',
                        'SEXO',
                        'RACACOR',
                        'ESTCIV',
                        'ESC',
                        'OCUP',
                        'CODMUNRES',
                        'LOCOCOR',
                        'CODESTAB',
                        'CODMUNOCOR',
                        'IDADEMAE',
                        'ESCMAE',
                        'OCUPMAE',
                        'QTDFILVIVO',
                        'QTDFILMORT',
                        'GRAVIDEZ',
                        'GESTACAO',
                        'PARTO',
                        'OBITOPARTO',
                        'PESO',
                        'NUMERODN',
                        'OBITOGRAV',
                        'OBITOPUERP',
                        'ASSISTMED',
                        'EXAME',
                        'CIRURGIA',
                        'NECROPSIA',
                        'LINHAA',
                        'LINHAB',
                        'LINHAC',
                        'LINHAD',
                        'LINHAII',
                        'CAUSABAS',
                        'DTATESTADO',
                        'CIRCOBITO',
                        'ACIDTRAB',
                        'FONTE',
                        'TPPOS',
                        'DTINVESTIG',
                        'CAUSABAS_O',
                        'DTCADASTRO',
                        'ATESTANTE',
                        'FONTEINV',
                        'DTRECEBIM',
                        'CODINST'
                        )

        # English translations. See CodeBook.md for variable descriptions and values
        fields.eng <- c('death.id',
                        'type',
                        'date',
                        'time',
                        'birthplace',
                        'birthdate',
                        'age',
                        'sex',
                        'race',
                        'marital.status',
                        'education',
                        'occupation',
                        'residency.county.id',
                        'death.place',
                        'facility.id',
                        'death.county.id',
                        'mother.age',
                        'mother.education',
                        'mother.occupation',
                        'num.alive.child',
                        'num.dead.child',
                        'pregnancy',
                        'gestation',
                        'childbirth',
                        'childbirth.death',
                        'weight',
                        'birth.cert.id',
                        'pregnancy.death',
                        'puerperium.death',
                        'medical.assistance',
                        'complimentary.exams',
                        'surgery',
                        'necropsy',
                        'line.a',
                        'line.b',
                        'line.c',
                        'line.d',
                        'line.ii',
                        'cause.of.death',
                        'certificate.date',
                        'accident.type',
                        'work.accident',
                        'source',
                        'investigated',
                        'investig.date',
                        'orig.cause',
                        'input.date',
                        'cert.officer',
                        'investig.source',
                        'receipt.date',
                        'inst.code'
                        )

        # Load downloaded files into a data.frame
        for(i in 1:length(localnames)) {
            df <- read.dbc::read.dbc(localnames[i], as.is = TRUE)
            
            # Select only applicable fields
            df <- df[, fields]
            
            # Translate field names to English
            if( english ) {
                names(df) <- fields.eng
            }
            
            # This column is used as an indicator of which file originated the data
            df$dataset <- filenames[i]
            
            sim <- rbind(df, sim, make.row.names = FALSE)
        }
    }
    # Returns data.frame
    sim
}