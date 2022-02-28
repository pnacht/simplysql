#' @importFrom glue glue
#' @importFrom keyring key_set_with_value
.save_connection_data <- function(alias, package_id, args) {
  alias <- paste0(package_id, alias)

  save_arg <- function(key, value) {
    type  <- typeof(value)

    if (type == "language") value <- deparse(value)

    value <- glue::glue("{type}_{value}")
    key   <- glue::glue("{key}")

    keyring::key_set_with_value(
      service  = alias,
      username = key,
      password = value
    )
  }

  mapply(save_arg,
         key   = names(args),
         value = args)

  return(invisible(NULL))
}
