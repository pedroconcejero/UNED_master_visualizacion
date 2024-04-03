# shinydashboard
# Para Curso visualización avanzada master UNED 2024

# A partir de
# https://rstudio.github.io/shinydashboard/get_started.html

## app.R ##
library(shinydashboard)

body <- dashboardBody(
  fluidRow(
    box(title = "Box title", "Box content"),
    box(status = "warning", "Box content")
  ),
  
  fluidRow(
    box(
      title = "Title 1", width = 4, solidHeader = TRUE, status = "primary",
      "Box content"
    ),
    box(
      title = "Title 2", width = 4, solidHeader = TRUE,
      "Box content"
    ),
    box(
      title = "Title 1", width = 4, solidHeader = TRUE, status = "warning",
      "Box content"
    )
  ),
  
  fluidRow(
    box(
      width = 4, background = "black",
      "A box with a solid black background"
    ),
    box(
      title = "Title 5", width = 4, background = "light-blue",
      "A box with a solid light-blue background"
    ),
    box(
      title = "Title 6",width = 4, background = "maroon",
      "A box with a solid maroon background"
    )
  )
)

# We'll save it in a variable `ui` so that we can preview it in the console
ui <- dashboardPage(
  dashboardHeader(title = "Row layout"),
  dashboardSidebar(),
  body
)

# Preview the UI in the console
shinyApp(ui = ui, server = function(input, output) { })
