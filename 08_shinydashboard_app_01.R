# shinydashboard
# Para Curso visualización avanzada master UNED 2024

# A partir de
# https://rstudio.github.io/shinydashboard/get_started.html

# Establece tu directorio de trabajo
setwd("/home/pedro/Escritorio/UNED_2024/UNED_master_visualizacion_main")

# install.packages("shinydashboard")

# A dashboard has three parts: 
# 1 a header, 
# 2 a sidebar, 
# 3 and a body. 
# Here’s the most minimal possible UI for a dashboard page.

## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250)),
      
      box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50)
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)

