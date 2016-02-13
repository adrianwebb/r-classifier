
PERIOD_SECONDS  <- 'sec'
PERIOD_MINUTES  <- 'min'
PERIOD_HOURS    <- 'hour'
PERIOD_DAYS     <- 'mday'
PERIOD_WEEKS    <- 'week'
PERIOD_MONTHS   <- 'mon'
PERIOD_QUARTERS <- 'quarter'
PERIOD_YEARS    <- 'year'

TIME_CLASS <- 'POSIXlt'

#-------------------------------------------------------------------------------

Sys.setenv(TZ = "UTC")

#-------------------------------------------------------------------------------

local.Time <- function(time = NULL) {
  if (is.null(time)) {
    as.POSIXlt(Sys.time(), Sys.getenv('TZ'))
  }
  else {
    as.POSIXlt(time, Sys.getenv('TZ'))
  }
}

ORIGIN <- local.Time("1900-01-01")
NOW    <- local.Time()

#-------------------------------------------------------------------------------

Time.shift <- function(time, offset = 0, period = PERIOD_DAYS) {
  local <- local.Time(time)
  
  if (period == PERIOD_WEEKS) {
    local[[PERIOD_DAYS]] <- local[[PERIOD_DAYS]] + (offset * 7)
  }
  else if (period == PERIOD_QUARTERS) {
    local[[PERIOD_MONTHS]] <- local[[PERIOD_MONTHS]] + (offset * 3)
  }
  else {
    local[[period]] <- local[[period]] + offset
  }
  
  if (is.character(time)) { as.character(local) }
  else { local }
}
