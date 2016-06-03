
if (!is.na(Sys.getenv('VCAP_APPLICATION', unset = NA))) {
  APPLICATION <- fromJSON(Sys.getenv('VCAP_APPLICATION'))
} else {
  APPLICATION <- list()
}

if (!is.na(Sys.getenv('VCAP_SERVICES', unset = NA))) {
  SERVICES <- fromJSON(Sys.getenv('VCAP_SERVICES'))
} else {
  SERVICES <- list()
}

#
# Service accessors
#
get.s3.env <- function(name) {
  s3.data <- NULL

  for (index in 1:length(SERVICES$s3)) {
    if (SERVICES$s3[[index]]$name == name) {
      s3.data <- SERVICES$s3[[index]]$credentials
      break
    }
  }
  s3.data
}

#
# Environment modification
#
set.aws.credentials <- function(access_key_id, secret_access_key, region = 'us-east-1') {
  Sys.setenv('AWS_ACCESS_KEY_ID' = access_key_id,
             'AWS_SECRET_ACCESS_KEY' = secret_access_key,
             'AWS_DEFAULT_REGION' = region)
}
