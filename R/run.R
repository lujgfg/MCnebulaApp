#' Run the Shiny Application
#'
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options

run_MCnebulaApp <- function(
    onStart = NULL,
    options = list(),
    enableBookmarking = NULL,
    uiPattern = "/",
    maxRequestSize = 1000,
    ...
) {
  options(shiny.maxRequestSize = maxRequestSize * 1024^2)
  require(MCnebula2)
  require(exMCnebula2)
  golem::with_golem_options(
    app = shinyApp(
      ui = ui,
      server = server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}

