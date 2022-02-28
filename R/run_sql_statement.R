.run_sql_statement <- function(.fun,
                               .sql,
                               ...,
                               .envir = parent.frame(),
                               .verbose = FALSE,
                               .con = NULL) {
  if (is.null(.con)) .con <- .get_default_connection_pool()

  .sql <- write_sql(.sql, ..., .envir = .envir, .con = .con)

  if (.verbose) message(.sql)

  return(.fun(.con, .sql))
}
