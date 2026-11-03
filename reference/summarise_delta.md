# Summarise the Delta-period case peak and vaccination coverage

For each chosen country, finds the peak of new cases per million within
a date range, the date of that peak, and how many people per 100 were
fully vaccinated at the peak and at the end of the range.

## Usage

``` r
summarise_delta(
  countries,
  start = as.Date("2021-06-01"),
  end = as.Date("2021-11-30"),
  data = covidexplorer::covid_delta
)
```

## Arguments

- countries:

  A character vector of country names, as they appear in
  [covid_delta](https://etc5523-2026.github.io/etc5523-assignment-4-vpat0051/reference/covid_delta.md).

- start, end:

  Start and end dates of the window. Defaults cover the whole dataset (1
  June 2021 to 30 November 2021).

- data:

  A data frame shaped like
  [covid_delta](https://etc5523-2026.github.io/etc5523-assignment-4-vpat0051/reference/covid_delta.md).
  Defaults to the data bundled with the package.

## Value

A tibble with one row per country and columns `country`,
`peak_cases_per_million`, `peak_date`, `vacc_at_peak` and `vacc_end`.
Values are `NA` where the country reported no data in the window.

## Examples

``` r
summarise_delta(c("Australia", "India"))
#> # A tibble: 2 × 5
#>   country   peak_cases_per_million peak_date  vacc_at_peak vacc_end
#>   <chr>                      <dbl> <date>            <dbl>    <dbl>
#> 1 Australia                   84.0 2021-10-03        45.0      71.8
#> 2 India                      137.  2021-06-01         3.07     31.6
summarise_delta("Japan", start = "2021-07-01", end = "2021-10-31")
#> # A tibble: 1 × 5
#>   country peak_cases_per_million peak_date  vacc_at_peak vacc_end
#>   <chr>                    <dbl> <date>            <dbl>    <dbl>
#> 1 Japan                     178. 2021-08-22         45.2     75.7
```
