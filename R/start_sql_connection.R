#' Start up the desired SQL connection
#'
#' @description This function sets up the desired SQL connection if it has
#' been identified in the past. If not, then the connection is defined
#' interactively and set up accordingly.
#'
#' @param alias string identifying the desired SQL connection.
#'
#' @details
#' This must be the first `simplysql` function called, since it sets up the
#' connection to be used everywhere else.
#'
#' If the desired connection doesn't yet exist, it is created interactively,
#' with the user entering a valid `DBI::dbConnect()` call to generate the
#' desired connection.
#'
#' This unusual interaction is meant to make debugging the connection easier.
#' The suggested workflow when making your first connection is as follows:
#'
#' \itemize{
#'   \item if you already have a `DBI::dbConnect()` call, simply copy-and-paste
#'     it at the prompt and you're done.
#'   \item if you've never connected to this database before, it'll be best to
#'     validate your connection parameters with a simple `DBI::dbConnect()` call
#'     first to make sure everything's right. This removes sources of
#'     uncertainty in case anything goes wrong. Once you've managed to create a
#'     valid connection, just copy that call and paste it at the prompt.
#' }
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
#'
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

  options(
    simplysql.default_connection_pool = connection_pool
  )

  return(connection_pool)
}
