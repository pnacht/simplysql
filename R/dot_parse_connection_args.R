.parse_connection_args <- function(expr) {
  args <- rlang::call_args(expr)

  return(args)
}
