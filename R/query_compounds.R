#' query_compounds UI Function
#' 
#' @description
#' A shiny Module.
#' 
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' 
#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyFiles shinyDirButton shinyFilesButton

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
#' 
#' @import shiny
#' @importFrom DT renderDataTable datatable
#' 

query_compounds_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$annotate, {
      req(mcn_objects$mcn)
      mcn <- mcn_objects$mcn
      
      feas <- features_annotation(mcn2) 
      feas <- format_table(feas, export_name = NULL) 
      key2d <- feas$inchikey2d
      
      query_path <- file.path(export_path(mcn), "query")
      dir.create(query_path, F)
      
      key.rdata <- query_inchikey(key2d, query_path)
      class.rdata <- query_classification(key2d, query_path)
      iupac.rdata <- query_iupac(key2d, query_path)
      
      key.set <- extract_rdata_list(key.rdata)
      cid <- lapply(key.set, function(data) data$CID)
      cid <- unlist(cid, use.names = F)
      syno.rdata <- query_synonyms(cid, query_path)
      
      syno <- pick_synonym(key2d, key.rdata, syno.rdata, iupac.rdata) 
      feas$synonym <- syno
      
      class <- pick_class(key2d, class.rdata) 
      feas$class <- class 
      feas.table <- rename_table(feas)
      
      mcn_objects$feas.table <- feas.table
      
      output$annotate_compounds <- DT::renderDataTable({
        DT::datatable(data.frame(AnnotateCompounds = feas.table))
      })
    })
    
  })
}
    
## To be copied in the UI
# mod_annotate_nebula_ui("annotate_nebula_1")
    
## To be copied in the server
# mod_annotate_nebula_server("annotate_nebula_1")
