#' @importFrom rlang call_args
.setup_connection <- function(alias, package_id) {
  message(paste(alias, "is not a recognized database connection."))
  message("Setting it up...")

  expr <- .read_connection_expr()
  .validate_connection_call(expr)

  args <- rlang::call_args(expr)
  .validate_connection_args(args)

  .save_connection_data(alias, package_id, args)

  return(TRUE)
}
