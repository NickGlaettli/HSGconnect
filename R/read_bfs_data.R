#' Get BFS Data from SwitchDrive
#'
#' @description
#' This function retrieves the BFS Data that are stored on SwitchDrive and returns them as a dataframe.
#'
#'
#' @param survey Specify the survey type you wish to load. Can be either "EHA" or "SSEE".
#' @param first_wave For "EHA" survey please specify the survey wave.
#' If TRUE, "Erstbefragung" is used. If FALSE, it will search for "Zweitbefragung".
#' @param year Specify survey year. By default, it is set to 2023.
#' If cohort year is used, set cohort = TRUE. Cohort option is only available for EHA.
#' @param cohort By default FALSE. Set to TRUE if year is the cohort year.
#' @param HSG_only By default TRUE. If TRUE, only respondents affiliated to HSG are returned.
#' If all Swiss universities are to be included, set to FALSE.
#'
#' @returns Function returns dataframe of the specified BFS survey.
#' @export
#'
#' @examples
#'  eha_23_eb_all <- read_BFS_data(HSG_only = FALSE)
#'  ssee_24_hsg <- read_BFS_data(survey = "SSEE", year = 2024)
#'
read_BFS_data <- function(
  survey = "EHA",
  first_wave = T,
  year = 2023,
  cohort = F,
  HSG_only = T){

  #check survey validity
  if(!survey %in% c("EHA", "SSEE")){

    stop("Please provide valid BFS survey: EHA or SSEE")
  }

  #warn about year conflicts
  if(survey == "SSEE" & cohort == T){

    warning("SSEE is not cohort based. File might not be found.")

  }

  #get switchdrive credentials
  connection <- sd_get_connection()

  #set filename
  reference_filter <- ifelse(HSG_only, "_hsg", "_all")
  year_corrected <- ifelse(cohort, year + 1, year)
  survey_wave <- ifelse(first_wave, "eb_", "zb_")

  filename <- ifelse(survey == "EHA",
                     paste0(survey_wave, year_corrected, reference_filter, ".sav"),
                     paste0("ssee_", year_corrected, reference_filter, ".sav"))

  #build webDAV path
  folder <- ifelse(survey == "EHA",
                   "01%20EHA%20Absolventen/",
                   "02%20SSEE%20Studenten/")
  path <- paste0(connection$url,
                 "BFS%20Daten/",
                 folder,
                 "01%20Arbeitsdaten/",
                 filename)

  #request data
  response <- httr::GET(path,
            httr::authenticate(connection$username,
                               connection$password))

  #check if call successful
  if (httr::status_code(response) != 200) {
    stop(
      "Download failed for '", filename, "'. ",
      "HTTP status: ", httr::status_code(response), "\n",
      "Tried URL: ", path
    )
  }

  #creat helper file
  tmp <- tempfile(fileext = ".sav")
  on.exit(unlink(tmp))
  writeBin(httr::content(response, as = "raw"), tmp)

  #reading file
  message("Reading ", filename, "...")

  bfs_data <- haven::read_sav(tmp)

  message("Import successful: ",
          nrow(bfs_data),
          " rows, ",
          ncol(bfs_data),
          " columns.")

  return(bfs_data)


}


