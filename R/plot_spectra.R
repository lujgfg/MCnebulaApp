#' plot_spectra UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
plot_spectra_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Plot Spectra", 
    icon = bsicons::bs_icon("emoji-neutral-fill"),
    layout_sidebar(
      sidebar = sidebar(
        textInput(
          inputId = ns("plot_id"),
          label = "Plot id",
          value = NULL
        ), 
        actionButton(
          inputId = ns("plot_spectra"),
          label = "Plot Spectra",
          icon = icon("play")
        )
      ),
      page_fluid(
        nav_panel(
          title = "Show MS/MS and EIC",
          icon = bsicons::bs_icon("alarm"), 
          layout_column_wrap(
            width = .5,
            heights = 700, 
            card(
              full_screen = T,
              height = 700,
              card_header("Show MS/MS"),
              plotOutput(ns("msms_plot"), fill = T)
            ), 
            card(
              full_screen = T,
              height = 700,
              card_header("Show EIC"),
              plotOutput(ns("eic_plot"), fill = T)
            )
          )
        )
      )
    )
  )
}
    
#' plot_spectra Server Functions
#'
#' @noRd 
plot_spectra_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$plot_spectra, {
      req(mcn_objects$mcn)
      
      mcn <- mcn_objects$mcn
      tops <- select_features(
        mcn, logfc = .3, 
        q.value = .05, 
        tani.score_cutoff = .5,
        order_by_coef = 1, coef = 1, togather = T
      )
      top20 <- tops[1:20]
      mcn <- mcn_objects$mcn
      mcn <- draw_structures(mcn, .features_id = top20)
      
      output$msms_plot <- renderPlot({
        plot_msms_mirrors(mcn, top20)
      })
      
      shinyalert::shinyalert(
        title = "Success",
        text = "msms plot accomplished",
        type = "success"
      )
    })
    
    #observeEvent(input$eic_plot, {
    #  req(mcn_objects$mcn)
    #  
    #  
    #})
 
  })
}
    
## To be copied in the UI
# mod_plot_spectra_ui("plot_spectra_1")
    
## To be copied in the server
# mod_plot_spectra_server("plot_spectra_1")
