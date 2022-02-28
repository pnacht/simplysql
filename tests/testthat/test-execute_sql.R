conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
DBI::dbWriteTable(conn, "iris", iris)

test_that("execute_sql works", {
  nrows <- nrow(iris[iris$Species == "setosa", ])

  expect_equal(
    execute_sql("
      UPDATE iris
      SET Species = 'a'
      WHERE Species = 'setosa'
                ", .con = conn)
    , nrows)
})

DBI::dbDisconnect(conn)
