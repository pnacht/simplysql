#' Create and store a new SQL connection non-interactively
#'
#' This function allows for the non-interactive definition of an SQL connection.
#' It'll likely be more common to define connections interactively via
#' `start_sql_connection`.
#'
#' @inheritParams start_sql_connection
#' @inheritParams DBI::dbConnect
#' @inheritDotParams DBI::dbConnect
#'
#' @details
#' A call to this function should be identical to the equivalent
#' `DBI::dbConnect()` call, only with an additional `alias` argument.
#'
#' Arguments are securely saved to the system's credential store. Type
#' information is also saved, ensuring that the resulting call is identical to
#' the equivalent `DBI::dbConnect()` call.
#'
#' All arguments must be named and must include argument `drv`. `drv`'s value
#' must be fully namespaced (i.e. `odbc::odbc()`, not `odbc()`).
#'
#' @returns `NULL`, invisibly.
#'
#' @family connection management functions
#'
#' @importFrom glue glue
#' @importFrom keyring key_set_with_value
#'
#' @export
create_sql_connection <- function(alias, drv, ...) {
  args <- list(drv = drv, ...)

  .save_connection_data(alias, args)

  return(invisible(NULL))
}
