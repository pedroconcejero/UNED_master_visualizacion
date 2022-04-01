# master UNED visualizacion avanzada
# Tema 4 shiny - Ejemplo 2: Datos COVID


library(shiny)
library(ggplot2)
library(tsibble)
library(feasts)
library(readr)

# Cargamos los datos 

isciii <- read_csv("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv")

shinyServer(function(input, output) {
  
    output$plot2 <- renderPlot({
      
      # series temporales

      olas_covid <- isciii %>%
        filter(grupo_edad == input$edad &
                 fecha >= input$dateRange[1] &
                 fecha < input$dateRange[2]) %>%
        group_by(sexo, fecha) %>%
        summarise(total_contagiados = sum(num_casos),
                  total_hospitalizados = sum(num_hosp),
                  total_uci = sum(num_uci),
                  total_fallecidos = sum(num_def)) %>%
        as_tsibble(key = c(sexo),
                   index = fecha)
      
        autoplot(olas_covid, 
                 get(input$y2),
                 colour = "grey90") + geom_smooth(method = "loess", span = 0.05)
        })

})

