# mortality.R: load mortality data for Brazil
# 
# Daniela Petruzalek <daniela.petruzalek@gmail.com>
# Jun, 3 2016

# This function downloads the required data set (if not on cache dir) and 
datasus.mortality <- function(year, type = "DO", states = "ALL") {
        # Current version not prepared to handle several years at a time
        if( length(year) > 1 ) {
                warning("Please specify only one year at a time.")
                stop()                
        }
        
        suppressWarnings(
        if( states != "ALL" & type != "DO" ) {
                warning("Parameter 'states' ignored: valid only for 'DO' type.")
        }
        )
        
        all_states <- datasus.states() %>% select(state)
        
        # Validate Input
        suppressWarnings(
        if( states == "ALL") 
                sel_states <- all_states$state
        else
                sel_states <- states[states %in% all_states$state]
        )
        
        if( year < 1996 )
                cid <- "CID9"
        else
                cid <- "CID10"
        
        # DO: declarations of death
        if( type == "DO" ) {
                type.path     <- "DORES"
                file.prefix   <- "DO"
                year.mask     <- "%Y"
                states.prefix <- sel_states
        }
        # DOFET: declarations of death (fetal)
        else if( type == "DOFET" ) {
                type.path     <- "DOFET"
                file.prefix   <- "DOFET"                
                year.mask     <- "%y"
                states.prefix <- ""
        }
        # DOEX: declarations of death (external causes)
        else if( type == "DOEXT" ) {
                type.path     <- "DOFET" # same as above, not a bug!
                file.prefix   <- "DOEXT"
                year.mask     <- "%y"
                states.prefix <- ""
        }
        # DOINF: declarations of death (children)
        else if( type == "DOINF" ) {
                type.path     <- "DOFET" # same as above, not a bug!
                file.prefix   <- "DOINF"
                year.mask     <- "%y"
                states.prefix <- ""
        }
        # DOMAT: declarations of death (mother)
        else if( type == "DOMAT") {
                type.path     <- "DOFET" # same as above, not a bug!
                file.prefix   <- "DOMAT"
                year.mask     <- "%y"
                states.prefix <- ""
        }
        else {
                warning("Invalid file type specified. Valid types: 'DO', 'DOFET'")
                stop()
        }
                
        file.name  <- paste0(file.prefix, states.prefix, strftime(paste0(year,"-01-01"), format = year.mask), ".dbc")
        local.name <- file.path(datasus$workdir, file.name)
        
        url.base   <- paste(datasus$base_url, datasus$mortality, cid, type.path, sep = "/" )
        
        for(i in 1:length(local.name) ) {
                if( !file.exists(local.name[i]) ) {
                        # Try default path
                        url <- paste(url.base, file.name[i], sep = "/" )

                        if( download.file(url, destfile = local.name[i]) ) {
                                # Some of the files are postfixed as .DBC (uppercase), try again on error
                                url <- paste(url.base, toupper(file.name[i]), sep = "/" )
                                download.file(url, destfile = local.name[i])
                        }
                }
        }
        
        # Load data and return data.frame
        mort <- data.frame()
        for(i in 1:length(local.name)) {
                df <-read.dbc(local.name[i], as.is = TRUE)
                
                # This column is used as an indicator of which file originated the data
                df$dataset <- file.name[i]

                # Translate variable names to English
                # See CodeBook.md for variable descriptions and values
                df <- rename(df, dec.death.id     = NUMERODO,
                                type              = TIPOBITO,
                                date              = DTOBITO,
                                time              = HORAOBITO,
                                birthplace        = NATURAL,
                                birthdate         = DTNASC,
                                age               = IDADE,
                                sex               = SEXO,
                                race              = RACACOR,
                                marital.status    = ESTCIV,
                                education         = ESC,
                                occupation        = OCUP,
                                county.res.id     = CODMUNRES,
                                #nb.res.id         = CODBAIRES,
                                local.of.death    = LOCOCOR,
                                facility.id       = CODESTAB,
                                cty.death.id      = CODMUNOCOR,
                                age.mother        = IDADEMAE,
                                educ.mother       = ESCMAE,
                                occup.mother      = OCUPMAE,
                                num.chld.alive    = QTDFILVIVO,
                                num.chld.dead     = QTDFILMORT,
                                pregnancy         = GRAVIDEZ,
                                gestation         = GESTACAO,
                                child.birth       = PARTO,
                                childbirth.time   = OBITOPARTO,
                                weight            = PESO,
                                birth.cert.id     = NUMERODN,
                                pregnancy.death   = OBITOGRAV,
                                puerperium.death  = OBITOPUERP,
                                med.assist        = ASSISTMED,
                                comp.exams        = EXAME,
                                surgery           = CIRURGIA,
                                necropsy          = NECROPSIA,
                                line.a            = LINHAA,
                                line.b            = LINHAB,
                                line.c            = LINHAC,
                                line.d            = LINHAD,
                                line.ii           = LINHAII,
                                cause.of.death    = CAUSABAS,
                                certificate.date  = DTATESTADO,
                                accident.type     = CIRCOBITO,
                                work.accident     = ACIDTRAB,
                                source            = FONTE,
                                investigated      = TPPOS,
                                investig.date     = DTINVESTIG,
                                orig.cause        = CAUSABAS_O,
                                input.date        = DTCADASTRO,
                                cert.officer      = ATESTANTE,
                                investig.source   = FONTEINV,
                                receipt.date      = DTRECEBIM,
                                inst.code         = CODINST
                ) %>% 
                # Select only those names that were translated (see CodeBook.md for more info)
                # This filter is done before rbind because fields are not consistent within files
                select(-matches("[A-Z]+", ignore.case = FALSE))

                mort <- rbind(df, mort, make.row.names = FALSE)
        }
        
        # Returns mortality data
        mort
}