# cnes.lt.R 
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

#' Provides Access to the Beds Dataset from the National Register of Health Establishments (CNES).
#'
#' \code{cnes.lt} returns a data.frame with a subset of the Beds (LT) dataset
#' 
#' @details
#' This system contains data divided in the following categories:
#' 
#' \itemize{
#'  \item LT: Beds (from Oct 2005)
#'  \item ST: Establishments (from Aug 2005)
#'  \item DC: Complimentary Data (from Aug 2005)
#'  \item EQ: Equipments (from Aug 2005)
#'  \item SR: Specialized Services (from Aug 2005)
#'  \item HB: License (from Mar 2007)
#'  \item PF: Practitioner (from Ago 2005)
#'  \item EP: Teams (from Apr 2007)
#'  \item RC: Contractual Rules (from Mar 2007)
#'  \item IN: Incentives (from Nov 2007)
#'  \item EE: Teaching Establishments (from Mar 2007)
#'  \item EF: Philanthropic Establishment (from Mar 2007)
#'  \item GM: Management and Goals (from Jun 2007)
#' }
#' 
#' The \code{cnes.*} functions are provided for each available subsystem, for example, \code{cnes.lt}, \code{cnes.gm} and so on.
#' 
#' @note
#' DATASUS is the name of the Department of Informatics of the Brazilian Unified Health System (SUS) and is resposible for publishing public healthcare data. Besides the DATASUS, the Brazilian National Agency for Supplementary Health (ANS) also uses this file format for its public data. The name DATASUS is also often used to represent the public datasets they provide.
#'
#' Neither this project, nor its author, has any association with the brazilian government.
#' @param years  numeric; one or more years to select the target data to be read
#' @param months numeric; one or more months to select the target data to be read
#' @param states character; one or more state (UF) representing the location of the data to be read, or 'ALL' if you want to read data from all states (UFs) at the same time.
#' @param language character; column names in Portuguese ("pt") or English ("en"). Default is "en".
#' @return a data.frame with Brazil's health establishment data
#' @keywords datasus
#' @export
#' @author Daniela Petruzalek, \email{daniela.petruzalek@gmail.com}
#' @seealso \code{\link{datasus.init}} \code{\link{read.dbc}}
#' @examples
#'
#' pr201001 <- cnes.lt(2010, 'jan', 'PR')
cnes.lt <- function(years, months, states, language = datasus.lang()) {
    # WIP
}