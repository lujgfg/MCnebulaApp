#' @import shiny
#' @import bslib
#' @importFrom bsicons bs_icon
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyFiles shinyDirButton
#' @importFrom DT dataTableOutput
#'
#' @title create layouts for Parent-Nebula or Child-Nebulae visualizations. 
#' @rdname visualize_nebula

visualize_nebula_ui <- function(id) {
  ns <- NS(id)
  nav_panel(
    title = "Visualize Nebula", 
    icon = bsicons::bs_icon("upload"),
    layout_sidebar(
      sidebar = sidebar(
        actionButton(
          inputId = ns("act_nebula"), 
          label = "Activate Nebula",
          icon = icon("computer-mouse")
        )
      ),
      page_fluid(
        nav_panel(
          title = "Show Nebula",
          icon = bsicons::bs_icon("inbox"), 
          tags$h3("Show Nebula", style = "color: black"),
          actionButton(
            inputId = ns("show_nebula"),
            label = "Show Nebula", 
            icon = icon("computer-mouse"),
            width = "15%"
          ),
          htmlOutput(ns("file_check3")),
          navset_card_tab(
            height = 700,
            full_screen = TRUE,
            title = "Show Nebula",
            sidebar = accordion(
              open = "closed", 
              accordion_panel(
                title = "Parent Nebula Download", 
                icon = bs_icon("download"),
                textInput(
                  inputId = ns("parent_height"), label = "height", value = 7
                ),
                textInput(
                  inputId = ns("parent_width"), label = "width", value = 7 
                ),
                selectInput(
                  inputId = ns("parent_format"), label = "format", 
                  choices = c("jpg", "pdf", "png", "tiff"),
                  selected = "pdf", selectize = F
                ), 
                downloadButton(
                  outputId = ns("parent_download"), 
                  label = "Download", icon = icon("download")
                )
              ), 
              accordion_panel(
                title = "Child Nebula Download", 
                icon = bs_icon("download"),
                textInput(
                  inputId = ns("child_height"), label = "height", value = 15
                ),
                textInput(
                  inputId = ns("child_width"), label = "width", value = 15 
                ),
                selectInput(
                  inputId = ns("child_format"), label = "format", 
                  choices = c("jpg", "pdf", "png", "tiff"),
                  selected = "pdf", selectize = F
                ), 
                downloadButton(
                  outputId = ns("child_download"), 
                  label = "Download", icon = icon("download")
                )
              )
            ),
            
            nav_panel(
              title = "Available Classes",
              card_title("Available-Classes"),
              DT::dataTableOutput(ns("ava_classes"))
            ),
            
            nav_panel(
              title = "Parent Nebula",
              card_title("Parent-Nebula"),
              plotOutput(ns("parent_nebula"), fill = T)
            ),
            
            nav_panel(
              title = "Child Nebula",
              card_title("Child-Nebula"),
             plotOutput(ns("child_nebula"), fill = T)
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
#' @importFrom shinyFeedback useShinyFeedback
#' @importFrom DT renderDataTable datatable
#'
#' @title create layouts for Parent-Nebula or Child-Nebulae visualizations. 
#' @rdname visualize_nebula


visualize_nebula_server <- function(id, volumes, mcn_objects) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    observeEvent(input$act_nebula, {
      shinyFeedback::showToast(
        type = "info",
        title = "Button clicked",
        message = "begin activating nebula..."
      )
      
      req(mcn_objects$mcn)
      mcn <- mcn_objects$mcn
      
      mcn <- create_nebula_index(mcn)
      mcn <- compute_spectral_similarity(mcn)
      mcn <- create_parent_nebula(mcn)
      mcn <- create_child_nebulae(mcn)
      mcn <- create_parent_layout(mcn)
      mcn <- create_child_layouts(mcn)
      mcn <- activate_nebulae(mcn)
      
      mcn_objects$mcn <- mcn
      shinyalert::shinyalert(
        title = "Success",
        text = "Activate nebula accomplished",
        type = "success"
      )
    })
    
    observeEvent(input$show_nebula, {
      req(mcn_objects$mcn)
      mcn <- mcn_objects$mcn
      table.nebulae <- visualize(mcn)
      
      output$ava_classes <- DT::renderDataTable({
        DT::datatable(data.frame(AvailableClasses = table.nebulae))
      })
      
      output$parent_nebula <- renderPlot({
        req(mcn_objects$mcn)
        visualize(mcn_objects$mcn, "parent")
      })
      
      output$parent_download <- downloadHandler(
        filename = function() {
          paste0("parent_nebula.", input$parent_format)
        },
        content = function(file) {
          req(mcn_objects$mcn)
          
          height <- as.numeric(input$parent_height)
          width <- as.numeric(input$parent_width)
          format <- input$parent_format
          
          if (format == "pdf") {
            pdf(file, height = height, width = width)
          } else if (format == "png") {
            png(file, height = height, width = width, units = "in", res = 300)
          } else if (format == "jpg") {
            jpeg(file, height = height, width = width, units = "in", res = 300)
          } else if (format == "tiff") {
            tiff(file, height = height, width = width, units = "in", res = 300)
          }
          
          visualize(mcn, "parent")
          dev.off()
        }
      )
      
      output$file_check3 <- renderUI({
        if (!is.null(mcn_objects$mcn)) {
          tags$p("Nebula is ready.", style = "color: green;")
        } else {
          tags$p("Please activate Nebula first.", style = "color: red;")
        }
      })
      
      output$child_nebula <- renderPlot({
        req(mcn_objects$mcn)
        visualize_all(mcn)
      })
      
      output$child_download <- downloadHandler(
        filename = function() {
          paste0("child_nebula.", input$child_format)
        },
        content = function(file) {
          req(mcn_objects$mcn)
          
          height <- as.numeric(input$child_height)
          width <- as.numeric(input$child_width)
          format <- input$child_format
          
          if (format == "pdf") {
            pdf(file, height = height, width = width)
          } else if (format == "png") {
            png(file, height = height, width = width, units = "in", res = 300)
          } else if (format == "jpg") {
            jpeg(file, height = height, width = width, units = "in", res = 300)
          } else if (format == "tiff") {
            tiff(file, height = height, width = width, units = "in", res = 300)
          }
          
          visualize_all(mcn)
          dev.off()
        }
      )
    })
  })
}
