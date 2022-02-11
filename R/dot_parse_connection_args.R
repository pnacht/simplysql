.parse_connection_args <- function() {
  drv <- readline("drv=")

  message("Add all other arguments in key=value form (i.e. `UID=doe`, without")
  message("spaces around the `=`).")
  message("Add an empty line when done.")

  args <- list(drv = drv)
  while (TRUE) {
    arg <- readline()

    if (arg == "") {
      break
    }

    if (!grepl("=", arg)) {
      warning("IGNORED. All arguments must be given in key=value form.",
              call. = FALSE,
              immediate. = TRUE)
      next
    }

    arg <- stringr::str_match(arg, "^(.*?)=(.*)$")
    arg_name  <- arg[2]
    arg_value <- arg[3]

    arg <- list(arg_value)
    names(arg) <- arg_name

    args <- c(args, arg)
  }

  return(args)
}
