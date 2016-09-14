# DATASUS Code Book

Author: Daniela Petruzalek  
e-mail: daniela.petruzalek@gmail.com  
License: GPLv3

# SIM: Mortality Information System (Sistema de Informações de Mortalidade)

## File types

DO: Declarations of death
DOFET: Declarations of death (Fetal)
DOEXT: Declarations of death (External Causes)
DOINF: Declarations of death (Children)
DOMAT: Declarations of death (Mother)

## SIM Code Book

| Column Name    | Original Name | Description                             
|----------------|---------------|-----------------------------------------
| dec.death.id   | NUMERODO      | Declaration of death id number          
| type           | TIPOBITO      | Type of death: 1 = fetal; 2 = non fetal 
| date           | DTOBITO       | Date of death: ddmmyyyy                 
| time           | HORAOBITO     | Time of death: hhmm                     
| birthplace     | NATURAL       | Place of birth: Country code (3 letters) or the number 8 followed by state code (2 letters) if local
| birthdate      | DTNASC        | Date of birth: ddmmyyyy
| age            | IDADE         | First digit: age type (0=ignored or minutes, 1=hours, 2=days, 3=months, 4=years, 5=years above 100). Next two digits: age in the units explained above. Ex: 000=ignored, 020=20 minutes, 445=45 years
| sex            | SEXO          | 0=ignored, 1=male, 2=female
| race           | RACACOR       | race/color: 1=white, 2=black, 3=yellow(asian), 4=brown(pardo[1]), 5=indigene
| marital.status | ESTCIV        | 1=single, 2=married, 3=widowed, 4=divorced/separated, 9=ignored
| education      | ESC           | In years completed: 1=none, 2=1 to 3 years, 3=4 to 7 years, 4=8 to 11 years, 5=12+ years, 9=ignored
| occupation     | OCUP          | Follows the Brazilian Classification of Occupations (CBO-2002) compatible with CIUO-88
| county.res.id  | CODMUNRES     | County of residency id (IBGE)
| place.of.death | LOCOCOR       | 1=Hospital, 2=Another health facility, 3=Home, 4=public highway, 5=others, 9=ignored
| facility.id    | CODESTAB      | Facility id
| cty.death.id   | CODMUNOCOR    | County of death
| age.mother     | IDADEMAE      | Age of the mother, in years
| educ.mother    | ESCMAE        | Years of education of the mother (see `education` above)
| ocup.mother    | OCUPMAE       | Occupation of the mother (see `occupation` above)
| num.chld.alive | QTDFILVIVO    | Number of living children
| num.chld.dead  | QTDFILMORT    | Number of dead children (not including this report)
| pregnancy      | GRAVIDEZ      | Type of pregnancy: 1=Single, 2=Double, 3=Triple or more, 9=ignored
| gestation      | GESTACAO      | Gestational age (weeks): 1=less than 22, 2=22 to 27, 3=28 to 31, 4=32 to 36, 5=37 to 41, 6=42+, 9=ignored
| childbirth     | PARTO         | Type of birth: 1=natural childbirth, 2=C-section, 9=ignored
| childbirth.time | OBITOPARTO   | Timing of death in relation to childbirth: 1=before, 2=during, 3=after, 9=ignored
| weight         | PESO          | Weight at birth, in grams
| birth.cert.id  | NUMERODN      | Number of the birth certificate
| pregnancy.death | OBITOGRAV    | Death occured during pregnancy: 1=yes, 2=no, 9=ignored
| puerperium.death | OBITOPUERP  | Death occured during puerperium: 1=yes, less than 42 days; 2=yes, between 43 days and 1 year; 3=no; 9=ignored
| med.assist     | ASSISTMED     | Received medical assistance: 1=yes, 2=no, 9=ignored
| comp.exams     | EXAME         | Complimentary exams were performed: 1=yes, 2=no, 9=ignored
| surgery        | CIRURGIA      | Surgery was done: 1=yes, 2=no, 9=ignored
| necropsy       | NECROPSIA     | Necropsy was done: 1=yes, 2=no, 9=ignored
| line.a         | LINHAA        | Line A of the death certificate, according to ICD-10
| line.b         | LINHAB        | Line B of the death certificate, according to ICD-10
| line.c         | LINHAC        | Line C of the death certificate, according to ICD-10
| line.d         | LINHAD        | Line D of the death certificate, according to ICD-10
| line.II        | LINHAII       | Line II of the death certificate, according to ICD-10
| cause.of.death | CAUSABAS      | Main cause of death, according to ICD-10
| death.cert.dt  | DTATESTADO    | Date of the death certificate
| accident.type  | CIRCOBITO     | Type of accident (if applicable): 1=accident, 2=suicide, 3=homicide, 4=others, 5=ignored
| work.accident  | ACIDTRAB      | 1=yes, 2=no, 9=ignored
| source         | FONTE         | Source of information: 1=Police report, 2=Hospital, 3=Family, 4=others
| investigated   | TPPOS         | Death was investigated: 1=yes, 2=no
| investig.date  | DTINVESTIG    | Date of investigation
| orig.cause     | CAUSABAS_O    | Original main cause of death (first report)
| input.date     | DTCADASTRO    | Date of the record input into the system
| cert.officer   | ATESTANTE     | Certifying officer: 1=medic, 2=substitute medic, 3=IML, 4=SVO, 5=others
| investig.src   | FONTEINV      | Source of investigation: 1=Maternal Death Committee, 2=home visit/family interview, 3=Health facility/medical records, 4=Database research, 5=SVO, 6=IML, 7=other source, 8=multiple sources, 9=ignored.
| receipt.date   | DTRECEBIM     | Date of the last update of the record
| inst.code      | CODINST       | Registration facility id

**Note:** Fields from `age.mother` through `birth.cert.id` only filled when fetal death or < than 1 year old.

## References

1. https://en.wikipedia.org/wiki/Pardo_Brazilians
2. ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DOCS/Estrutura_SIM_para_CD.pdf
