delete_sql_connection <- function(alias) {
  sep        <- "___"
  package_id <- "r___simplysql___"

  full_alias <- paste0(package_id, alias)

  keys <- keyring::key_list(full_alias)$username

  if (length(keys) == 0) {
    stop("Given alias is not a known connection")
  }

  sapply(keys, function(x) keyring::key_delete(full_alias, x))

  return(invisible(NULL))
}
