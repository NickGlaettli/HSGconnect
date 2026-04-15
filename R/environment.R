.sd_env <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  .sd_env$con <- NULL
}
