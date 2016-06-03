
#
# Initialize application environment
#
library('ProjectTemplate')
load.project()

#
# Initialize server configuration
#
# Listen port
port <- as.numeric(Sys.getenv('PORT'))
if (is.na(port)) { port <- 8080 }

logger.info(paste('Shiny server listening on port:', as.character(port), sep = ' '))

s3.data <- get.s3.env('s3-data')

set.s3.credentials(s3.data$access_key_id, s3.data$secret_access_key, )

#
# Start Shiny application
#
enableJIT(3)

shiny::runApp(
  appDir = file.path(getwd(), 'src', 'app'),
  host = '0.0.0.0',
  port = as.numeric(port)
)
