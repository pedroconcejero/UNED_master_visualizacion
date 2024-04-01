# Master Big Data UNED 2024
# Datos vehículos UK 2017

setwd("/home/pedro/Escritorio/UNED_2024/UNED_master_visualizacion_main")

library(ggplot2)

list.files()

load("datos_4510_vehiculos_2016.rda")

summary(datos)

barplot(table(datos$FuelType))
barplot(table(datos$Tipo))

tipos_permitidos <- c("Diesel",
                      "Gasolina",
                      "Híbrido")

datos_def <- datos[datos$Tipo %in% tipos_permitidos, ]

summary(datos_def)
barplot(table(datos_def$Tipo))

plot(datos_def$EngineCapacity,
     datos_def$MetricCombined)

boxplot(datos_def$CO2gkm ~ datos_def$Tipo)
