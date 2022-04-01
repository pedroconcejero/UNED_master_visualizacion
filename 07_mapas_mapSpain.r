# Master Big Data UCM -presencial 2022-
# Script para probar librería mapSpain
# Siguiendo la documentación del autor según nos lo explicó en R-madrid
# https://github.com/dieghernan/rpubs
# Doc oficial CRAN aquí:
# https://cran.r-project.org/web/packages/mapSpain/index.html
# https://ropenspain.github.io/mapSpain/

# install.packages("mapSpain", dependencies = TRUE)
# install.packages("raster", dependencies = TRUE)
# install.packages("ggspatial", dependencies = TRUE)

library(mapSpain)
library(tidyverse)
library(ggspatial)
library(ggplot2)
library(raster)
library(leaflet)

## Un ejemplo rápido

  
galicia <- esp_get_munic_siane(region = "Galicia") %>%
      # Homogeinizo labels
      mutate(
        Provincia = esp_dict_translate(ine.prov.name, "es")
      )

euskadi <- esp_get_munic_siane(region = "Euskadi") %>%
  # Homogeinizo labels
  mutate(
    Provincia = esp_dict_translate(ine.prov.name, "es")
  )

?esp_get_munic_siane    

ggplot(galicia) +
      geom_sf(aes(fill = Provincia),
              color = "grey70"
      ) +
      labs(title = "Provincias de Galicia") +
      scale_fill_discrete(
        type =
          hcl.colors(4, "PiYG")
      ) +
      theme_bw()

N <- 4
pie(rep(1, N),
    col = hcl.colors(N, "PiYG"))

#Si exploramos el dataset:

# install.packages("reactable")
library(reactable)

reactable(galicia,
          searchable = TRUE, striped = TRUE,
          filterable = TRUE, height = 350
)


## Almacenamiento

# **mapSpain** es un paquete API que usa recursos web. El comportamiento por 
# defecto consiste en descargar archivos al directorio temporal `tempdir()` para
# su uso posterior durante la sesión.

# La función `esp_set_cache_dir()` permite modificar este comportamiento, 
# estableciendo un directorio de descarga específico para el usuario. Para hacer
# esta configuración persistente se puede emplear el parámetro `install = TRUE`


esp_set_cache_dir("~/R/mapslib/mapSpain", 
                  install = TRUE, 
                  verbose = TRUE,
                  overwrite = TRUE)

# mapSpain cache dir is: /home/pedro/R/mapslib/mapSpain

munic <- esp_get_munic_siane(verbose = TRUE)


## Funciones para trabajar con strings

# **mapSpain** proporciona dos funciones relacionadas para trabajar con textos
# y códigos:
  
#  -  `esp_dict_region_code()` convierte textos en códigos de CCAA y provincias.
# Esquemas de codificación soportados:
# - ISO2
# - NUTS
# - INE (codauto y cpro)

#  `esp_dict_translate()` traduce textos a diferentes idiomas:
# - Castellano
# - Inglés
# - Catalán
# - Gallego
# - Vasco

# Estas funciones pueden ser de utilidad en ámbitos más amplios que necesiten
# homogeneizar códigos de CCAA y Provincias (Datos COVID ISCII, etc).

vals <- c("Errioxa", "Coruna", "Gerona", "Madrid")

esp_dict_region_code(vals, destination = "nuts")
esp_dict_region_code(vals, destination = "cpro")
esp_dict_region_code(vals, destination = "iso2")

# Desde ISO a otros códigos

iso2vals <- c("ES-M", "ES-S", "ES-SG")
esp_dict_region_code(iso2vals, origin = "iso2")


iso2vals <- c("ES-GA", "ES-CT", "ES-PV")

esp_dict_region_code(iso2vals,
                     origin = "iso2",
                     destination = "nuts"
)

# Soporta diferentes niveles
valsmix <- c("Centro", "Andalucia", "Seville", "Menorca")
esp_dict_region_code(valsmix, destination = "nuts")

esp_dict_region_code(c("Murcia", "Las Palmas", "Aragón"),
                     destination = "iso2"
)


### `esp_dict_translate()`

vals <- c(
  "La Rioja", "Sevilla", "Madrid",
  "Jaen", "Orense", "Baleares"
)

esp_dict_translate(vals, lang = "en")
esp_dict_translate(vals, lang = "es")
esp_dict_translate(vals, lang = "ca")

