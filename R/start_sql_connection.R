#' Start up the desired SQL connection
#'
#' @description This function sets up the desired SQL connection if it has
#' been identified in the past. If not, then the connection is defined
#' interactively and set up accordingly.
#'
#' @param alias string identifying the desired SQL connection
#'
#' @details
#' This must be the first `simplysql` function called, since it sets up the
#' connection to be used everywhere else.
#'
#' The `pool::pool` object responsible for handling the connection is
#' automatically registered to disconnect when the session is terminated.
#'
#' @returns On success, a `pool::pool` object representing the desired
#' connection.
#'
#' If the connection did not exist and the user cancels the setup, returns
#' `NULL` invisibly.
#'
#' @family connection management functions
#' @importFrom keyring key_get
#' @export
start_sql_connection <- function(alias) {
  package_id <- "r___simplysql___"

  args <- .fetch_connection_data(alias, package_id)

  if (is.null(args)) {
    return(invisible(NULL))  # user aborted connection setup
  }

  connection_pool <- do.call(pool::dbPool, args)

  reg.finalizer(connection_pool, pool::poolClose, onexit = TRUE)

  return(connection_pool)
}
