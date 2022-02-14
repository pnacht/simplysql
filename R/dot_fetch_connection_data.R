.fetch_connection_data <- function(alias, package_id) {
  full_alias <- paste0(package_id, alias)

  keys <- .fetch_connection_keys(alias, package_id)

  if (is.null(keys)) {
    return(NULL)  # user aborted
  }

  args <- sapply(keys, function(x) keyring::key_get(full_alias, x),
                 simplify = FALSE)

  # $args is just a list of necessary argument names, no longer necessary
  args$args <- NULL

  # convert $drv to an expression
  args$drv <- eval(parse(text = args$drv))

  return(args)
}
