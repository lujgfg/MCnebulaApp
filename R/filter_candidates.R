#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT dataTableOutput
#'
#' @title filter structure and formula from mcn of ui
#' @rdname filter_candidates

filter_candidates_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Filter Candidates", 
    icon = bsicons::bs_icon("upload"),
    layout_sidebar(
      sidebar = sidebar(
        radioButtons(
          inputId = ns("fs_mcn"), 
          label = "Structure by Reference", 
          choices = c("TRUE", "FALSE"), 
          selected = "FALSE"
        ), 
        radioButtons(
          inputId = ns("ff_mcn"), 
          label = "Formula by Reference", 
          choices = c("TRUE", "FALSE"),
          selected = "TRUE"
        ),
        actionButton(
          inputId = ns("fc_mcn"),
          label = "Filter Candidates",
          icon = icon("computer-mouse")
        ),
        htmlOutput(ns("file_check1"))
      )
    )
  )
}

#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom shinyFeedback showToast
#' @importFrom DT renderDataTable datatable
#'
#' @title filter structure and formula from mcn of server
#' @rdname filter_candidates


filter_candidates_server <- function(id, volumes, mcn_objects) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    observeEvent(input$fc_mcn, {
      shinyFeedback::showToast(
        type = "info",
        title = "Button clicked",
        message = "begin filtering candidates..."
      )
      
      req(mcn_objects$mcn)
      
      output$file_check1 <- renderUI({
        if (!is.null(mcn_objects$mcn)) {
          tags$p("data is processing.", style = "color: green;")
        } else {
          tags$p("Please activate Nebula first.", style = "color: red;")
        }
      })
      
      mcn <- mcn_objects$mcn
      mcn <- filter_structure(mcn, by_reference = as.logical(input$fs_mcn))
      mcn <- create_reference(mcn)
      mcn <- filter_formula(mcn, by_reference = as.logical(input$ff_mcn))
      mcn_objects$mcn <- mcn
      shinyalert::shinyalert(
        title = "Success",
        text = "Filter candidates accomplished",
        type = "success"
      )
    })
  })
}
