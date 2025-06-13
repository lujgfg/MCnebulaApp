#' Set Statistical Analysis Results To Nebula UI Function
#' 
#' @description
#' A shiny module
#' 
#' @noRd
#' @import shiny
#' @import bslib
#' @importFrom shiny NS ns textInput actionButton plotOutput
#' @importFrom bslib nav_panel layout_sidebar sidebar page_fluid layout_column_wrap card card_header
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton

trace_fc_nebula_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Variance-Selected Feature Explorer",
    icon = bsicons::bs_icon("emoji-neutral-fill"), 
    layout_sidebar(
      sidebar = sidebar(
        textInput(
          inputId = ns("set_trace"),
          label = "Set the number of tracers",
          value = 20
        ),
        textInput(
          inputId = ns("set_fc"),
          label = "Set logFC",
          value = .3
        ), 
        textInput(
          inputId = ns("set_qvalue"),
          label = "Set Q-Value",
          value = .05
        ),
        actionButton(
          inputId = ns("draw_trace_fc_nebula"),
          label = "Draw Nebula",
          icon = icon("play")
        )
      ),
      page_fluid(
        nav_panel(
          title = "Show Trace-Nebula and logFC-Nebula",
          icon = bsicons::bs_icon("alarm"), 
          layout_column_wrap(
            width = .5,
            heights = 700, 
            card(
              full_screen = T,
              height = 700,
              card_header("Show Trace-Nebula"),
              plotOutput(ns("trace_nebula"), fill = T)
            ), 
            card(
              full_screen = T,
              height = 700,
              card_header("Show logFC-Nebula"),
              plotOutput(ns("logfc_nebula"), fill = T)
            )
          )
        )
      )
    )
  )
}

#' @noRd
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom shinyalert shinyalert
#' @importFrom shinyFeedback showToast
#' @importFrom DT renderDataTable datatable

trace_fc_nebula_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$draw_trace_fc_nebula, {
      req(mcn_objects$mcn)
      req(mcn_objects$top_list)
      
      shinyFeedback::showToast(
        type = "success",
        title = "Looks Good!",
        message = "Click success"
      )
      
      mcn <- mcn_objects$mcn
      top.list <- mcn_objects$top_list
      
      n <- as.numeric(input$set_trace)
      tops <- select_features(
        mcn, logfc = as.numeric(input$set_fc), 
        q.value = as.numeric(input$set_qvalue), 
        tani.score_cutoff = .5,
        order_by_coef = 1, coef = 1, togather = T
      )
      top20 <- tops[1:n]
      palette_set(melody(mcn)) <- colorRampPalette(palette_set(mcn))(length(top20))
      mcn2 <- set_tracer(mcn, top20)
      mcn2 <- create_child_nebulae(mcn2)
      mcn2 <- create_child_layouts(mcn2)
      mcn2 <- activate_nebulae(mcn2)
      mcn2 <- set_nodes_color(mcn2, use_tracer = T)
      
      mcn_objects$mcn2 <- mcn2
      
      output$trace_nebula <- renderPlot({
        visualize_all(mcn2)
      })
      
      output$logfc_nebula <- renderPlot({
        palette_gradient(melody(mcn2)) <- c("navy", "grey90", "firebrick3")
        mcn2 <- set_nodes_color(mcn2, "logFC", top.list[[ 1 ]])
        visualize_all(mcn2, fun_modify = modify_stat_child)
      })
      
      shinyalert::shinyalert(
        title = "Success",
        text = "Nebula accomplished",
        type = "success"
      )
    })
  })
}