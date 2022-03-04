setup_connection <- function() {
  skip_on_cran()

  pool <- pool::dbPool(drv = RSQLite::SQLite(),
                       dbname = ":memory:")

  options(simplysql.connection_pool = pool)

  withr::defer(pool::poolClose(pool),
               parent.frame())

  return(pool)
}
