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
    icon = bsicons::bs_icon("emoji-neutral-fill"),
    layout_sidebar(
      sidebar = sidebar(
        actionButton(
          inputId = ns("annotate"),
          label = "Annotate Compounds"
        )
      ),
      page_fluid(
        nav_panel(
          title = "Annotate Compounds",
          icon = bsicons::bs_icon("inbox"), 
          tags$h3("Annotate Compounds", style = "color: black"),
          navset_card_tab(
            height = 700,
            full_screen = TRUE,
            title = "Annotate Compounds",
            nav_panel(
              title = "Annotate Compounds",
              card_title("Annotate Compounds"),
              DT::dataTableOutput(ns("annotate_compounds"))
            )
          )
        )
      )
    )
  )
}


#' query compounds Server Functions
#'
#' @noRd 
query_compounds_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_annotate_nebula_ui("annotate_nebula_1")
    
## To be copied in the server
# mod_annotate_nebula_server("annotate_nebula_1")
