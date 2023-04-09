# master UNED visualizacion avanzada
# Tema 4 shiny - Ejemplo 1: Datos 4500 vehículos UK 2016


library(shiny)
library(ggplot2)

# Cargamos los datos desde el repositorio github del módulo 

dataset <- get(load(url("https://github.com/pedroconcejero/UNED_master_visualizacion/raw/main/datos_4510_vehiculos_2016.rda")))

dataset <- dataset[dataset$Tipo != "Eléctrico", ]
dataset$Tipo <- droplevels(as.factor(dataset$Tipo))


shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    
    p <- ggplot(dataset, 
                aes_string(x=input$x, 
                           y=input$y)) + geom_point() 
    
    
    if (input$color != 'None')
      p <- p + aes_string(color=input$color)
    
    facets <- paste(input$facet_row, "~ .")
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
    if (input$lm)
      p <- p + geom_smooth(method='lm',formula=y~x, na.rm = T)
    if (input$smooth)
      p <- p + geom_smooth(method='loess',formula=y~x, na.rm = T)
    
    print(p)
    
  })

  
})