vals <- c(
  "La Rioja", "Sevilla", "Madrid",
  "Jaen", "Orense", "Baleares"
)

esp_dict_translate(vals, lang = "eu")
esp_dict_translate(vals, lang = "ga")

## Límites políticos

# **mapSpain** contiene un set de funciones que permiten obtener límites
# políticos a diferentes niveles:
  
#  - Todo el país
# - [NUTS](https://ec.europa.eu/eurostat/web/nuts/background) (Eurostat):
#   Clasificación estadística de Eurostat. Niveles 0 (país), 1, 2 (CCAA) y 3.
# - CCAA
# - Provincias
# - Municipios

# Para CCAA, Provinicas y Municipios hay dos versiones: 
# `esp_get_xxxx()` (fuente:GISCO) y 
# `esp_get_xxxx_siane()` (fuente: IGN).

# La información se proporciona en diferentes proyecciones y niveles de 
# resolución.

esp <- esp_get_country(moveCAN = TRUE)

ggplot(esp) +
  geom_sf(fill = "#f9cd94") +
  theme_light()

### El caso Canarias

# Por defecto, **mapSpain** "desplaza" Canarias para una mejor visualización en 
# la mayoría de sus funciones. Este comportamiento se puede desactivar usando 
# `moveCAN = FALSE`(ver anterior ejemplo).

esp <- esp_get_country(moveCAN = T)

ggplot(esp) +
  geom_sf(fill = "#f9cd94") +
  theme_light()

# Proporcionamos funciones adicionales que permiten representar lineas
# alrededor de la inserción del mapa 
# ([ejemplos](https://ropenspain.github.io/mapSpain/reference/esp_get_can_box.html#examples)).
                                               
Provs <- esp_get_prov()
Box <- esp_get_can_box()
Line <- esp_get_can_provinces()

ggplot(Provs) +
  geom_sf() +
  geom_sf(data = Box) +
  geom_sf(data = Line) +
  theme_linedraw()

# Nota importante del autor:
# **Cuando se trabaja con imágenes, mapas interactivos o se desean 
# realizar analisis espaciales, se debe usar `moveCAN = FALSE`**

### NUTS

# NUTS-1 -Baja Resolución
nuts2 <- esp_get_nuts(resolution = 01, 
                      epsg = 3035, 
                      nuts_level = 2,
                      moveCAN = T)
  
ggplot(nuts2) +
    geom_sf() +
    theme_linedraw() +
    labs(title = "NUTS2: Alta Resolución")

# NUTS-2 -Alta Resolución
nuts2 <- esp_get_nuts(resolution = 01, 
                      epsg = 3035, 
                      nuts_level = 2)

ggplot(nuts2) +
  geom_sf() +
  theme_linedraw() +
  labs(title = "NUTS2: Alta Resolución")

# Baleares NUTS3
nuts3_baleares <- c("ES531", "ES532", "ES533")
paste(esp_dict_region_code(nuts3_baleares, "nuts"), collapse = ", ")

nuts3_sf <- esp_get_nuts(region = nuts3_baleares)

ggplot(nuts3_sf) +
  geom_sf(aes(fill = NAME_LATN)) +
  labs(fill = "Baleares: NUTS3") +
  scale_fill_viridis_d() +
  theme_minimal()

## CCAA

ccaa <- esp_get_ccaa(ccaa = c(
    "Catalunya",
    "Comunidad Valenciana",
    "Aragón",
    "Baleares"
  ))
  
ccaa <- ccaa %>% mutate(
    ccaa_cat = esp_dict_translate(ccaa$ine.ccaa.name, "ca")
  )
  
ggplot(ccaa) +
    geom_sf(aes(fill = ccaa_cat)) +
    labs(fill = "Comunitats autònomes") +
    theme_minimal() +
    scale_fill_discrete(type = hcl.colors(4, "Plasma"))

## Provincias (usando versión `*_siane`)

# Si pasamos una entidad de orden superior (e.g. Andalucia) obtenemos todas las 
# provincias de esa entidad.

provs <- esp_get_prov_siane(c(
  "Andalucía", "Ciudad Real",
  "Murcia", "Ceuta", "Melilla"
))

ggplot(provs) +
  geom_sf(aes(fill = prov.shortname.es),
          alpha = 0.9
  ) +
  scale_fill_discrete(type = hcl.colors(12, "Cividis")) +
  theme_minimal() +
  labs(fill = "Provincias")

