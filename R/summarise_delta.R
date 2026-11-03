#' Summarise the Delta-period case peak and vaccination coverage
#'
#' For each chosen country, finds the peak of new cases per million within a
#' date range, the date of that peak, and how many people per 100 were fully
#' vaccinated at the peak and at the end of the range.
#'
#' @param countries A character vector of country names, as they appear in
#'   [covid_delta].
#' @param start,end Start and end dates of the window. Defaults cover the
#'   whole dataset (1 June 2021 to 30 November 2021).
#' @param data A data frame shaped like [covid_delta]. Defaults to the
#'   data bundled with the package.
#'
#' @return A tibble with one row per country and columns `country`,
#'   `peak_cases_per_million`, `peak_date`, `vacc_at_peak` and `vacc_end`.
#'   Values are `NA` where the country reported no data in the window.
#'
#' @examples
#' summarise_delta(c("Australia", "India"))
#' summarise_delta("Japan", start = "2021-07-01", end = "2021-10-31")
#'
#' @importFrom rlang .data
#' @export
summarise_delta <- function(countries,
                            start = as.Date("2021-06-01"),
                            end = as.Date("2021-11-30"),
                            data = covid_delta) {
  if (length(countries) == 0) {
    stop("Please supply at least one country.", call. = FALSE)
  }
  start <- as.Date(start)
  end <- as.Date(end)
  if (start > end) {
    stop("`start` must be on or before `end`.", call. = FALSE)
  }

  data |>
    dplyr::filter(
      .data$country %in% countries,
      .data$date >= start,
      .data$date <= end
    ) |>
    dplyr::arrange(.data$country, .data$date) |>
    dplyr::group_by(.data$country) |>
    dplyr::summarise(
      peak_cases_per_million = if (all(is.na(.data$new_cases_per_million))) {
        NA_real_
      } else {
        max(.data$new_cases_per_million, na.rm = TRUE)
      },
      peak_date = if (all(is.na(.data$new_cases_per_million))) {
        as.Date(NA)
      } else {
        .data$date[which.max(.data$new_cases_per_million)]
      },
      vacc_at_peak = if (all(is.na(.data$new_cases_per_million))) {
        NA_real_
      } else {
        .data$fully_vaccinated_pct[which.max(.data$new_cases_per_million)]
      },
      vacc_end = {
        v <- .data$fully_vaccinated_pct[!is.na(.data$fully_vaccinated_pct)]
        if (length(v) == 0) NA_real_ else v[length(v)]
      },
      .groups = "drop"
    )
}
