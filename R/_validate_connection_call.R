#' @importFrom assertthat assert_that
#' @importFrom DBI dbConnect
#' @importFrom rlang call_fn is_call_simple
.validate_connection_call <- function(expr) {
  assertthat::assert_that(
    rlang::is_call_simple(expr, ns = TRUE),
    msg = "The `DBI::dbConnect` call must be fully namespaced (with the `DBI::` prefix)"
  )

  assertthat::assert_that(
    identical(rlang::call_fn(expr), DBI::dbConnect),
    msg = "The input must be a simple call to `DBI::dbConnect`."
  )
}
