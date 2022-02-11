.save_connection_data <- function(alias, package_id, args) {
  alias <- paste0(package_id, alias)

  # save a "csv" with all the argument names needed to define the connection
  keyring::key_set_with_value(alias, "args",
                              paste(names(args), collapse = ","))

  # save all the necessary arguments
  mapply(function(arg, name) {
    keyring::key_set_with_value(alias, name, arg)
  }, args, names(args))
}
