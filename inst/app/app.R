library(shiny)
library(ggplot2)

delta <- covidexplorer::covid_delta
country_choices <- sort(unique(delta$country))
max_countries <- 6

theme <- bslib::bs_theme(version = 5, bootswatch = "flatly", primary = "#2C6E91")

css <- "
  body { line-height: 1.6; }
  h1, h2, h3, h4 { color: #1d4559; }
  .app-title { margin: 20px 0 4px 0; font-weight: 700; }
  .app-subtitle { color: #555; margin-bottom: 20px; }
  .note { background: #eef5f9; border-left: 4px solid #2C6E91;
          padding: 10px 14px; margin: 10px 0 20px 0; border-radius: 4px; }
  .shiny-output-error-validation { color: #9c2f2f; font-weight: 600;
          padding: 20px; background: #fdf1f1; border-radius: 4px; }
"

ui <- fluidPage(
  theme = theme,
  tags$head(tags$style(HTML(css))),
  h1("Delta-period COVID-19 explorer", class = "app-title"),
  p("June to November 2021", class = "app-subtitle"),

  tabsetPanel(
    tabPanel(
      "About and how to use",
      br(),
      h4("Who is this for?"),
      p("Public health students comparing how countries fared during the Delta wave."),
      h4("What question does it answer?"),
      p(strong("How did new COVID-19 cases move alongside vaccination coverage in different countries during the Delta period?")),
      h4("How to use it"),
      tags$ol(
        tags$li("Go to the Explore tab."),
        tags$li(paste0("Choose 1 to ", max_countries, " countries. Type in the box to search.")),
        tags$li("Change the date range to zoom in on a particular stretch of the wave."),
        tags$li("Compare the top chart (cases) with the second chart (vaccination), then check the table for each country's peak.")
      ),
      h4("What the fields mean"),
      tags$ul(
        tags$li(strong("New cases per million:"), " confirmed cases per day per million people, as a 7-day average. Using per million makes small and large countries comparable."),
        tags$li(strong("Fully vaccinated (per 100):"), " percent of the population that has completed the primary vaccine course."),
        tags$li(strong("Peak date:"), " the day cases per million were highest within your chosen dates."),
        tags$li(strong("Vaccinated at peak / at end:"), " vaccination coverage on the peak date and on the last date with data.")
      ),
      h4("Data source"),
      p("Our World in Data COVID-19 dataset (CC BY), Mathieu, Ritchie et al. The source stopped updating in August 2024.")
    ),

    tabPanel(
      "Explore",
      br(),
      sidebarLayout(
        sidebarPanel(
          width = 4,
          selectizeInput(
            "countries", paste0("Countries (up to ", max_countries, ")"),
            choices = country_choices,
            selected = c("Australia", "India", "United Kingdom"),
            multiple = TRUE
          ),
          dateRangeInput(
            "dates", "Date range",
            start = min(delta$date), end = max(delta$date),
            min = min(delta$date), max = max(delta$date)
          ),
          div(class = "note",
              "Tip: if a country's peak date is the first or last day of your range, its real peak was probably outside the dates you chose.")
        ),
        mainPanel(
          width = 8,
          h4("Daily new cases"),
          plotOutput("cases_plot", height = "320px"),
          div(class = "note",
              "Read this chart for timing and size. Taller lines mean more cases per person. Compare when each line starts to rise."),
          h4("Vaccination coverage"),
          plotOutput("vacc_plot", height = "320px"),
          div(class = "note",
              "Look at how vaccinated each country was when its cases started climbing. Lines can start late because some countries had not reported vaccination yet."),
          h4("Peak summary"),
          tableOutput("peak_table"),
          div(class = "note",
              "This is a comparison of timing, not proof that vaccination caused a drop in cases. Testing, reporting and restrictions also differ between countries.")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  # Rows for the chosen countries and dates. Every output below uses this,
  # so the checks here show their message in all three places.
  selected_data <- reactive({
    validate(
      need(length(input$countries) > 0,
           "Pick at least one country to see the charts."),
      need(length(input$countries) <= max_countries,
           paste0("Please choose ", max_countries, " countries or fewer so the lines stay readable.")),
      need(input$dates[1] <= input$dates[2],
           "The start date must be on or before the end date.")
    )
    d <- dplyr::filter(
      delta,
      country %in% input$countries,
      date >= input$dates[1],
      date <= input$dates[2]
    )
    validate(need(nrow(d) > 0, "No data for these countries in this date range."))
    d
  })

  plot_theme <- theme_minimal(base_size = 14) +
    theme(legend.position = "bottom", panel.grid.minor = element_blank())

  output$cases_plot <- renderPlot({
    ggplot(selected_data(), aes(date, new_cases_per_million, colour = country)) +
      geom_line(linewidth = 1.1) +
      scale_colour_brewer(palette = "Dark2") +
      labs(x = NULL, y = "New cases per million (7-day average)", colour = NULL) +
      plot_theme
  })

  output$vacc_plot <- renderPlot({
    d <- selected_data()
    validate(need(any(!is.na(d$fully_vaccinated_pct)),
                  "None of the selected countries reported vaccination data in this date range."))
    ggplot(d, aes(date, fully_vaccinated_pct, colour = country)) +
      geom_line(linewidth = 1.1, na.rm = TRUE) +
      scale_colour_brewer(palette = "Dark2") +
      labs(x = NULL, y = "Fully vaccinated (per 100 people)", colour = NULL) +
      plot_theme
  })

  output$peak_table <- renderTable({
    selected_data()  # runs the checks above first
    s <- covidexplorer::summarise_delta(
      input$countries,
      start = input$dates[1],
      end = input$dates[2]
    )
    s$note <- ifelse(
      !is.na(s$peak_date) & (s$peak_date == input$dates[1] | s$peak_date == input$dates[2]),
      "Peak may be outside these dates", ""
    )
    s$peak_date <- as.character(s$peak_date)
    names(s) <- c("Country", "Peak cases per million", "Peak date",
                  "Vaccinated at peak (per 100)", "Vaccinated at end (per 100)", "Note")
    s
  }, na = "no data")
}

shinyApp(ui, server)
