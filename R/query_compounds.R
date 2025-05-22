#'
#'
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton
#' @rdname query_compounds

query_compounds_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Query Compounds", 
    icon = bsicons::bs_icon("envelope-open-heart")
  )
}