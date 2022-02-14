#' Delete a known SQL connection
#'
#' @inheritParams start_sql_connection
#'
#' @description
#' Function to delete a known SQL connection from your credential store.
#'
#' If the given alias does not exist, an error is thrown.
#'
#' @family connection management functions
#'
#' @importFrom keyring key_delete key_list
#' @export
delete_sql_connection <- function(alias) {
  package_id <- "r___simplysql___"

  full_alias <- paste0(package_id, alias)

  keys <- keyring::key_list(full_alias)$username

  if (length(keys) == 0) {
    stop("Given alias is not a known connection")
  }

  sapply(keys, function(x) keyring::key_delete(full_alias, x))

  return(invisible(NULL))
}
