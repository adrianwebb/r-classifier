
#-------------------------------------------------------------------------------
# Packages

reload <- function(obj.names = NULL) {
  if (is.null(obj.names)) {
    #rm(list = ls(all = TRUE), envir = .GlobalEnv)  
  }
  else {
    #rm(list = obj.names, envir = .GlobalEnv)  
  }  
  library('ProjectTemplate')
  load.project()  
}

#-------------------------------------------------------------------------------
# Values

value <- function(data, default.value = 0, format = 'as.numeric') {
  if (is.null(data) || is.na(data)) { data <- default.value }
  
  if (! is.null(format)) {
    data <- do.call(format, list(data))
  }
  data
}
