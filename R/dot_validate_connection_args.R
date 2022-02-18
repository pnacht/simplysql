.validate_connection_args <- function(args) {
  names <- names(args)

  assertthat::assert_that(
    !any(names == ""),
    msg = "All arguments given in the `DBI::dbConnect()` call must be named."
  )

  assertthat::assert_that(
    any(names == "drv"),
    msg = "The `DBI::dbConnect() call must include argument `drv`"
  )

  assertthat::assert_that(
    rlang::is_call_simple(args$drv, ns = TRUE),
    msg = paste("The `drv` argument must be fully namespaced",
                "(i.e. `drv = odbc::odbc()`, `drv = RSQLite::SQLite()`, etc)",
                sep = "\n  ")
  )
}
