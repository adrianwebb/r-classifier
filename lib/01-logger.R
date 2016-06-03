
require('log4r')

#
# Initialize logger
#
logger <- create.logger(logfile = stdout())

# LEVELS: DEBUG, INFO, WARN, ERROR, FATAL
log.level <- as.character(Sys.getenv('APP_LOG_LEVEL'))
if (nchar(log.level) == 0) { log.level <- 'WARN' }

level(logger) <- log.level

#
# Logger overrides
#
logger.debug <- function(message) {
  debug(logger, message)
  flush.log.buffer('DEBUG')
}
logger.info <- function(message) {
  info(logger, message)
  flush.log.buffer('INFO')
}
logger.warn <- function(message) {
  warn(logger, message)
  flush.log.buffer('WARN')
}
logger.error <- function(message) {
  error(logger, message)
  flush.log.buffer('ERROR')
}
logger.fatal <- function(message) {
  fatal(logger, message)
  flush.log.buffer('FATAL')
}

#
# Logging utilities
#
flush.log.buffer <- function(level) {
  level <- as.loglevel(level)
  if (logger[['level']] <= level) {
    flush.console()
  }
}
