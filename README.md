# covidexplorer

An R package with a Shiny app for exploring how new COVID-19 cases and vaccination coverage moved together across countries during the Delta period (June to November 2021).

**Intended user:** public health students comparing how countries fared during the Delta wave.

**Question:** How did new COVID-19 cases move alongside vaccination coverage in different countries during the Delta period?

Documentation website: https://etc5523-2026.github.io/etc5523-assignment-4-vpat0051/

## Data

`covid_delta` is a cleaned subset of the [Our World in Data COVID-19 dataset](https://github.com/owid/covid-19-data) (Mathieu, Ritchie et al.), licensed CC BY. It covers 1 June to 30 November 2021 and includes new cases and deaths per million (7-day average), the share of people fully vaccinated, and a stringency index. The source repository stopped updating in August 2024. The cleaning steps are in `data-raw/covid_delta.R`.

## Installation

```r
# install.packages("remotes")
remotes::install_github("ETC5523-2026/etc5523-assignment-4-vpat0051")
```

## Launch the app

```r
library(covidexplorer)
launch_app()
```

You can also summarise the case peak and vaccination coverage for chosen countries without the app:

```r
summarise_delta(c("Australia", "India"))
```

## Generative AI declaration

Generative AI declaration: I used Claude to help plan the package and debug the R code, fix a git problem, and draft the documentation and vignette text. I checked, ran and revised everything.
