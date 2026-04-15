#' Connect to SwitchDrive
#'
#' @description
#' This function connects to a SwitchDrive Account and returns all relevant credentials.
#' Credentials are stored, so that connection only has to be established once.
#'
#'
#' @param username Username is taken by default from .Renviron.
#' If no username is available, it can be passed directly in function or use sd_setup() instead.
#' @param password Password is taken by default from .Renviron.
#' If no Password is available, it can be passed directly in function or use sd_setup() instead.
#'
#' @returns
#' List of credentials: Username, Password and Path.
#' @export
#'
#' @examples
#' sd_connect()
sd_connect <- function(
    username = Sys.getenv("SWITCH_USER"),
    password = Sys.getenv("SWITCH_PASSWORD")
) {

  #check username and password
  if (username == "") stop("No username provided. Set SWITCH_USER in .Renviron or pass it directly.")
  if (password == "") stop("No password provided. Set SWITCH_PASSWORD in .Renviron or pass it directly.")

  #encode username, so that it is url compatible
  encoded_username <- utils::URLencode(username, repeated = TRUE)

  #create user WebDAV url
  url <- paste0("https://drive.switch.ch/remote.php/dav/files/", encoded_username, "/")

  response <- httr::VERB(
    "PROPFIND",
    url,
    httr::authenticate(username, password),
    httr::add_headers(Depth = "0")
  )

  #check connection success
  if (httr::status_code(response) != 207) {
    stop(paste("Connection failed. Status code:", httr::status_code(response)))
  }

  #add connection to cache
  .sd_env$con <- structure(
    list(username = username, password = password, url = url),
    class = "sd_connection")

  message("Successfully connected to Switchdrive as ", username)
  invisible(.sd_env$con)

}


#' Helper function to establish connection
#'
#'@description
#'Used as helper function in functions that retrieve SwitchDrive data.
#'
#'
#' @export
#'
sd_get_connection <- function() {
  if (is.null(.sd_env$con)) {
    message("No active connection found. Connecting automatically...")
    sd_connect()
  }
  .sd_env$con
}

