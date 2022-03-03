.run_sql_statement <- function(.dbi_fun,
                               .sql,
                               ...,
                               .envir = parent.frame(),
                               .verbose = FALSE) {
  .sql <- write_sql(.sql, ..., .envir = .envir)

  if (.verbose) message(.sql)

  return(.dbi_fun(.get_connection(), .sql))
}
