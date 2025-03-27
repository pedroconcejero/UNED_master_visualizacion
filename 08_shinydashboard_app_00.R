# shinydashboard
# Para Curso visualización avanzada master UNED 2025

# A partir de
# https://rstudio.github.io/shinydashboard/get_started.html

# Establece tu directorio de trabajo
setwd("/home/pedro/Escritorio/UNED_2025/UNED_master_visualizacion-main")

# install.packages("shinydashboard")

# A dashboard has three parts: 
# 1 a header, 
# 2 a sidebar, 
# 3 and a body. 
# Here’s the most minimal possible UI for a dashboard page.

## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

# You can quickly view it at the R console by using the shinyApp() function. 
# (You can also use this code as a single-file app).

server <- function(input, output) { }
shinyApp(ui, server)

