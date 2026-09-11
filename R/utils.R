#internal helper to raise informative errors for failed SwitchDrive requests
#context describes the failed operation, e.g. "Download failed for 'eb_2023_hsg.sav'"
sd_stop_http <- function(status, context, url = NULL) {

  msg <- paste0(context, ". HTTP status: ", status)

  if (!is.null(url)) {
    msg <- paste0(msg, "\nTried URL: ", url)
  }

  hint <- switch(
    as.character(status),

    "401" = paste0(
      "SwitchDrive rejected the credentials (username or password incorrect).\n",
      "Usually the stored app password is no longer valid: SwitchDrive revokes\n",
      "app passwords whenever the edu-ID account password is changed.\n",
      "  1. Create a new app password at ",
      "https://drive.switch.ch/settings/user/security\n",
      "  2. Run sd_setup() and enter your username and the new app password.\n",
      "  3. Restart R so that .Renviron is read again.\n",
      "Note: the regular edu-ID password does not work over WebDAV, ",
      "an app password is required."),

    "403" = paste0(
      "The account is authenticated but not allowed to access this resource.\n",
      "Check whether the folder has been shared with you."),

    "404" = paste0(
      "The file or folder does not exist at this location.\n",
      "Use sd_list_files() to see which files and folders are available."),

    "423" = paste0(
      "The resource is locked on SwitchDrive.\n",
      "Close the file in other applications and try again."),

    NULL
  )

  if (!is.null(hint)) {
    msg <- paste0(msg, "\n\n", hint)
  }

  stop(msg, call. = FALSE)
}
