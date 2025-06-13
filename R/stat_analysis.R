#' Statistical Analysis UI Function
#' 
#' @description
#' A shiny module
#' 
#' @noRd
#' @import shiny
#' @import bslib
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton

stat_analysis_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Statistic Analysis",
    icon = bsicons::bs_icon("emoji-neutral-fill"), 
    layout_sidebar(
      sidebar = accordion(
        accordion_panel(
          title = "MS/MS file",
          icon = bsicons::bs_icon("menu-app"),
          
          fileInput(
            inputId = ns("import_msms"),
            label = "Import quantification data",
            multiple = FALSE,
            buttonLabel = "Browse...",
            placeholder = "No file selected",
            accept = ".csv"
          ),
          actionButton(
            inputId = ns("load_msms"),
            label = "Load quantification data",
            icon = icon("play")
          ),
          
          textAreaInput(
            inputId = ns("group_def"),
            label = "Group definitions (e.g., Control:^B, Model:^M)",
            value = NULL,
            rows = 3
          ),
          textInput(
            inputId = ns("group_exp"),
            label = "Experimental Group",
            value = NULL
          ),
          textInput(
            inputId = ns("group_ref"),
            label = "Reference Group",
            value = NULL
          ),
          
          actionButton(
            inputId = ns("bin_comparison"),
            label = "Binary Comparison", 
            icon = icon("play")
          )
        )
      ), 
      page_fluid(
        navset_card_tab(
          height = 700,
          full_screen = TRUE,
          title = "Show quantification data",
          nav_panel(
            title = "Original Data",
            card_title("Original Data"),
            DT::dataTableOutput(ns("origin_data"))
          ),
          nav_panel(
            title = "Top List",
            card_title("Top List"),
            DT::dataTableOutput(ns("top_list"))
          )
        )
      )
    )
  )
}

#' @noRd
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT renderDataTable datatable
#' @importFrom MCnebula2 feastures_quantification sample_metadata binary_comparison top_table
#' @importFrom rlang parse_expr

stat_analysis_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$load_msms, {
      req(input$import_msms)
      
      origin <- data.table::fread(input$import_msms$datapath)
      origin <- tibble::as_tibble(origin)
      
      output$origin_data <- DT::renderDataTable({
        DT::datatable(data.frame(origin))
      })
    })
    
    observeEvent(input$bin_comparison, {
      req(input$group_def)
      req(input$group_exp)
      req(input$group_ref)
      req(input$bin_comparison)
      req(mcn_objects$mcn)
      
      
      origin <- data.table::fread(input$import_msms$datapath)
      origin <- tibble::as_tibble(origin)
      mcn <- mcn_objects$mcn
      
      raw_input <- as.character(input$group_def)
      parts <- strsplit(raw_input, ",\\s*")[[1]]         
      kv <- strsplit(parts, ":\\s*")                    
      group_vec <- setNames(
        sapply(kv, function(x) x[2]),
        sapply(kv, function(x) x[1])
      )
      print(group_vec)
      
      quant <- dplyr::select(
        origin, id = 1, dplyr::contains("Peak area")
      )
      colnames(quant) <- gsub(".mzML Peak area", "", colnames(quant))
      quant <- dplyr::mutate(quant, .features_id = as.character(id))
      
      metadata <- MCnebula2:::group_strings(colnames(quant), group_vec, "sample")
      features_quantification(mcn) <- dplyr::select(quant, -id)
      sample_metadata(mcn) <- metadata
      
      exp_group <- as.character(input$group_exp)
      ref_group <- as.character(input$group_ref)
      group_formula <- paste0(exp_group, " - ", ref_group)
      print(group_formula)
      
      mcn <- binary_comparison(mcn, Model - Control)
      top.list <- top_table(statistic_set(mcn))
      
      mcn_objects$mcn <- mcn
      mcn_objects$top_list <- top.list
      
      output$top_list <- DT::renderDataTable({
        DT::datatable(data.frame(top.list))
      })
      
      shinyalert::shinyalert(
        title = "Success",
        text = "Binary Comparison accomplished",
        type = "success"
      )
    })
  })
}