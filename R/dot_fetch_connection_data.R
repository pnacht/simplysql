.fetch_connection_data <- function(alias, package_id) {
  full_alias <- paste0(package_id, alias)

  keys <- .fetch_connection_keys(alias, package_id)

  if (is.null(keys)) {
    return(NULL)  # user aborted
  }

  args <- sapply(keys, keyring::key_get,
                 service = full_alias,
                 simplify = FALSE)

  args <- .set_connection_data_type(args)

  args$drv <- eval(args$drv)

  return(args)
}

.set_connection_data_type <- function(args) {
  # set type
  convert <- function(value, type) {
    switch(type,
           double   = as.double(value),
           integer  = as.integer(value),
           language = str2lang(value),
           logical  = as.logical(value),
           numeric  = as.numeric(value),
           value)
  }

  names <- names(args)
  regex <- stringr::str_match(args, "^([^_]*)_(.*)$")
  args  <- mapply(convert,
                  value = regex[, 3],
                  type  = regex[, 2])
  names(args) <- names

  return(args)
}
