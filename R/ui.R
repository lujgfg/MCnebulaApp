#' The application User-Interface
#'
#' @import shiny
#' @import bslib
#' @rdname ui

ui <- function(request) {
  tagList(
    
    # Your application UI logic
    page_navbar(
      theme = bs_theme(bootswatch = "cerulean"),
      title = "MCnebula2",
      init_mcn_ui("init_mcn_ui"),
      nav_menu(
        title = "Basic Workflow", bsicons::bs_icon("emoji-kiss-fill"), 
        filter_candidates_ui("filter_candidates_ui"), 
        filter_classes_ui("filter_classes_ui"), 
        visualize_nebula_ui("visualize_nebula_ui")
      ),
      stat_analysis_ui("stat_analysis_ui"), 
      query_compounds_ui("query_compounds_ui")
    )
  )
  
}

