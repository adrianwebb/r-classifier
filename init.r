
#-------------------------------------------------------------------------------
# Install dependencies

sink(stderr())

#
# Repositories
#
if (!require('drat')) {
  install.packages('drat')
  library('drat')
}
addRepo('cloudyr')

#
# Package list
#
install.packages(c(
  'ProjectTemplate',
  'shiny',
  'log4r',
  'rjson',
  'aws.s3'
), clean = TRUE, dependencies = TRUE)
