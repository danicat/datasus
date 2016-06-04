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
        mort %>% rename(dec.death.id      = NUMERODO,  # Declaration of Death #
                        type              = TIPOBITO,  # Type of death 1 = fetal / 2 = non fetal
                        date              = DTOBITO,   # ddmmyyyy
                        time              = HORAOBITO, # hhmm
                        birthplace        = NATURAL,   # country code or the number 8 followed by state code if local
                        birthdate         = DTNASC,    # ddmmyyyy
                        age               = IDADE,     # first digit: age type
                        sex               = SEXO,
                        race              = RACACOR,
                        marital.status    = ESTCIV,
                        education         = ESC,
                        occupation        = OCUP,
                        county.res.id     = CODMUNRES, # county of residency
                        #nb.res.id         = CODBAIRES, # neighborhood of residency
                        local.of.death    = LOCOCOR,
                        facility.id       = CODESTAB,  # establishment of death
                        cty.death.id      = CODMUNOCOR, # county where he/she died
                        #nb.death.id       = CODBAIOCOR, # neighborhood where he/she died
                        # Fields below only filled when fetal death or < than 1 year old
                        age.mother        = IDADEMAE, # age of the mother
                        educ.mother       = ESCMAE, # education of the mother
                        occup.mother      = OCUPMAE,
                        num.chld.alive   = QTDFILVIVO,
                        num.chld.dead    = QTDFILMORT,
                        pregnancy         = GRAVIDEZ,
                        gestation         = GESTACAO,
                        child.birth       = PARTO,
                        childbirth.time = OBITOPARTO, # Timing of death in relation to child-birth
                        weight            = PESO,
                        birth.cert.id     = NUMERODN, # birth certificate #
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
                        line.II           = LINHAII,
                        cause.of.death    = CAUSABAS, # By CID-10
                        #signature.type    = TPASSINA,
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
                        #registry.state    = UFINFORM,
                        inst.code         = CODINST
                        #cause.death.pre   = CB_PRE
                        )
}