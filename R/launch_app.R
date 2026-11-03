#' Launch the Delta-period COVID-19 explorer app
#'
#' Opens a Shiny app that helps public health students compare new cases
#' and vaccination coverage across countries during the Delta period
#' (June to November 2021).
#'
#' @return Called for its side effect of launching the app. Returns nothing.
#'
#' @examples
#' if (interactive()) {
#'   launch_app()
#' }
#'
#' @export
launch_app <- function() {
  app_dir <- system.file("app", package = "covidexplorer")
  if (app_dir == "") {
    stop("Could not find the app. Try reinstalling `covidexplorer`.",
         call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
