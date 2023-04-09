# Ejemplo de mapas básicos con ggplot2 
# Intro. a choropleths para master UNED big data

# asegúrate de cambiar tu directorio de trabajo (donde has descargado todo el repo.)

setwd("/home/pedro/Escritorio/UNED_2023/UNED_master_visualizacion-main")

# si no tienes instalado el paquete "sp" instálalo
#install.packages("sp")
library(sp)
library(lattice)
library(ggplot2)
library(RColorBrewer)

# Forma básica de España
espania <- readRDS(file = "ESP_adm0.rds")
plot(espania)

# España con comunidades (nivel 1 administrativo)
espania <- readRDS(file = "ESP_adm1.rds")
plot(espania)

# España con provincias (nivel 2 administrativo)
espania <- readRDS(file = "ESP_adm2.rds")
plot(espania)

# Queremos comunidad autónoma Andalucía
andalucia <- espania[espania$NAME_1=="Andalucía",]
plot(andalucia)

# Dibujar un mapa básico con escalas de color
# A partir de los mapas de José Luis Cañadas:
# http://rpubs.com/joscani/mapa_paro_andalucia

# Con cambios en escalas de color a partir de taller de color de grupo R madrid:
# https://github.com/pedroconcejero/taller-color/blob/master/taller_color_def_grupo_madrid.rmd

githubURL1 <- "https://github.com/pedroconcejero/UNED_master_visualizacion/blob/main/tasas_paro_andalucia.rda?raw=true"

load(url(githubURL1))

str(tasa.paro.and.provincial)

table(tasa.paro.and.provincial$gedad)

levels(tasa.paro.and.provincial$prov)

table(tasa.paro.and.provincial$prov)
# la función fortify -de ggplot2- permite pasar el objeto andalucia
# propio de la librería sp
# a data.frame que ya puede utilizar ggplot2
and.data.frame <- fortify(andalucia)

# Problema es que los datos los tenemos como dos primeros dígitos código postal
# y en mapa tenemos un código de 1 a 8

and.data.frame$id[and.data.frame$id == 1] <- "04"
and.data.frame$id[and.data.frame$id == 2] <- "11"
and.data.frame$id[and.data.frame$id == 3] <- "14"
and.data.frame$id[and.data.frame$id == 4] <- "18"
and.data.frame$id[and.data.frame$id == 5] <- "21"
and.data.frame$id[and.data.frame$id == 6] <- "23"
and.data.frame$id[and.data.frame$id == 7] <- "29"
and.data.frame$id[and.data.frame$id == 8] <- "41"

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat)



#######################################
# añadimos facetas -separamos por grupo de edad y nivel de formación

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)

#######################################
# cambiamos la escala de color para que más intenso sea más paro

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701")

#######################################
# Quitamos las coordenadas de x e y (longitud y latitud)

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701") + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) 

#######################################
# añadimos título, etiquetas de ejes y leyenda

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = paro), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3)  + 
  scale_fill_gradient(low = "#FDECDD", 
                      high = "#D94701") + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", size = rel(1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")


# Mejoramos el mapa con etiquetas para los niveles
# para dar significado a los colores
# ver la capa "scale_fill_manual"


ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, 
               fill = intervalos), 
           map = and.data.frame, 
           colour = "black") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3) + 
  scale_fill_manual(values = c("#FDEBDD", 
                               "#F9C9AD",
                               "#E1885F", 
                               "#D34400"), 
                    labels = c("Menos del 20%", 
                               "[20% - 40%)", 
                               "[40% - 60%)", 
                               "[60% - 80%]")) + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", 
                                  size = rel(1.1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")


# Mapa con tasa de paro con alguna mejora
# - optimización de colores de líneas y fondo
# - incremento de categorías
# - uso de una escala divergente

cols <- brewer.pal(8,"PiYG")

ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, fill = intervalosfinos), 
           map = and.data.frame, 
           colour = "cadetblue1") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3) + 
  scale_fill_manual(values = rev(cols),  
                    labels = c("<10", 
                               "10-20", 
                               "20-30", 
                               "30-40",
                               "40-50",
                               "50-60",
                               "60-70",
                               "70-80")) + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", 
                                  size = rel(1.1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")

################
# POR QUÉ ES IMPORTANTE CONSIDERAR LA CEGUERA AL COLOR
# dichromat es una librería que incorpora funciones que cambian las distinciones de color azul-verde a aproximadamente los efectos de las dos formas más comunes de ceguera a color: protanopia y deuteranopia.
# Un ejemplo de heatmap.

library(dichromat)

par(mfcol=c(1, 2))
N <- 20
pie(rep(1, N),
    col = heat.colors(N))

# Cómo lo vería una persona con deuteranopia:
  
pie(rep(1, N),
    col = dichromat(heat.colors(N), type = "deutan"))

# Y con protanopia

pie(rep(1, N),
    col = dichromat(heat.colors(N), type = "tritan"))


# Veamos la simulación de nuestro último mapa para una persona con deuteranopia 
# (y aprovechamos para variar el color de las líneas de separación):
  
ggplot(tasa.paro.and.provincial) + 
  geom_map(aes(map_id = cod_prov, fill = intervalosfinos), 
           map = and.data.frame, 
           colour = "yellow") + 
  expand_limits(x = and.data.frame$long, 
                y = and.data.frame$lat) + 
  facet_grid(gedad ~ nforma3) + 
  scale_fill_manual(values = dichromat(rev(cols), type = "tritan"),  
                    labels = c("<10", 
                               "10-20", 
                               "20-30", 
                               "30-40",
                               "40-50",
                               "50-60",
                               "60-70",
                               "70-80")) + 
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) + 
  theme(axis.text.y = element_blank(), 
        axis.text.x = element_blank(), 
        plot.title = element_text(face = "bold", 
                                  size = rel(1.4)), 
        legend.text = element_text(size = rel(1.1)), 
        strip.text = element_text(face = "bold", 
                                  size = rel(1.1))) + 
  labs(list(x = "", y = "", fill = "")) + 
  ggtitle("Tasa de paro\npor edad y estudios")

