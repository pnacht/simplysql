#' @importFrom assertthat assert_that
.get_default_connection_pool <- function() {
  pool <- getOption("simplysql.default_connection_pool")

  assertthat::assert_that(
    !is.null(pool),
    paste0("SQL connection has not been initialized. Call",
           "`start_sql_connection()` before attempting any SQL expressions.",
           sep = "\n  ")
  )

  return(pool)
}
