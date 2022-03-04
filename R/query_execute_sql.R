#' Run parametric SQL statements and queries
#'
#' @inheritParams write_sql
#' @inheritDotParams write_sql
#' @param .verbose Whether to display the resulting SQL call, useful during
#'   development.
#'
#' @details
#' See [write_sql()] to see how `...` parameters must be defined.
#'
#' These functions are basically simple wrappers around [DBI::dbExecute()] and
#' [DBI::dbGetQuery()] and as such serve equivalent purposes:
#'
#' - `execute_sql()` is meant for statements which modify the database
#' (`UPDATE`, `DELETE`, `DROP TABLE`, etc)
#' - `query_sql()` is meant for `SELECT` queries.
#'
#' @return For `query_sql`, the output of the SQL query as a `data.frame`.
#'
#' For `execute_sql`, the number of rows modified by the statement.
#'
#' @family SQL expressions
#'
#' @examples
#' \dontrun{
#' bar <- 1
#' get_query("
#'   SELECT *
#'   From Foo
#'   WHERE a = {bar}")
#' # output of "SELECT * From Foo WHERE a = 1"
#' }
#'
#' @rdname sql-statements
#'
#' @importFrom DBI dbGetQuery
#' @export
query_sql <- function(.sql,
                      ...,
                      .envir = parent.frame(),
                      .verbose = FALSE) {
  df <- .run_sql_statement(DBI::dbGetQuery,
                           .sql,
                           ...,
                           .envir = .envir,
                           .verbose = .verbose)

  return(df)
}

#' @rdname sql-statements
execute_sql <- function(.sql,
                        ...,
                        .envir = parent.frame(),
                        .verbose = FALSE) {
  nrows <- .run_sql_statement(DBI::dbExecute,
                              .sql,
                              ...,
                              .envir = .envir,
                              .verbose = .verbose)

  return(nrows)
}
