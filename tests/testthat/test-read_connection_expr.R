mock_input <- function(x) {
  m <- do.call(mockery::mock, x)

  mockery::stub(.read_connection_expr, "readline", m)

  return(suppressMessages(.read_connection_expr()))
}

test_that("Valid calls with all named arguments are accepted", {
  input <- list(
    "DBI::dbConnect(",
    "drv    = RSQLite::SQLite(),",
    "dbname = \":memory:\")"
  )

  expect_identical(mock_input(input), quote(
    DBI::dbConnect(
      drv    = RSQLite::SQLite(),
      dbname = ":memory:")
  ))
})

test_that("Invalid calls or expressions fail", {
  input <- list(  # no closing parenthesis
    "DBI::dbConnect(",
    "drv    = RSQLite::SQLite(),",
    "dbname = \":memory:\""
  )

  expect_error(mock_input(input))

  input <- list(  # expression, not simple call
    "DBI::dbConnect(",
    "drv      = RSQLite::SQLite(),",
    "Driver   = \"SQL Server\",",
    "dbname = \":memory:\"); { print(1) }"
  )

  expect_error(mock_input(input))
})
