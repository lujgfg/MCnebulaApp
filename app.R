library(shiny)
library(bslib)
library(shinydashboard)
library(MCnebula2)

load("data/mcn_test.RData")
mcn <- filter_structure(mcn)
mcn <- create_reference(mcn)
mcn <- filter_formula(mcn, by_reference = T)
mcn <- create_stardust_classes(mcn)
mcn <- create_features_annotation(mcn)


ui <- page_sidebar(
  title = "MCnebula2",
  sidebar = sidebar(
    numericInput(
      inputId = "min_number", label = "min number in each class", value = 1
    ), 
    sliderInput(
      "max_ratio",
      label = "max ratio in each class",
      min = 0, 
      max = 1, 
      value = .09
    )
  ),
  card(plotOutput("parent_nebula"))
)

server <- function(input, output) {
  output$parent_nebula <- renderPlot({
    mcn <- cross_filter_stardust(
      mcn,
      min_number = input$min_number,
      max_ratio = input$max_ratio)
    mcn <- create_nebula_index(mcn)
    mcn <- compute_spectral_similarity(mcn)
    mcn <- create_parent_nebula(mcn)
    mcn <- create_child_nebulae(mcn)
    mcn <- create_parent_layout(mcn)
    mcn <- create_child_layouts(mcn)
    mcn <- activate_nebulae(mcn)
    visualize(mcn, "parent")
  }, width = 800, height = 800)
}

shinyApp(ui = ui, server = server)
