#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT dataTableOutput
#'
#' @title filter classes from mcn of ui
#' @rdname filter_classes

filter_classes_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Filter Classes", 
    icon = bsicons::bs_icon("upload"),
    layout_sidebar(
      sidebar = sidebar(
        sliderInput(
          inputId = ns("ppcp_cutoff"),
          label = "PPCP cutoff",
          min = 0, max = 1,
          step = .01, value = .5
        )
      ),
      page_fluid(
        nav_panel(
          title = "Show Classes",
          icon = bsicons::bs_icon("inbox"), 
          actionButton(ns("action1.1"), "Show Classes", icon = icon("computer-mouse"), width = "15%"),
          tags$h3("Show Classes",style = "color: black"),
          htmlOutput(ns("file_check2")),
          navset_card_tab(
            height = 350,
            full_screen = TRUE,
            title = "Show Classes",
            nav_panel(
              title = "Original Classes",
              card_title("Original Classes"),
              DT::dataTableOutput(ns("tbl_variable_info"))
            ),
            nav_panel(
              title = "dis",
              card_title("Remove Classes"),
              DT::dataTableOutput(ns("tbl_expmat"))
            )
          )
        )
      )
    ) 
  )
}