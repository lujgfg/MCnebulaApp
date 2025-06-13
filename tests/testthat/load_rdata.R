library(shiny)

ui <- fluidPage(
  fileInput("sample_mcn", "Upload Sample"),
  actionButton("init_sample_mcn", "Load Sample")
)

server <- function(input, output, session) {
  observe({
    print("==== fileInput ====")
    print(input$sample_mcn)
  })
  observeEvent(input$init_sample_mcn, {
    print("✅ 按钮点击了")
    req(input$sample_mcn)
    path <- input$sample_mcn$datapath
    print(path)
    env <- new.env()
    loaded_name <- load(path, envir = env)
    print(loaded_name)
    print(env[[loaded_name]])
  })
}

shinyApp(ui, server)
