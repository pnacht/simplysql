.confirm_connection_args <- function(args) {
  # args will be wrapped in quotes, extract `drv` to be handled separately
  drv <- args$drv
  args$drv <- NULL

  args <- paste0(glue::glue("{names(args)} = '{args}'"), collapse = ",\n  ")

  str <- glue::glue("
    DBI::dbConnect(
      drv = {drv},
      {args}
    )")

  message("The arguments given would be equivalent to the connection below:")
  message(str)

  while (TRUE) {
    answer <- tolower(readline("Are the arguments correct? [y/n] "))

    if (answer %in% c("y", "n")) {
      break
    }
  }

  success <- answer == "y"

  if (!success) message("Setup aborted.")

  return(success)
}
