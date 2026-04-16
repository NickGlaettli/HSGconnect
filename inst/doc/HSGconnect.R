## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
# library(HSGconnect)
# 
# sd_setup()
# #> Enter your Switchdrive username (email): max.mustermann@unisg.ch
# #> Enter your app password: ****
# #> Credentials saved to .Renviron.

## -----------------------------------------------------------------------------
# library(HSGconnect)
# 
# sd_connect()
# #> Successfully connected to Switchdrive as nick.glaettli@unisg.ch

## -----------------------------------------------------------------------------
# # List the root directory ("Alle Dateien")
# sd_list_files()
# #> [1] "BFS Daten/"  "Projekte/"  "readme.txt"
# 
# # List a specific folder
# sd_list_files("BFS Daten")
# #> [1] "01 EHA Absolventen/"    "02 SSEE Studenten/"
# #> [3] "03 Verträge/"           "04 Importinformationen/"
# 
# # Go deeper
# sd_list_files("BFS Daten/01 EHA Absolventen/01 Arbeitsdaten")
# #> [1] "eb_2023_hsg.sav"  "eb_2023_all.sav"  "zb_2023_hsg.sav"

## -----------------------------------------------------------------------------
# # EHA Erstbefragung 2023, HSG only (default)
# eha <- read_BFS_data()
# #> Reading eb_2023_hsg.sav...
# #> Import successful: 1245 rows, 187 columns.
# 
# # EHA Zweitbefragung 2023, all universities
# eha_all <- read_BFS_data(first_wave = FALSE, HSG_only = FALSE)
# #> Reading zb_2023_all.sav...
# #> Import successful: 38210 rows, 192 columns.
# 
# # SSEE 2024, HSG only
# ssee <- read_BFS_data(survey = "SSEE", year = 2024)
# #> Reading ssee_2024_hsg.sav...
# #> Import successful: 2310 rows, 95 columns.
# 
# # EHA by cohort year (adds 1 to get the survey year)
# eha_cohort <- read_BFS_data(year = 2022, cohort = TRUE)
# #> Reading eb_2023_hsg.sav...
# #> Import successful: 1245 rows, 187 columns.

## -----------------------------------------------------------------------------
# # Read an SPSS file
# df <- read_sd("Projekte/survey_results.sav")
# 
# # Read a CSV (comma-separated)
# df <- read_sd("Daten/export.csv")
# 
# # Read a CSV with semicolon delimiter (common in Swiss/German data)
# df <- read_sd("Daten/export.csv", delim = "semicol")
# 
# # Read an Excel file, specific sheet
# df <- read_sd("Projekte/report.xlsx", sheet = "Rohdaten")

## -----------------------------------------------------------------------------
# # Full workflow in 4 lines
# library(HSGconnect)
# sd_connect()
# sd_list_files("BFS Daten/01 EHA Absolventen/01 Arbeitsdaten")
# eha <- read_BFS_data(survey = "EHA", year = 2023, HSG_only = TRUE)

