#' @importFrom keyring key_list
.fetch_connection_keys <- function(alias, package_id) {
  full_alias <- paste0(package_id, alias)

  fetch_keys <- function(x) keyring::key_list(x)$username

  keys <- fetch_keys(full_alias)

  # if keys don't exist yet, create them
  if (length(keys) == 0) {
    if (!.setup_connection(alias, package_id)) {
      # user aborted setup
      return(NULL)
    }

    keys <- fetch_keys(full_alias)
  }

  return(keys)
}
