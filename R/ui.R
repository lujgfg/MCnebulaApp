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
      init_mcn_ui("init_mcn_ui")
    )
  )
  
}

