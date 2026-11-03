# Getting started with covidexplorer

## What this package is for

`covidexplorer` helps public health students compare how countries fared
during the Delta wave (June to November 2021). The question it answers
is: **how did new COVID-19 cases move alongside vaccination coverage in
different countries?**

The data come from the Our World in Data COVID-19 dataset (CC BY), which
stopped updating in August 2024.

## Install

``` r

# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-vpat0051")
```

## Launch the app

``` r

library(covidexplorer)
launch_app()
```

The app has two tabs. **About and how to use** explains the fields.
**Explore** is where you work:

1.  Choose 1 to 6 countries.
2.  Set the date range.
3.  Compare the cases chart with the vaccination chart, then check the
    peak table.

If you clear the country box, the app shows a message asking you to pick
at least one country.

## Use the summary function without the app

[`summarise_delta()`](https://etc5523-2026.github.io/etc5523-assignment-4-vpat0051/reference/summarise_delta.md)
gives the same peak table the app shows.

``` r

library(covidexplorer)
summarise_delta(c("Australia", "India", "United Kingdom"))
#> # A tibble: 3 × 5
#>   country        peak_cases_per_million peak_date  vacc_at_peak vacc_end
#>   <chr>                           <dbl> <date>            <dbl>    <dbl>
#> 1 Australia                        84.0 2021-10-03        45.0      71.8
#> 2 India                           137.  2021-06-01         3.07     31.6
#> 3 United Kingdom                  690.  2021-10-24        67.5      68.7
```

## How to read the outputs

Take the table above. The United Kingdom peaked at about 690 new cases
per million on 24 October, when roughly 67 in 100 people were fully
vaccinated. Australia’s peak came on 3 October at about 84 cases per
million, with about 45 in 100 fully vaccinated, and its coverage climbed
to about 72 by the end of November.

So a country can be highly vaccinated and still have a large case wave,
and a country can have a small wave while coverage is still catching up.
The charts show timing and size, not cause.

India’s peak date is 1 June, the first day of the window. That flags a
peak that happened before our data starts, so the table’s number is just
the highest value we can see.

## Limitations

- Cases depend on how much each country tested and reported.
- Vaccination values are carried forward between reporting days, and
  some countries have gaps early in the window.
- The window ends on 30 November 2021, before Omicron took over.

``` r

head(covid_delta)
#> # A tibble: 6 × 9
#>   iso_code continent country     date       population new_cases_per_million
#>   <chr>    <chr>     <chr>       <date>          <dbl>                 <dbl>
#> 1 AFG      Asia      Afghanistan 2021-06-01   41128772                  17.7
#> 2 AFG      Asia      Afghanistan 2021-06-02   41128772                  17.7
#> 3 AFG      Asia      Afghanistan 2021-06-03   41128772                  17.7
#> 4 AFG      Asia      Afghanistan 2021-06-04   41128772                  17.7
#> 5 AFG      Asia      Afghanistan 2021-06-05   41128772                  17.7
#> 6 AFG      Asia      Afghanistan 2021-06-06   41128772                  29.8
#> # ℹ 3 more variables: new_deaths_per_million <dbl>, fully_vaccinated_pct <dbl>,
#> #   stringency_index <dbl>
```
