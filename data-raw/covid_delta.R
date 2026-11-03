# Source: Our World in Data COVID-19 dataset (CC BY)
# https://github.com/owid/covid-19-data (no longer updated after 19 Aug 2024)

library(tidyverse)

url <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
raw_file <- "data-raw/owid-covid-data.csv"

if (!file.exists(raw_file)) {
  download.file(url, raw_file, mode = "wb")
}

owid_raw <- read_csv(raw_file, show_col_types = FALSE)

# Delta-period window (Delta dominant in most countries)
start_date <- as.Date("2021-06-01")
end_date   <- as.Date("2021-11-30")

covid_delta <- owid_raw |>
  # drop aggregates like World, Europe, High income (iso codes start with OWID_)
  filter(!str_starts(iso_code, "OWID_")) |>
  select(
    iso_code, continent, country = location, date, population,
    new_cases_per_million = new_cases_smoothed_per_million,
    new_deaths_per_million = new_deaths_smoothed_per_million,
    fully_vaccinated_pct = people_fully_vaccinated_per_hundred,
    stringency_index
  ) |>
  arrange(country, date) |>
  group_by(country) |>
  # vaccination is only reported on some days, so carry the last value forward
  fill(fully_vaccinated_pct, .direction = "down") |>
  ungroup() |>
  filter(date >= start_date, date <= end_date) |>
  # countries with no case data in the window can't be plotted
  group_by(country) |>
  filter(any(!is.na(new_cases_per_million))) |>
  ungroup()

usethis::use_data(covid_delta, overwrite = TRUE)
