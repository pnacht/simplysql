#' Operate on SQL tables
#'
#' @description
#' These functions simply wrap DBI functions to use the standard connection
#' defined in [start_sql_connection()].
#'
#' - `create_sql_table()` wraps [DBI::dbCreateTable()]
#' - `drop_sql_table()` wraps [DBI::dbRemoveTable()]
#' - `read_sql_table()` wraps [DBI::dbReadTable()]
#' - `write_sql_table()` wraps [DBI::dbWriteTable()]
#' - `append_sql_table()` wraps [DBI::dbAppendTable()]
#'
#' @inheritParams DBI::dbCreateTable
#' @inheritParams DBI::dbWriteTable
#'
#' @details
#' See the `DBI` documentation for further information on each function.
#'
#' `name` will be simply interpreted by [sql_identifier()]. If it is a character
#' string containing a fully qualified name (i.e. `my_schema.my_table`), call
#' `sql_identifier()` yourself and set `parse = TRUE`.
#'
#' `write_` and `append_sql_table()` have the `value` argument come first,
#' before `name`. This is an intentional change from their respective DBI
#' functions, so as to facilitate their use with pipes.
#'
#' @rdname table-operations
#'
#' @importFrom DBI dbCreateTable
#' @export
create_sql_table <- function(name, fields, ...,
                             temporary = FALSE) {
  name <- sql_identifier(name)
  DBI::dbCreateTable(.get_connection(), name, fields, ...,
                     temporary = temporary)
}

#' @rdname table-operations
#'
#' @importFrom DBI dbRemoveTable
#' @export
drop_sql_table <- function(name, ...) {
  name <- sql_identifier(name)
  DBI::dbRemoveTable(.get_connection(), name, ...)
}

#' @rdname table-operations
#'
#' @importFrom DBI dbReadTable
#' @export
read_sql_table <- function(name, ...) {
  name <- sql_identifier(name)
  DBI::dbReadTable(.get_connection(), name, ...)
}

#' @rdname table-operations
#'
#' @importFrom DBI dbWriteTable
#' @export
write_sql_table <- function(value, name, ...) {
  name <- sql_identifier(name)
  DBI::dbWriteTable(.get_connection(), name, value, ...)
}

#' @rdname table-operations
#'
#' @importFrom DBI dbAppendTable
#' @export
append_sql_table <- function(value, name, ...) {
  name <- sql_identifier(name)
  DBI::dbAppendTable(.get_connection(), name, value, ...)
}
