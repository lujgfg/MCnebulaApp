#' annotate_nebula UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom colourpicker colourInput
annotate_nebula_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Annotate Nebula", 
    icon = bsicons::bs_icon("emoji-neutral-fill"),
    layout_sidebar(
      sidebar = sidebar(
        textAreaInput(
          inputId = ns("palette_stat"),
          label = "Group Names (comma-separated)",
          value = "Model, Control"
        ),
        uiOutput(ns("color_inputs")),  # 动态颜色输入框
        textInput(
          inputId = ns("focus_classes"),
          label = "Focus Classes",
          value = NULL
        ),
        actionButton(
          inputId = ns("draw_annotate_nebula"),
          label = "Draw Nebula"
        ),
        textInput(
          inputId = ns("feature_id"),
          label = "Import Feature Id"
        ),
        actionButton(
          inputId = ns("draw_annotate_node"),
          label = "Draw Node"
        )
      ),
      page_fluid(
        nav_panel(
          title = "Annotate Nebula",
          icon = bsicons::bs_icon("inbox"), 
          navset_card_tab(
            height = 700,
            full_screen = TRUE,
            title = "Annotate Nebula",
            nav_panel(
              title = "Annotate Nebula",
              card_title("Annotate Nebula"),
              DT::dataTableOutput(ns("annotate_nebula"))
            ),
            nav_panel(
              title = "Annotate Node",
              card_title("Annotate Node"),
              DT::dataTableOutput(ns("annotate_node"))
            )
          )
        )
      )
    )
  )
}
    
#' annotate_nebula Server Functions
#'
#' @noRd 
#' @importFrom colourpicker colourInput
annotate_nebula_server <- function(id, volumes, mcn_objects){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$color_inputs <- renderUI({
      group_names <- unlist(strsplit(input$palette_stat, "\\s*,\\s*"))
      group_names <- group_names[group_names != ""]
      if (length(group_names) == 0) return(NULL)
      
      tagList(
        lapply(seq_along(group_names), function(i) {
          colourpicker::colourInput(
            inputId = ns(paste0("group_color_", i)),
            label = paste0("Color for ", group_names[i]),
            value = c("#EBA9A7", "#ACDFEE", "#A4DE02", "#FCB900")[i %% 4 + 1]
          )
        })
      )
    })
    
    observeEvent(input$draw_annotate_nebula, {
      req(mcn_objects$mcn2)
      mcn2 <- mcn_objects$mcn2
      
      mcn2 <- set_nodes_color(mcn2, use_tracer = T)
      raw_input <- as.character(input$palette_stat)
      parts <- strsplit(raw_input, ",\\s*")[[1]]         
      kv <- strsplit(parts, ":\\s*")                    
      palette_vec <- setNames(
        sapply(kv, function(x) x[2]),
        sapply(kv, function(x) x[1])
      )
      palette_stat(melody(mcn2)) <- palette_vec
      focus_classes <- as.character(input$focus_classes)
      for (i in focus_classes) {
        mcn2 <- annotate_nebula(mcn2, i)
      }
      
      mcn_objects$mcn2 <- mcn2
    })
    
    output$annotate_nebula <- renderPlot({
      req(mcn_objects$mcn2)
      visualize_all(
        mcn_objects$mcn2, as.character(input$focus_class[[1]]), annotate = T
      )
    })
    
    output$annotate_node <- renderPlot({
      req(mcn_objects$mcn2)
      ef <- as.character(input$feature_id)
      mcn2 <- mcn_objects$mcn2
      show_node(mcn2, ef)
    })
    
  })
}
    
## To be copied in the UI
# mod_annotate_nebula_ui("annotate_nebula_1")
    
## To be copied in the server
# mod_annotate_nebula_server("annotate_nebula_1")
