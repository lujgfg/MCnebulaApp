#' Head Horizontal Rule
#'
#' This function creates a header styled horizontal rule.
#' @return An HTML horizontal rule element for header style.
#' @noRd

hr_head <- function() {
  custom_hr(
    "border: 0; padding-top: 1.5px; background: linear-gradient(to right, transparent, #008080, transparent);"
  )
}


#' @param path A mcnebula object file path
#' @importFrom shinyalert shinyalert
#'
#' @export

load_rdata <- function(path) {
  tryCatch({
    env <- new.env()
    load(path, envir = env)
    objs <- ls(env)
    if(length(objs) != 1) stop("File should contain exactly one object")
    get(objs, envir = env)
  }, error = function(e) {
    shinyalert(
      title = "Load Error",
      text = paste("Failed to load file:", e$message),
      type = "error"
    )
    return(NULL)
  })
}