#' Perform SQL operations within a transaction
#'
#' @description
#' A transaction allows SQL operations to be batched, such that either all
#' operations are applied or none are. In the jargon, the entire transaction is
#' either committed or rolled back. This is useful to ensure database
#' consistency, without the risk of partial changes caused by unexpected errors
#' in the middle of an operation.
#'
#' @param fun A function which contains all desired SQL operations
#' @param ... Arguments passed to `fun()`
#'
#' @details
#' `transact_sql()` calls `fun()` within a transaction. There are three possible
#' outcomes:
#'
#'  - if the function returns successfully, then the transaction is committed;
#'  - if an error is thrown, then the transaction is rolled back and the error
#'    is propagated so that it may be handled elsewhere;
#'  - if `break_sql()` is called withn `fun()`, then `fun()` is interrupted and
#'    the transaction is rolled back, but no error is thrown and the program may
#'    proceed as normal.
#'
#' If `break_sql()` is called outside of a function passed to `transact_sql()`,
#' it will throw an error.
#'
#' @returns Returns the value returned by `fun()`, or `NULL` if `break_sql()`
#' was called.
#'
#' @importFrom DBI dbBegin dbCommit dbRollback
#' @export
transact_sql <- function(fun, ...) {
  .con <- .checkout_transaction_connection()

  DBI::dbBegin(.con)

  commit <- TRUE
  x <- tryCatch(
    fun(...),
    error = function(e) {
      DBI::dbRollback(.con)
      stop(e)
    },
    dbi_abort = function(e) {
      DBI::dbRollback(.con)
      commit <<- FALSE
      return(NULL)
    }
  )

  if (commit) DBI::dbCommit(.con)

  return(x)
}

#' @rdname transact_sql
#' @importFrom DBI dbBreak
#'
#' @export
break_sql <- function() DBI::dbBreak()

#' @importFrom pool poolCheckout poolReturn
#' @importFrom withr defer_parent
.checkout_transaction_connection <- function() {
  .con <- .get_connection()
  .con <- pool::poolCheckout(.con)

  options(
    "simplysql.transaction_connection" = .con
  )

  withr::defer_parent({
    pool::poolReturn(.con)
    options(
      "simplysql.transaction_connection" = NULL
    )
  })

  return(.con)
}
