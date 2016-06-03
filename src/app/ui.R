
library('shiny')

#
# Configure user interface
#
shinyUI(fluidPage(
  titlePanel("Classifier (experimental note classification engine)"),
  sidebarLayout(
    sidebarPanel(
      "Form",
      fileInput("murally.html", "Mural.ly HTML export upload", multiple = FALSE, accept = NULL, width = NULL)
    ),
    mainPanel("Display")
  )
))
