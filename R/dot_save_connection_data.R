.save_connection_data <- function(alias, package_id, args) {
  alias <- paste0(package_id, alias)

  # save all the necessary arguments
  mapply(function(arg, name) {
    keyring::key_set_with_value(alias, name, arg)
  }, args, names(args))
}
