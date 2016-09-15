# territory.R: Load territory data for Brazil
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

#' Load Brazil's territory data
#'
#' This function loads the territory data about the Brazilian federated units (UF).
#' @details
#' Code Book:
#' 
#' state.code   integer. Code (key) used by other DATASUS systems
#' state        character. Two digit UF code (official short name)
#' state.name   character. State name in uppercase
#' region.code  integer. 1=north, 2=northeast, 3=southeast, 4=south, 5=centerwest
#' area         integer. Area in square kilometers 
#'
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Unified Health System (SUS) and is resposible for publishing public healthcare data. Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data. The name DATASUS is also often used to represent the public datasets they provide.
#'
#' Neither this project, nor its author, has any association with the brazilian government.
#' @param english Logical. Set to true to translate column names to English. Otherwise the column names are loaded in portuguese. Default is true.
#' @return a data.frame with Brazil's territory data
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{datasus.init}}
#' @examples
#'
#' tb_uf <- territory.load()
territory.load <- function(english = TRUE) {
    require(dplyr)
    
    # Check if environment is loaded        
    if( !exists("datasus.env") ) {
        stop("DATASUS environment not loaded. Please call datasus.init")
    }
    
    tf <- file.path(datasus.env$territory_dir, "tb_uf.csv")
    
    if( !file.exists(tf) ) {
        tmp <- file.path(datasus.env$territory_dir, "territory.zip")
        
        if( !file.exists(tmp) ) {
            download.file(datasus.env$territory_url, destfile = tmp)
        }
        
        unzip(tmp, files = "tb_uf.csv", exdir = datasus.env$territory_dir)
    }
    
    # Load valid states
    tb_uf <- tbl_df(read.csv(tf, header = TRUE, sep = ";", as.is = TRUE))
    
    # Filter unused columns
    tb_uf <- tb_uf %>% 
        filter(CO_STATUS == "ATIVO") %>% 
        select(-c(CO_STATUS, DS_NOME, CO_SUCESS, CO_ALTER, NU_ORDEM))
    
    # Rename column labels to English names
    if( english )
        tb_uf <- rename(tb_uf, 
                        state.code  = CO_UF, 
                        state       = DS_SIGLA, 
                        state.name  = DS_NOMEPAD, 
                        region.code = CO_REGIAO, 
                        area        = NU_AREA
        )
    tb_uf
}