colores_mapa_andalucia_y_mas <- c('#8dd3c7', #Almería
                                  '#ffffb3', #Cádiz
                                  '#FF1493', #Ceuta
                                  '#bebada', #Ciudad Real
                                  '#fb8072', #Córdoba
                                  '#80b1d3', #Granada
                                  '#fdb462', #Huelva
                                  '#b3de69', #Jaén
                                  '#fccde5', #Málaga
                                  '#FF1493', #Melilla
                                  '#d9d9d9', #Murcia
                                  '#bc80bd'  #Sevilla
)

ggplot(provs) +
  geom_sf(aes(fill = prov.shortname.es),
          alpha = 0.9
  ) +
  scale_fill_discrete(type = colores_mapa_andalucia_y_mas) +
  theme_minimal() +
  labs(fill = "Provincias")


## Municipios

munic <- esp_get_munic(region = "Barcelona") %>%
    # Datos de ejemplo: Población INE
    left_join(mapSpain::pobmun19, by = c("cpro", "cmun"))
  
ggplot(munic) +
    geom_sf(aes(fill = pob19), 
            alpha = 0.9, 
            color = NA) +
    scale_fill_gradientn(
      colors = hcl.colors(100, "Inferno"),
      n.breaks = 10,
      labels = scales::label_comma(),
      guide = guide_legend()
    ) +
    labs(
      fill = "Habitantes",
      title = "Población en Segovia",
      subtitle = "Datos INE (2019)"
    ) +
    theme_void() +
    theme(
      plot.background = element_rect("grey80"),
      text = element_text(face = "bold"),
      plot.title = element_text(hjust = .5),
      plot.subtitle = element_text(hjust = .5)
    )

## Hexbin maps

# Disponibles como cuadrados y hexágonos, para provincias y CCAA.

cuad <- esp_get_grid_prov()

ggplot(cuad) +
    geom_sf() +
    geom_sf_text(aes(label = iso2.prov.code)) +
    theme_void()
  
hex <- esp_get_hex_ccaa()

ggplot(hex) +
    geom_sf() +
    geom_sf_text(aes(label = iso2.ccaa.code)) +
    theme_void()


## Imágenes

# **mapSpain** permite usar también imágenes de mapas 
# (satélite, mapas base, carreteras, etc.) proporcionados por diferentes organismos públicos 
# (<https://www.idee.es/web/idee/segun-tipo-de-servicio>).

# Las imágenes se pueden emplear para la creación de mapas estáticos 
# (imágenes obtenidas como capas ráster de 3 o 4 bandas) o como fondo de mapas dinámicos,
# a través del paquete `leaflet`.

# Los proveedores se han extraido del plugin para leaflet 
# [leaflet-providerESP](https://dieghernan.github.io/leaflet-providersESP/visor/).

### Creación de mapas estáticos

# Tenemos varias opciones que podemos emplear para componer mapas base:
  
madrid_munis <- esp_get_munic_siane(region = "Madrid")
base_pnoa <- esp_getTiles(madrid_munis, 
                          "PNOA", 
                          bbox_expand = 0.1, 
                          zoommin = 1)

ggplot() +
  layer_spatraster(base_pnoa) +
  geom_sf(
    data = madrid_munis, color = "blue", fill = "blue",
    alpha = 0.25, lwd = 0.5
  ) +
  theme_minimal() +
  labs(title = "Municipios en Madrid")


### Mapas dinámicos usando mapSpain

# Estas capas se pueden usar también como fondo en mapas estáticos

stations <- esp_get_railway(spatialtype = "point", epsg = 4326)


leaflet(stations) %>%
  addProviderEspTiles("IGNBase.Gris", group = "Base") %>%
  addProviderEspTiles("MTN", group = "MTN") %>%
  addProviderEspTiles("RedTransporte.Ferroviario", group = "Lineas Ferroviarias") %>%
  addMarkers(group = "Estaciones",
             popup = sprintf(
               "<strong>%s</strong>",
               stations$rotulo) %>%
               lapply(htmltools::HTML)
  ) %>%
  addLayersControl(
    baseGroups = c("Base", "MTN"),
    overlayGroups = c("Lineas Ferroviarias", "Estaciones"),
    options = layersControlOptions(collapsed = FALSE)
  )

