#' mcnebula project init ui
#'
#' @import shiny
#' @import bslib
#' @importFrom  bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton
#' @rdname init_mcn

init_mcn_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = 'Initialize mcnebula', 
    icon = bsicons::bs_icon("play-circle"), 
    layout_sidebar(
      sidebar = accordion(
        accordion_panel(
          title = "Working diretory", 
          icon = bsicons::bs_icon("menu-app"),
          shinyDirButton(
            id = ns("prj_wd"),
            label = "Set working directory" ,
            title = "Set working directory:",
            buttonType = "default", class = NULL,
            icon = bsicons::bs_icon("folder"), multiple = FALSE
          ),
          tags$span(textOutput(outputId = ns("raw_wd_path")), class = "text-wrap")
        )
      )
    )
  )
}
