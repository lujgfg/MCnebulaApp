#'
#'
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton
#' @rdname stat_analysis

stat_analysis_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Statistic Analysis",
    icon = bsicons::bs_icon("person-vcard")
  )
}