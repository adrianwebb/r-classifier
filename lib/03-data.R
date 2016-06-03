
#-------------------------------------------------------------------------------
# Normalization

value <- function(data, default.value = 0, format = 'as.numeric') {
  if (is.null(data) || is.na(data)) { data <- default.value }
  
  if (! is.null(format)) {
    data <- do.call(format, list(data))
  }
  data
}
