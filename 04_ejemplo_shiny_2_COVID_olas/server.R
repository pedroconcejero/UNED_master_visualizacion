# master UNED visualizacion avanzada
# Tema 4 shiny - Ejemplo 2: Datos COVID


library(shiny)
library(ggplot2)
library(tsibble)
library(feasts)
library(readr)

# Cargamos los datos 

isciii <- read_csv("https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv")

fecha <- max(isciii$fecha)

cond <- {isciii$grupo_edad != "NC" &
    isciii$sexo != "NC" }

data_para_barplot <- isciii[cond, ] %>% 
  group_by(grupo_edad, sexo)   %>%
  summarise(total_contagiados = sum(num_casos),
          total_hospitalizados = sum(num_hosp),
          total_uci = sum(num_uci),
          total_fallecidos = sum(num_def)) 
  

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
                 colour = "grey90"
                 ) + geom_smooth(method = "loess", span = 0.05)
        })
    output$plot <- renderPlot({
      
      # dodged bar charts
      
      
      p <- ggplot(data_para_barplot)
      
      if (input$y == 'total_contagiados')
        p <- p + aes(grupo_edad, total_contagiados,
                     fill = as.factor(sexo))
      
      if (input$y == 'total_hospitalizados')
        p <- p + aes(grupo_edad, total_hospitalizados,
                     fill = as.factor(sexo))
      
      if (input$y == 'total_uci')
        p <- p + aes(grupo_edad, total_uci,
                     fill = as.factor(sexo))

      if (input$y == 'total_fallecidos')
        p <- p + aes(grupo_edad, total_fallecidos,
                     fill = as.factor(sexo))
      
      p <- p + geom_bar(position = "dodge",
                        stat = "identity") + coord_flip()
      
      title <- paste(input$y, 
                     "por COVID-19 en España",
                     "\n",
                     "entre",
                     min(isciii$fecha),
                     "y",
                     max(isciii$fecha))
      
      p <- p + ggtitle(paste(title, "\n", "por género"))
      
      print(p)
      
    })
    
})

