# plotly en R
# Para Curso visualización avanzada master UNED 2025

# treemap para plotly 

library(plotly)
library(treemapify)
library(ggplot2)
library(tidyverse)

load("datos_4510_vehiculos_2016.rda")

# Un boxplot

fig1 <- plot_ly(datos, 
               x = ~MetricCombined, 
               color = ~Tipo, 
               type = "box")

fig1

# Un scatterplot

fig2 <- plot_ly(datos, 
                x = ~EngineCapacity,
                y = ~MetricCombined, 
                color = ~Tipo, 
                type = "scatter")

fig2

# Data Labels on Hover


fig3 <- plot_ly(datos,
                x = ~EngineCapacity,
                y = ~MetricCombined, 
                color = ~Tipo, 
                type = "scatter", 
                # Hover text:
    text = ~paste("Manufacturer: ", Manufacturer, Tipo)
)

fig3

