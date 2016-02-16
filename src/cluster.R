
#-------------------------------------------------------------------------------
# Initialization

rm(list = ls(all = TRUE), envir = .GlobalEnv)

require('ProjectTemplate')
load.project()

enableJIT(3)

#-------------------------------------------------------------------------------
# Configuration

bucket.list <- c(100, 50, 10)
data.name <- 'cluster'

#-------------------------------------------------------------------------------
# Begin

Text.cluster(
  as.character(notes[['note']]),
  bucket.list = bucket.list,
  data.name = data.name
)
