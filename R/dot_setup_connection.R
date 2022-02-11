.setup_connection <- function(alias, package_id) {
  message(paste(alias, "is not a recognized database connection."))
  message("Setting it up...")

  args <- .parse_connection_args()

  if (!.confirm_connection_args(args)) {
    return(FALSE)
  }

  .save_connection_data(alias, package_id, args)

  return(TRUE)
}
