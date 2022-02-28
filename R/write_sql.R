#' Create a safe SQL expression via parametric string interpolation
#'
#' @param .sql string containing the parametric SQL expression.
#' @param .envir environment in which to lookup parametric values not found in
#'   `...`. By default, looks at the current calling environment.
#' @param  .con the SQL connection to use to define the necessary SQL-escaping.
#'   If `NULL`, uses the connection defined by calling [start_sql_connection()].
#' @inheritDotParams glue::glue_data_sql
#' @inheritDotParams glue::glue_data -.sep -.transformer
#'
#' @details
#' Handles all parametric strings, protecting against SQL injection.
#'
#' By default, parameters in the statement must be given names wrapped in curly
#' brackets. For example:
#'
#' ```
#' UPDATE Foo
#' SET Bar = {bar}
#' ```
#'
#' will replace `{bar}` with its associated value (see below). If that
#' value is a list which should be expanded into a comma-separated list (for
#' example, within an `IN (...)` block), add as asterisk to the name within the
#' curly brackets (`{bar*}`). If the variable defines an SQL identifier (such as
#' a table name), wrap it in backticks (``{`bar`}``)
#'
#' The value associated with each parameter can be defined in a few ways:
#'
#' - Have a variable in your calling frame with the same name as the parameter.
#'   `write_sql()` will search `.envir` (usually the calling frame) for variables
#'   with those names and use them to replace the parameters.
#' - Pass a named argument within `...` with the same name as the parameter.
#'   This is useful in cases where a few desired values are within a list or
#'   data.frame.
#' - Pass a listish object (list, data.frame or environment) to `.x` containing
#'   values with the same name as the statement parameter.
#'
#' Parameters will be searched for following the hierarchy below:
#'
#' 2. if `write_sql()` was called with a named argument matching the parameter,
#'    that value is chosen.
#' 1. otherwise, if `.x` was defined and contains an element (data.frame column,
#'    list element or environment name) matching the parameter, that value is
#'    chosen.
#' 3. otherwise, if the environment passed to `.envir` contains a variable
#'    matching the parameter, that value is chosen. However, if `.x` is an
#'    environment, then `.envir` is ignored.
#' 4. if no matches are found, an error is thrown.
#'
#' You'll likely never have to define `.envir`, unless creating wrappers of your
#' own, in which case you'll probably want to pass the wrapper's
#' [`parent.frame()`][base::parent.frame()].
#'
#' @note
#' Unlike `glue::glue*()` functions used under the hood, `write_sql` does not
#' perform string concatenation.
#'
#' While the `glue` package allows unnamed arguments to be passed to `...` and
#' simply concatenates them to generate the query, `write_sql` expects the query
#' to be fully defined within the `sql` argument.
#'
#' This is done as further protection from SQL injection, to impede the
#' accidental inclusion of user-input directly into the query string.
#'
#' Therefore, the function will throw an error if any unnamed arguments are
#' passed to `...`.
#'
#' If the query must be concatenated by different strings, simply declare them
#' to be safe SQL via `DBI::SQL()`, and then define the `sql` argument to
#' insert those SQL strings as necessary. See Examples below.
#'
#' @return A safe SQL string, with all parametric values properly handled
#' against SQL injection.
#'
#' @family SQL functions
#'
#' @seealso [glue::glue_data_sql()] and [glue::glue_data()], whose arguments
#' also apply to `glue::glue_data_sql()`.
#'
#' @examples
#' \dontrun{
#' bar <- 1
#' write_sql("UPDATE Foo SET Bar = { bar }")
#' #> <SQL> UPDATE Foo SET Bar = 1
#'
#' write_sql("UPDATE Foo SET Bar = { bar }",
#'           bar = 1)
#' #> <SQL> UPDATE Foo SET Bar = 1
#'
#' bar <- list(new = 1, old = 2)
#' write_sql("UPDATE Foo SET Bar = { new } WHERE Bar = { old }",
#'           .x = bar)
#' #> <SQL> UPDATE Foo SET Bar = 1 WHERE Bar = 2
#'
#' bar <- c(1, 2, 3)
#' write_sql("SELECT * From Foo WHERE Bar IN ({ bar* })")
#' #> <SQL> SELECT * From Foo WHERE Bar IN (1, 2, 3)
#'
#' # Properly quotes string parameters to avoid SQL injection
#' write_sql("SELECT * FROM Foo WHERE Bar = { bar }",
#'           bar = "buzz; DROP TABLE Foo;")
#' #> <SQL> SELECT * FROM Foo WHERE Bar = 'Buzz; DROP TABLE Foo;'
#' }
#'
#' @importFrom glue glue_data_sql
#' @export
write_sql <- function(.sql,
                      ...,
                      .envir = parent.frame(),
                      .con = NULL) {
  if (is.null(.con)) .con <- .get_default_connection_pool()

  dots <- list(...)

  names <- names(dots)

  if (any(names == "")) {
    stop("All arguments passed to `...` must be named.")
  }

  # glue_data_sql() requires a .x argument. In case the user didn't declare one,
  # set it to NULL
  if (!any(names == ".x")) dots[".x"] <- list(NULL)

  .sql <- do.call(glue::glue_data_sql, c(.sql,
                                         dots,
                                         .con = .con,
                                         .envir = .envir))

  return(.sql)
}
