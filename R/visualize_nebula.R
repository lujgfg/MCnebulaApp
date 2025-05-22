#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT dataTableOutput
#'
#' @title 
#' @rdname visualiza_nebula

visualize_nebula_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Visualize Nebula", 
    icon = bsicons::bs_icon("upload")
  )
}