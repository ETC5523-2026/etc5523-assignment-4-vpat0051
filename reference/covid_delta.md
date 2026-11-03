# COVID-19 cases, deaths and vaccination during the Delta period

A cleaned subset of the Our World in Data COVID-19 dataset covering 1
June 2021 to 31 January 2022, when the Delta variant was dominant in
most countries. Aggregates such as "World" and "Europe" are removed, and
vaccination coverage is carried forward between reporting days.

## Usage

``` r
covid_delta
```

## Format

A tibble with 57,575 rows and 9 variables:

- iso_code:

  Three-letter ISO 3166-1 country code.

- continent:

  Continent of the country.

- country:

  Country name.

- date:

  Date of observation.

- population:

  Population of the country.

- new_cases_per_million:

  New confirmed cases per million people (7-day smoothed average).

- new_deaths_per_million:

  New confirmed deaths per million people (7-day smoothed average).

- fully_vaccinated_pct:

  People fully vaccinated per 100 people.

- stringency_index:

  Government response stringency index (0 to 100, higher means
  stricter).

## Source

Mathieu, E., Ritchie, H., et al. (2020). COVID-19 Dataset by Our World
in Data. <https://github.com/owid/covid-19-data>. Licensed under CC BY.
The source repository stopped updating on 19 August 2024.
