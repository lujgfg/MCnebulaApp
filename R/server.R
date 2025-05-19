#' The application server-side
#'
#' @import shiny
#' @importFrom bslib bs_themer
#' @rdname server

server <- function(input, output, session) {
    
    # Your application server logic
    bslib::bs_themer()
    # Call module server functions
    if (Sys.info()["sysname"] == "Windows") {
      volumes = get_volumes_win()
    } else {
      volumes = shinyFiles::getVolumes()()
    }
    #> project init
    prj_init <- reactiveValues(data = NULL) # project init
    #project_init_server(id = "project_init_id", volumes = volumes, prj_init)
  }
