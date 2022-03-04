conn <- setup_connection()

test_that("Tableless queries work", {
  expect_equal(
    query_sql("SELECT 1 AS x")
    , data.frame(x = 1))
})

test_that("Standard queries work", {
  DBI::dbWriteTable(conn, "iris", iris)

  expect_equal(
    query_sql("
      SELECT Species
      FROM iris
      LIMIT 1"),
    data.frame(Species = "setosa")
  )
})
