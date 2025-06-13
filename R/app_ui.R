#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
#' @importFrom shiny tagList
#' @importFrom bslib page_navbar nav_menu bs_theme
#' @importFrom bsicons bs_icon

app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    # Your application UI logic
    page_navbar(
      theme = bs_theme(bootswatch = "cerulean"),
      title = "MCnebula2",
      init_mcn_ui("init_mcn"),
      nav_menu(
        title = "Basic Workflow", bsicons::bs_icon("emoji-neutral-fill"),
        filter_candidates_ui("filter_candidates"), 
        filter_classes_ui("filter_classes"), 
        visualize_nebula_ui("visualize_nebula")
      ),
      nav_menu(
        title = "Downstream Analysis", bsicons::bs_icon("emoji-neutral-fill"),
        stat_analysis_ui("stat_analysis"),
        trace_fc_nebula_ui("trace_fc_nebula")
      ),
      nav_menu(
        title = "Annotation", bsicons::bs_icon("emoji-neutral-fill"),
        annotate_nebula_ui("annotate_nebula"),
        query_compounds_ui("query_compounds"),
        plot_spectra_ui("plot_spectra")
      )
    )
  )
  
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @noRd
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @importFrom shinyalert useShinyalert
#' @importFrom shinyFeedback useShinyFeedback

golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  # use_external_css_file("style.css")
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "MCnebula"
    ), 
    shinyalert::useShinyalert(),
    shinyFeedback::useShinyFeedback()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
    
  )
}