#' @importFrom assertthat assert_that
.get_connection <- function() {
  .con <- getOption("simplysql.transaction_connection")

  if (!is.null(.con)) {  # in a transaction, use the same connection
    return(.con)
  }

  .con <- getOption("simplysql.connection_pool")

  assertthat::assert_that(
    !is.null(.con),
    msg = paste0("SQL connection has not been initialized. Call",
           "`start_sql_connection()` before attempting any SQL expressions.",
           sep = "\n  ")
  )

  return(.con)
}
