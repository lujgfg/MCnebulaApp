#'
#'
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton
#' @rdname basic_workflow

basic_workflow_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Basic Workflow",
    icon = bsicons::bs_icon("envelope-open-heart")
  )
}