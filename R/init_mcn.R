#' @noRd
#' @import shiny
#' @import bslib
#' @importFrom  bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton 
#' @title mcnebula project init ui

init_mcn_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Initialize MCnebula", 
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
          tags$span(
            textOutput(outputId = ns("raw_wd_path")), class = "text-wrap",
            style = "color: green;"
          ),
          radioButtons(
            inputId = ns("sirius_version"),
            label = "SIRIUS Version",
            choices = c("sirius.v4", "sirius.v5"),
            selected = "sirius.v5"
          ),
          shinyDirButton(
            id = ns("sirius_path"),
            label = "Set SIRIUS path", 
            title = "set SIRIUS path:",
            buttonType = "default", class = NULL,
            icon = bsicons::bs_icon("folder"), multiple = FALSE
          ),
          radioButtons(
            inputId = ns("init_mcn_mode"), 
            label = "Positive or Negative", 
            choices = c("Pos", "Neg"),
            selected = "Pos"
          ),
          
          actionButton(
            inputId = ns("init_mcn_start"),
            label = "Initialize MCnebula",
            icon = icon("play")
          )
        ),
        
        fileInput(
          inputId = ns("sample_mcn"),
          label = "Sample MCnebula",
          multiple = FALSE,
          buttonLabel = "Browse...",
          placeholder = "No file selected",
          accept = ".RData"
        ),
        
        actionButton(
          inputId = ns("init_sample_mcn"),
          label = "Initialize Sample MCnebula",
          icon = icon("play")
        )
      ) 
    )
  )
}

#' @noRd
#' @import shiny
#' @importFrom shinyjs toggle runjs useShinyjs
#' @importFrom shinyFiles shinyDirChoose parseDirPath getVolumes shinyFileChoose
#' @importFrom shinyalert shinyalert
#' @importFrom shinyFeedback showToast
#' @param id module of server
#' @param volumes shinyFile volumes

init_mcn_server <- function(id, volumes, mcn_objects) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    observe({
      shinyDirChoose(
        input = input,id = "prj_wd", roots =  volumes, session = session
      )
      if(!is.null(input$prj_wd)){
        # browser()
        set_wd_path <- parseDirPath(roots = volumes, input$prj_wd)
        output$raw_wd_path <- renderText(set_wd_path)
      }
    })
    
    observe({
      shinyDirChoose(
        input = input, id = "sirius_path", roots = volumes, session = session
      )
    })
    
    observeEvent(input$init_mcn_start, {
      req(mcn_objects)
      req(init_mcn_mode)
      req(prj_wd)
      
      sirius_path <- parseDirPath(roots = volumes, input$sirius_path)
      print(as.character(sirius_path))
      print(input$sirius_version)
      
      mcn <- mcnebula()
      mcn <- initialize_mcnebula(
        mcn, as.character(input$sirius_version), as.character(sirius_path)
      )
      ion_mode(mcn) <- as.character(input$init_mcn_mode)
      export_path(mcn) <- as.character(input$prj_wd)
      mcn_objects$mcn <- mcn
      shinyalert::shinyalert(
        title = "Success",
        text = "MCnebula had initialized！",
        type = "success"
      )
    })
    
    observeEvent(input$init_sample_mcn, {
      req(mcn_objects)
      req(input$sample_mcn)
      shinyFeedback::showToast(
        type = "info",
        title = "Button clicked",
        message = "begin loading sample mcn..."
      )
      path <- input$sample_mcn$datapath
      env <- new.env()
      loaded_name <- load(path, envir = env)
      mcn_objects$mcn <- env[[ loaded_name ]]
      shinyalert::shinyalert(
        title = "Success",
        text = "Sample MCnebula had loaded！",
        type = "success"
      )
    })
  })
}