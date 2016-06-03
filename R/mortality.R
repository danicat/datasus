# mortality.R: load mortality data for Brazil
# 
# Daniela Petruzalek <daniela.petruzalek@gmail.com>
# Jun, 3 2016

datasus.mortality <- function(year, type = "DO", states = "ALL") {
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
        
        # if( type == "DO" )
        type.path   <- "DORES"
        file.prefix <- "DO"
        
        file.name  <- paste0(file.prefix, sel_states, year, ".dbc")
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
                df$state <- sel_states[i]
                mort <- rbind(df, mort, make.row.names = FALSE)
        }
        mort %>% rename(dd_num     = NUMERODO,  # Declaration of Death #
                        type       = TIPOBITO,  # Type of death 1 = fetal / 2 = non fetal
                        date       = DTOBITO,
                        time       = HORAOBITO,
                        birthplace = NATURAL,
                        birthdate  = DTNASC,
                        age        = IDADE,
                        sex        = SEXO,
                        race       = RACACOR,
                        marital.status = ESTCIV,
                        education      = ESC,
                        profession     = OCUP,
                        cause.of.death = CAUSABAS # By CID-10
                        ) %>%
                select(dd_num, type, date, time, birthplace, birthdate, age, sex, 
                       race, marital.status, education, profession, cause.of.death)
}