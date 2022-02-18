.read_connection_expr <- function() {
  message("Paste a call to `DBI::dbConnect()` which creates a valid connection")
  message("to the server.")

  str  <- ""
  expr <- NULL
  while(is.null(expr)) {
    line <- readline()
    str  <- paste0(str, line, sep = "\n")

    expr <- tryCatch(
      str2lang(str),
      error = function(e) NULL
    )
  }

  return(expr)
}
