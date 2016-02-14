
#-------------------------------------------------------------------------------
# Initialization

rm(list = ls(all = TRUE), envir = .GlobalEnv)

require('ProjectTemplate')
load.project()

enableJIT(3)

#-------------------------------------------------------------------------------
# Configuration

report.file <- 'reports/cluster.txt'

#-------------------------------------------------------------------------------
# Begin

Text.cluster(
  notes[['note']],
  report.file
)
