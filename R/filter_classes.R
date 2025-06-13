#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT dataTableOutput
#'
#' @title filter classes from mcn of ui
#' @noRd

filter_classes_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Filter Classes", 
    icon = bsicons::bs_icon("upload"),
    layout_sidebar(
      sidebar = sidebar(
        textInput(
          inputId = ns("min_number"),
          label = "Min Number",
          value = 10
        ),
        sliderInput(
          inputId = ns("max_ratio"),
          label = "Max Ratio",
          min = 0, max = 1,
          step = .01, value = .05
        ),
        sliderInput(
          inputId = ns("ppcp_cutoff"),
          label = "PPCP cutoff",
          min = 0, max = 1,
          step = .01, value = .4
        ),
        radioButtons(
          inputId = ns("hie_pri"),
          label = "Hierarchy Priority",
          choices = .hierarchy_classes,
          selected = "All"
        ),
        textInput(
          inputId = ns("rm_classes"), 
          label = "Remove Classes", 
          value = c("a,", "b")
        ), 
        actionButton(
          inputId = ns("f_classes"),
          label = "Filter Classes",
          icon = icon("computer-mouse")
        )
      ),
      page_fluid(
        nav_panel(
          title = "Show Classes",
          icon = bsicons::bs_icon("inbox"), 
          tags$h3("Show Classes", style = "color: black"),
          actionButton(
            inputId = ns("show_classes"), 
            label =  "Show Classes", 
            icon = icon("computer-mouse"), 
            width = "15%"
          ),
          htmlOutput(ns("file_check2")),
          navset_card_tab(
            height = 600,
            full_screen = TRUE,
            title = "Show Classes",
            nav_panel(
              title = "Original Classes",
              card_title("Original Classes"),
              DT::dataTableOutput(ns("classes_info"))
            ),
            nav_panel(
              title = "dis",
              card_title("Remove Classes"),
              DT::dataTableOutput(ns("dis_classes_info"))
            )
          )
        )
      )
    ) 
  )
}

#' @import shiny
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom shinyFeedback showToast
#' @importFrom DT renderDataTable datatable
#' @importFrom MCnebula2 create_stardust_classes create_features_annotation cross_filter_stardust
#'
#' @title filter classes from mcn of server
#' @rdname filter_classes

filter_classes_server <- function(id, volumes, mcn_objects) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    observeEvent(input$f_classes, {
      req(mcn_objects$mcn)
      req(input$min_number)
      req(input$max_ratio)
      req(input$ppcp_cutoff)
      req(input$hie_pri)
      
      print(input$hie_pri)
      shinyFeedback::showToast(
        type = "info",
        title = "Button clicked",
        message = "began filtering classes..."
      )
      
      mcn <- mcn_objects$mcn
      
      hierarchy_map <- list(
        "All" = NULL,
        "Level 2" = 2,
        "Level 3" = 3,
        "Level 4" = 4,
        "Level 5" = 5
      )
      hie_value <- hierarchy_map[[ input$hie_pri ]]
      
      args <- list(x = mcn)
      if (!is.null(hie_value)) {
        args$hierarchy_priority <- hie_value
      }
      mcn <- do.call(create_stardust_classes, args)

      mcn <- create_features_annotation(mcn)
      mcn <- cross_filter_stardust(
        mcn, min_number = as.numeric(input$min_number),
        max_ratio = as.numeric(input$max_ratio),
        cutoff = as.numeric(input$ppcp_cutoff)
      )
      mcn_objects$mcn <- mcn
      shinyalert::shinyalert(
        title = "Success",
        text = "Filter classes accomplished",
        type = "success"
      )
    })
    
    observeEvent(input$show_classes, {
      req(mcn_objects$mcn)
      classes <- unique(stardust_classes(mcn_objects$mcn)$class.name)
      output$classes_info <- DT::renderDataTable({
        DT::datatable(data.frame(Class = classes))
      })
    })
    
  })
}

.hierarchy_classes <- c("All", paste("Level", 2:5))
