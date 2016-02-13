
#-------------------------------------------------------------------------------
# Operations

Murally.parse <- function(input.file, output.file) {
  message(paste("Reading and parsing", input.file))
  doc.html <- htmlTreeParse(input.file, useInternal = TRUE)
  sticky.list <- xpathApply(doc.html, "//ul[@class='sticky']/li")

  message("Processing stick notes into internal data")
  notes <- tolower(as.character(lapply(sticky.list, Murally.parse_text)))
  authors <- as.character(lapply(sticky.list, Murally.parse_author))
  
  message(paste("Creating notes data file at", output.file))
  write.csv(data.frame(note = notes, author = authors), file = output.file)
}

#-------------------------------------------------------------------------------
# Utilities

Murally.parse_text <- function(element) {
  gsub("(^\\s*\"|\"\\s*$)", "", xmlValue(element[['text']]), perl = TRUE)
}

Murally.parse_author <- function(element) {
  author <- xpathApply(element, "span[@class='author']")[[1]][['text']]
  gsub("(^\\s*by\\s+|\\s*$)", "", xmlValue(author), perl = TRUE)
}
