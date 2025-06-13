library(shiny)
library(shinyFiles)

ui <- fluidPage(
  shinyDirButton("dir", "Choose directory", "Select a folder"),
  verbatimTextOutput("dir_path")
)

server <- function(input, output, session) {
  volumes <- getVolumes()()
  shinyDirChoose(input, "dir", roots = volumes, session = session)
  
  output$dir_path <- renderPrint({
    req(input$dir)
    parseDirPath(volumes, input$dir)
  })
}

shinyApp(ui, server)
