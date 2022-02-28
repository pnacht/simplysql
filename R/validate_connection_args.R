#' @importFrom assertthat assert_that
#' @importFrom DBI dbConnect dbDisconnect
#' @importFrom glue glue
#' @importFrom rlang is_call_simple
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

  # see if DBI::dbConnect successfully creates a connection with the given
  # arguments.
  conn <- tryCatch(
    do.call(DBI::dbConnect, args),
    error = function(e) {
      arg_str = paste(
        glue::glue("      { names(args) } = { args }"),
        collapse = ",\n"
      )
      stop(paste(
        sep = "\n",
        "Failed to establish a connection with given arguments. Please confirm",
        "the following expression can create the desired connection:",
        "  DBI::dbConnect(",
        arg_str,
        "  )"))
    })
  DBI::dbDisconnect(conn)
}
