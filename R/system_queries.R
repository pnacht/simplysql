#' Obtain structural data on the database
#'
#' These functions simply wrap DBI functions to use the standard connection
#' defined in [start_sql_connection()].
#'
#' - `exists_sql_table()` wraps [DBI::dbExistsTable()]
#' - `list_sql_tables()` wraps [DBI::dbListTables()]
#' - `list_sql_table_fields()` wraps [DBI::dbListFields()]
#' - `list_sql_objects()` wraps [DBI::dbListObjects()]
#'
#' @inheritParams DBI::dbListObjects
#'
#' @details
#' See the `DBI` documentation for further information on each function.
#'
#' `name` will be simply interpreted by [sql_identifier()]. If it is a character
#' string containing a fully qualified name (i.e. `my_schema.my_table`), call
#' `sql_identifier()` yourself and set `parse = TRUE`.
#'
#'
#' @rdname system-queries
#'
#' @importFrom DBI dbExistsTable
#' @export
exists_sql_table <- function(name, ...) {
  name <- sql_identifier(name)
  DBI::dbExistsTable(.get_connection(), name, ...)
}

#' @rdname system-queries
#'
#' @importFrom DBI dbListTables
#' @export
list_sql_tables <- function(...) {
  DBI::dbListTables(.get_connection(), ...)
}

#' @rdname system-queries
#'
#' @importFrom DBI dbListFields
#' @export
list_sql_table_fields <- function(name, ...) {
  name <- sql_identifier(name)
  DBI::dbListFields(.get_connection(), name, ...)
}

#' @rdname system-queries
#'
#' @importFrom DBI dbListObjects
#' @export
list_sql_objects <- function(prefix = NULL, ...) {
  DBI::dbListObjects(.get_connection(), prefix, ...)
}
