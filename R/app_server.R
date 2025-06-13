#' The application server-side
#'
#' @noRd
#' @import shiny
#' @importFrom bslib bs_themer

app_server <- function(input, output, session) {
    
    # Your application server logic
    bslib::bs_themer()
    # Call module server functions
    if (Sys.info()["sysname"] == "Windows") {
      volumes = get_volumes_win()
    } else if (Sys.info()["sysname"] == "Linux") {
      # Set volumes to shiny user's home directory on Linux
      shiny_home <- Sys.getenv("HOME", unset = "/home/shiny")
      volumes = c(shiny_home = shiny_home)
    } else if (Sys.info()["sysname"] == "Darwin") {  # macOS is identified as "Darwin"
      user_home <- Sys.getenv("HOME")
      volumes = c(home = user_home)
    } else {
      volumes = shinyFiles::getVolumes()()
    }
  
    mcn_objects <- reactiveValues(mcn = NULL, mcn2 = NULL, top.list = NULL)
    init_mcn_server(id = "init_mcn", volumes = volumes, mcn_objects)
    
    filter_candidates_server(
      id = "filter_candidates", volumes = volumes, mcn_objects = mcn_objects
    )
    
    filter_classes_server(
      id = "filter_classes", volumes = volumes, mcn_objects = mcn_objects
    )
    
    visualize_nebula_server(
      id = "visualize_nebula", volumes = volumes, mcn_objects = mcn_objects
    )
    
    stat_analysis_server(
      id = "stat_analysis", volumes = volumes, mcn_objects = mcn_objects
    )
    
    trace_fc_nebula_server(
      id = "trace_fc_nebula", volumes = volumes, mcn_objects = mcn_objects
    )
    
    annotate_nebula_server(
      id = "annotate_nebula", volumes = volumes, mcn_objects = mcn_objects
    )
    
    query_compounds_server(
      id = "query_compounds", volumes = volumes, mcn_objects = mcn_objects
    )
    
    plot_spectra_server(
      id = "plot_spectra", volumes = volumes, mcn_objects = mcn_objects
    )
}
