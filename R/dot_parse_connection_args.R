.parse_connection_args <- function(expr) {
  if (!identical(rlang::call_fn(expr), DBI::dbConnect)) {
    stop("The input must be a simple call to `DBI::dbConnect`.")
  }

  args <- rlang::call_args(expr)

  if (any(names(args) == "")) {
    stop("All arguments given in the `DBI::dbConnect` call must be named.")
  }

  return(args)
}
