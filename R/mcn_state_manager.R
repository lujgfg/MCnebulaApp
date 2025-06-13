#' #' @title MCnebula object state manager
#' 
#' createStateManager <- function(mcn) {
#'   state <- reactiveVal(initial_object)
#'   original <- initial_object  # 用于 reset 功能
#'   
#'   list(
#'     get = function() state(),
#'     set = function(obj) state(obj),
#'     reset = function() state(original)
#'   )
#' }