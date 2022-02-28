conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

test_that("Tableless queries work", {
  expect_equal(
    query_sql("SELECT 1 AS x", .con = conn)
    , data.frame(x = 1))
})

test_that("Standard queries work", {
  DBI::dbWriteTable(conn, "iris", iris)

  expect_equal(
    query_sql("
      SELECT Species
      FROM iris
      LIMIT 1", .con = conn),
    data.frame(Species = "setosa")
  )
})

DBI::dbDisconnect(conn)
