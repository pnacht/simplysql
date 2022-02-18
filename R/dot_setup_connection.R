.setup_connection <- function(alias, package_id) {
  message(paste(alias, "is not a recognized database connection."))
  message("Setting it up...")

  args <- .read_connection_expr()
  args <- .parse_connection_args(args)

  .save_connection_data(alias, package_id, args)

  return(TRUE)
}
