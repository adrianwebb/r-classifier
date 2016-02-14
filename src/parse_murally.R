
#-------------------------------------------------------------------------------
# Initialization

rm(list = ls(all = TRUE), envir = .GlobalEnv)

require('ProjectTemplate')
load.project()

enableJIT(3)

#-------------------------------------------------------------------------------
# Configuration

input.file <- 'cache/murally/index.html'
output.file <- 'data/notes.csv'

#-------------------------------------------------------------------------------
# Begin

Murally.parse(
  input.file,
  output.file
)
