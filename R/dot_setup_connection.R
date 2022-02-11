.setup_connection <- function(alias) {
  message(paste(alias, "is not a recognized database connection."))
  message("Setting it up...")

  drv <- readline("drv=")

  args <- .parse_connection_args()

  if (!.confirm_connection_args(drv, args)) {
    return(FALSE)
  }

  args <- c(list(drv = parse(text = drv)), args)

  return(args)
}

.parse_connection_args <- function() {
  message("Add all other arguments in key=value form (i.e. `UID=doe`, without")
  message("spaces around the `=`).")
  message("Add an empty line when done.")

  args <- list()
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

.confirm_connection_args <- function(drv, args) {
  args$drv <- NULL

  args <- paste0(glue::glue("{names(args)} = '{args}'"), collapse = ",\n  ")

  str <- glue::glue("
    DBI::dbConnect(
      drv = {drv},
      {z}
    )")

  message("The arguments given would be equivalent to the connection below:")
  message(str)

  while (TRUE) {
    answer <- tolower(readline("Are the arguments correct? [y/n] "))

    if (answer %in% c("y", "n")) {
      break
    }
  }

  return(answer == "y")
}

.save_connection_data <- function() {

}
