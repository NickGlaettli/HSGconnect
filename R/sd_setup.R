#' Set SwitchDrive Credentials
#'
#' @description
#' This function allows you to set your credentials of SwitchDrive.
#' Call this function when you have never connected to your SwitchDrive Account via R, to store username and password for all connections.
#' It is advised to set a app-specific password.
#'
#'
#'
#' @export
#'
#' @examples
#' sd_setup()
#'
#'

sd_setup <- function() {
  renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")

  # Read existing content
  if (file.exists(renviron_path)) {
    existing <- readLines(renviron_path)
    has_user <- any(grepl("^SWITCH_USER=", existing))
    has_pass <- any(grepl("^SWITCH_PASSWORD=", existing))

    if (has_user || has_pass) {
      message("Existing Switchdrive credentials found in .Renviron.")
      overwrite <- readline("Do you want to overwrite them? (yes/no): ")

      if (!tolower(overwrite) %in% c("yes", "y")) {
        message("Setup cancelled. Existing credentials kept.")
        return(invisible(NULL))
      }

      existing <- existing[!grepl("^SWITCH_USER=|^SWITCH_PASSWORD=", existing)]
    }
  } else {
    existing <- character(0)
  }

  username <- readline("Enter your Switchdrive username (email): ")
  password <- readline("Enter your app password: ")

  if (username == "" || password == "") {
    stop("Username and password cannot be empty.")
  }

  new_lines <- c(
    existing,
    paste0("SWITCH_USER=", username),
    paste0("SWITCH_PASSWORD=", password)
  )

  writeLines(new_lines, renviron_path)
  message("Credentials saved to .Renviron.")

  if (rstudioapi::isAvailable()) {
    rstudioapi::restartSession()
  } else {
    message("Please restart R manually for the changes to take effect.")
  }
}
