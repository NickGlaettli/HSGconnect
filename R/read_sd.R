#' Import any data files on SwitchDrive
#'
#'@description
#'Function allows to read any data files on SwitchDrive, by using tidyverse import functions.
#'
#'
#' @param path Provide SwitchDrive path to the designated file that needs to be imported.
#' @param delim For csv-files, specify the deliminator. By default "comma", alternatively "semicol".
#' @param ... Pass parameters for tidyverse import functionss
#'
#' @returns Dataframe
#' @export
#'
#'@examples
#'# SAV
#' df <- sd_read("BFS/EHA/EHA_2023_HSG.sav")
#'
# Excel, sepecific sheet
#' df <- sd_read("Projekte/umfrage_2024.xlsx", sheet = "Rohdaten")
#'
# CSV mit semicolon delimination
#' df <- sd_read("Daten/export.csv", delim = "semicol")
#'
# Normal CSV
#' df <- sd_read("Daten/export.csv")
#'
#'
read_sd <- function(path, delim = "comma", ...) {

  #get switchdrive credentials
  connection <- sd_get_connection()

  # Detect file extension
  ext <- tolower(tools::file_ext(path))

  supported <- c("sav", "csv", "xlsx")
  if (!ext %in% supported) {
    stop("Unsupported file format '.", ext, "'. Supported: ",
         paste(supported, collapse = ", "))
  }

  # Download to temp file
  url <- paste0(connection$url, path)
  tmp <- tempfile(fileext = paste0(".", ext))
  on.exit(unlink(tmp), add = TRUE)

  response <- httr::GET(
    url,
    httr::authenticate(connection$username, connection$password),
    httr::write_disk(tmp, overwrite = TRUE)
  )

  if (httr::status_code(response) != 200) {
    stop("Download failed for '", path, "'. HTTP status: ",
         httr::status_code(response))
  }

  if(ext == "csv"){

    if(!delim %in% c("comma", "semicol")){

      stop('Deliminator not supported. Please use "comma" or "semicol".')

    }

    if(delim == "semicol"){

      ext <- "csv2"

    }

  }

  # Read with appropriate function
  df <- switch(ext,
               sav  = haven::read_sav(tmp, ...),
               csv  = readr::read_csv(tmp, ...),
               csv2 = readr::read_csv2(tmp, ...),
               xlsx = readxl::read_excel(tmp, ...)
  )

  message("Import successful: ", nrow(df), " rows, ", ncol(df), " columns.")
  invisible(df)
}
