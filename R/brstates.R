# brstates.R: load States data for Brazil
# 
# Daniela Petruzalek <daniela.petruzalek@gmail.com>
# Jun, 3 2016

datasus.states <- function(english.names = TRUE) {
        require(dplyr)
        
        # Load required environment variables
        datasus.init()
        
        st.file <- file.path(datasus$workdir, "tb_uf.csv")
        if( !file.exists(st.file) ) {
                if( !dir.exists(datasus$workdir) ) dir.create(datasus$workdir)
                
                tmp <- file.path(datasus$workdir, "territory.zip")
                
                if( !file.exists(tmp) ) {
                        tmp <- file.path(datasus$workdir, "territory.zip")
                        download.file(datasus$territory_url, destfile = tmp)
                        unzip(tmp, files = "tb_uf.csv", exdir = datasus$workdir)
                }
        }
        
        # Load valid states
        tb_uf <- tbl_df(read.csv(st.file, header = TRUE, sep = ";", as.is = TRUE))
        
        # Filter unused columns
        tb_uf <- tb_uf %>% 
                filter(CO_STATUS == "ATIVO") %>% 
                select(-c(CO_STATUS, DS_NOME, CO_SUCESS, CO_ALTER, NU_ORDEM))
        
        # Rename column labels to English names
        if( english.names )
                tb_uf <- rename(tb_uf, 
                                state.code = CO_UF, 
                                state = DS_SIGLA, 
                                state.name = DS_NOMEPAD, 
                                region.code = CO_REGIAO, 
                                area = NU_AREA
                                )
        tb_uf
}