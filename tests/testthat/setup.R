setup_connection <- function() {
  pool <- pool::dbPool(drv = RSQLite::SQLite(), dbname = ":memory:")

  options(simplysql.connection_pool = pool)

  withr::defer(pool::poolClose(pool),
               parent.frame())

  return(pool)
}
