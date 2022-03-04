#' Create SQL identifiers
#'
#' @description
#' A simple wrapper around [DBI::dbQuoteIdentifier()], see its documentation for
#' more information.
#'
#' @param name A string, [DBI::SQL()] or [DBI::Id()] object to quote as an
#'   identifier.
#' @param parse boolean; whether to attempt to parse `name` into constituent
#'   parts. Only used if `name` is a character string.
#'
#' @details
#' If `name` is an SQL string, it will be validated. If it fails the validation,
#' the function will throw an error.
#'
#' If `name` is a character string and `parse = TRUE`, then the function will
#' attempt to parse it into constituent parts
#' (`"db.schema.table" -> "db"."schema"."table"`). It will also be validated.
#'
#' @returns A [DBI::SQL()] string properly identifying the desired object
#'
#' @export
sql_identifier <- function(name, parse = FALSE) {
  FUN <- switch(class(name),
                character = .sql_identifier_char,
                Id        = .sql_identifier_Id,
                SQL       = .sql_identifier_sql,
                stop(paste("SQL identifiers must be of type character,\n",
                           "DBI::Id or DBI::SQL")))

  return(FUN(name, parse))
}

#' @importFrom DBI dbQuoteIdentifier
.sql_identifier_Id <- function(name, parse) {
  return(DBI::dbQuoteIdentifier(.get_connection(), name))
}

#' @importFrom DBI dbQuoteIdentifier
.sql_identifier_char <- function(name, parse) {
  .con <- .get_connection()

  if (parse) return(.sql_identifier_sql(DBI::SQL(name), parse, .con))
  else       return(DBI::dbQuoteIdentifier(.con, name))
}

#' @importFrom DBI dbUnquoteIdentifier
.sql_identifier_sql <- function(name, parse, .con) {
  # validate that the object can be properly parsed, will error out if not
  DBI::dbUnquoteIdentifier(.get_connection(), name)

  return(name)
}
