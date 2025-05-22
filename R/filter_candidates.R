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
          selected = "FALSE"
        )
      )
    )
  )
}