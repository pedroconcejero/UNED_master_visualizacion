# master UNED visualizacion avanzada
# Tema 4 shiny - Ejemplo 1: Datos 4500 vehículos UK 2016
# ui
# Basado en parte en el ejemplo de Joe Cheng
# https://gist.github.com/jcheng5/3239667

library(shiny)
library(ggplot2)

# Cargamos los datos desde el repositorio github del módulo 

dataset <- get(load(url("https://github.com/pedroconcejero/ucm_master_big_data/blob/master/datos_4510_vehiculos_2016.rda?raw=true")))

dataset <- dataset[dataset$Tipo != "Eléctrico", ]
dataset$Tipo <- droplevels(as.factor(dataset$Tipo))

# distinguimos variables "a nivel de intervalo" ("continuas" para ggplot)
nums <- sapply(dataset, is.numeric)
continuas <- names(dataset)[nums]

# y variables "categóricas" ("discretas" para ggplot)
cats <- sapply(dataset, is.character)
categoricas <- names(dataset)[cats]

shinyUI(
  navbarPage("Shiny Visualización Avanzada",
                   tabPanel("Descripción del trabajo",
                            mainPanel(
                              h1("Ejercicio Visualización Avanzada", align = "center"),
                              h2("Propuesto por Pedro Concejero", align = "center"),
                              p("Esta es mi propuesta como esqueleto para el ejercicio final del 
                                módulo de visualización avanzada."),
                              p("Es una app sencilla organizada en torno a pestañas con la función 
                                navbarPage."),
                              p("La primera pestaña (esta) describe el contenido y el autor."),
                              p("La segunda pestaña plantea un gráfico interactivo que explora
                                medidas de 4500 automóviles en venta en el mercado de Reino Unido en 2016"),
                              p(""),
                              p(""),
                              h2("¿Qué espero que incluyáis aquí?", align = "center"),
                              h3("Como mínimo"),
                              p("Conclusiones de vuestras exploraciones sobre las relaciones entre las 
                                variables propias del vehículo y los consumos, o contaminación, o
                                coste de uso de vehículo"),
                              p("Explicados de tal manera que sean reproducibles con el uso de la app."),
                              p("Por ejemplo: Si escogemos como predictor la cilindrada del motor y 
                                como predicha el consumo en litros por 100km podemos observar una relación
                                prácticamente lineal."),
                              p("Si además tenemos en cuenta el tipo de motor (diésel, gasolina, híbrido) 
                                podremos ver que la pendiente es muy similar. Eso sí, parece que los vecículos
                                con consumos más altos son los de gasolina."),
                              h3("Deseable pero no imprescindible"),
                              p("Algún gráfico adicional en pestaña Trabajo adicional"),
                              h2("¿Qué componentes se deben entregar?"),
                              h5("1. El código R (ui.R / server.R) -por separado o en un .zip"),
                              h5("2. La URL o dirección de shinyapps.io a la que se ha subido"),
                              h5("IMPORTANTE: Si usáis vuestros datos deben estar incluidos o accesibles en internet")
                            )),
                   tabPanel("Scatterplot consumo y más",
                            sidebarPanel(
                              
                              selectInput('x', 
                                          'Elige variable para eje X', 
                                          continuas, continuas[[1]]),
                              selectInput('y', 
                                          'Elige variable para eje Y', 
                                          continuas, continuas[[8]]),
                              selectInput('color', 
                                          'Pon el color que quieras', 
                                          c('None', 'Tipo')),
                              
                              checkboxInput('lm', 'Línea de Regresión'),
                              checkboxInput('smooth', 'Suavizado LOESS'),
 
                              selectInput('facet_row', 
                                          'Elige variable para facetas por filas', 
                                          c(None='.', 'Tipo'))
                            ),
                            
                            mainPanel(
                              plotOutput('plot',
                                         height=800)
                              
                            
                   ),
                   tabPanel("Trabajo adicional",
                            h1("¿Qué otros gráficos podéis plantear con estos datos?", align = "center"),
                            p("Podemos plantearnos en esta pestaña boxplot, mosaico, gráficos de balón...")
                   )
                   )
))

