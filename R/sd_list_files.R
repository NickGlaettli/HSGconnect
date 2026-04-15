#' Get list of files and folder on SwitchDrive
#'
#' @description
#' Use this function to get a list all the files and folders within a certain path.
#'
#'
#' @param path Set path of folder the contents should be extracted from.
#' If none is provided, the function will return the contents of root.
#' Only set path from root, full url will be provided by the function.
#'
#' @returns Vector of files and folders contained within the set path.
#' Folders are indicated with a "/" at the end of the string.
#' @export
#'
#' @examples
#' #Get root list
#' sd_list_files()
#'
#' #list of all working files of SSEE
#' sd_list_files("BFS Daten/02 SSEE Studenten/01 Arbeitsdaten")
#'
sd_list_files <- function(path = "") {

  connection <- sd_get_connection()

  # Ensure trailing slash
  if (nchar(path) > 0 && !endsWith(path, "/")) {
    path <- paste0(path, "/")
  }

  # Encode spaces for URL
  path_encoded <- gsub(" ", "%20", path)

  url <- paste0(connection$url, path_encoded)

  response <- httr::VERB(
    "PROPFIND",
    url,
    httr::authenticate(connection$username, connection$password)
  )

  if (httr::status_code(response) != 207) {
    stop("Could not list '", path, "'. HTTP status: ", httr::status_code(response))
  }

  # Parse XML response
  xml <- xml2::read_xml(httr::content(response, as = "text", encoding = "UTF-8"))
  ns <- c(d = "DAV:")

  hrefs <- xml2::xml_text(xml2::xml_find_all(xml, ".//d:response/d:href", ns))
  hrefs <- utils::URLdecode(hrefs)

  # Build prefix to strip
  encoded_user <- utils::URLencode(connection$username, repeated = TRUE)
  prefix <- paste0("/remote.php/dav/files/", utils::URLdecode(encoded_user), "/", path)

  # Remove prefix, keep relative paths
  items <- sub(prefix, "", hrefs, fixed = TRUE)

  # Remove empty string (the queried folder itself)
  items <- items[items != ""]

  if (length(items) == 0) {
    message("Folder '", path, "' is empty.")
  }

  items
}

