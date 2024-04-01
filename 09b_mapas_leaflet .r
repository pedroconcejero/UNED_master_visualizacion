# Mapas con leaflet en R
# para master big data UNED
# visualización avanzada

# Inspirado en:
# https://rpubs.com/albtorval/595824
# y en el tutorial leaflet de RStudio:
# https://rstudio.github.io/leaflet/

if (!"leaflet" %in% installed.packages()) install.packages("leaflet")
library(leaflet)

# Markers

# Use markers to call out points on the map. 
# Marker locations are expressed in 
# latitude/longitude coordinates, 
# and can either appear as icons or as circles.
# 40.451487512414616, -3.737671385135911

my_map <- leaflet() %>% 
  addTiles() %>%
  addMarkers(lat=40.451487512414616, lng=-3.737671385135911, 
             popup="Sede UNED")
my_map


# Mapas de España con Leaflet

lat_espania <- 40.416775
long_espania <- -3.703790

# https://www.antipodas.net/coordenadaspais/espana/andalucia.php

lat_andalucia <- 37.6000000
long_andalucia <- -4.5000000

# Mapa de España

m <- leaflet() %>% 
  setView(lat = lat_espania,  
          lng = long_espania, 
          zoom = 6)

m %>% addTiles()

# addProviderTiles()

# Los "tiles" de Stamen han cambiado y ahora requieren registro 
# y pasar las claves a una API. Podéis ver cómo era en el vídeo
# Pero no funcionará lo siguiente (lo he comentado por eso)
#m %>% addProviderTiles(providers$Stamen.Toner)
# https://docs.stadiamaps.com/guides/migrating-from-stamen-map-tiles/

m %>% addProviderTiles(providers$CartoDB.Positron)

m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)


# A partir de los polígonos que hemos manejado en script
# 05_mapas_paro.r

leaflet(data = espania) %>% 
  addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), 
              stroke = FALSE)

leaflet(data = andalucia) %>% 
  addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), 
              stroke = FALSE)

# Choropleths in R + Leaflet
# Following 
# https://rstudio.github.io/leaflet/choropleths.html

m <- leaflet(andalucia) %>%
  setView(long_andalucia, 
          lat_andalucia, 
          6) %>%
  addTiles()

m

#####
# El proceso de generación de la escala de color es un poco más manual
# Para limitar la complejidad del dibujo vamos a escoger solo el grupo de edad
# y rango de estudios más afectado por paro

tasa.paro.reducida <- tasa.paro.and.provincial[tasa.paro.and.provincial$gedad == "De 16 a 34 años" &
                                                 tasa.paro.and.provincial$nforma3 == "sin estudios y primaria", ]

tasa.paro.reducida$intervalos_num <- 
  as.numeric(tasa.paro.reducida$intervalosfinos) * -1

mybins <- c(seq(-1, -8, -1))
mybins

mypalette <- colorBin(palette = "PiYG",
                      domain = tasa.paro.reducida$intervalos_num,
                      bins = mybins)

m %>% addPolygons(fillColor = ~mypalette(tasa.paro.reducida$intervalos_num), 
                  stroke = TRUE,
                  fillOpacity = 1)

###
# con otro proveedor de "Tiles"

m <- leaflet(andalucia) %>%
  setView(long_andalucia, 
          lat_andalucia, 
          7) %>%
  addProviderTiles(providers$CartoDB.Positron)

m

m %>% addPolygons(fillColor = ~mypalette(tasa.paro.reducida$intervalos_num), 
                  stroke = TRUE,
                  fillOpacity = .5)

# Añadimos "tooltips"

# Prepare the text for tooltips:
mytext <- paste(
  "Provincia: ", tasa.paro.reducida$prov,"<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

m %>% addPolygons(fillColor = ~mypalette(tasa.paro.reducida$intervalos_num), 
                  stroke = TRUE,
                  fillOpacity = .5,
                  label = mytext,
                  labelOptions = labelOptions( 
                    style = list("font-weight" = "normal", padding = "3px 8px"), 
                    textsize = "13px", 
                    direction = "auto"
                  ))

# Include additional text for tooltips:
mytext <- paste(
  "Provincia: ", tasa.paro.reducida$prov,"<br/>", 
  "Tasa de Paro (menores de 35, sin estudios): ", 
  paste(round(tasa.paro.reducida$paro, 2) * 100, "%"),"<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

m %>% addPolygons(fillColor = ~mypalette(tasa.paro.reducida$intervalos_num), 
                  stroke = TRUE,
                  fillOpacity = .7,
                  label = mytext,
                  labelOptions = labelOptions( 
                    style = list("font-weight" = "normal", padding = "3px 8px"), 
                    textsize = "13px", 
                    direction = "auto"
                  ))

