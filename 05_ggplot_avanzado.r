# ggplot avanzado
# Extensiones de ggplot
# Para Curso visualización avanzada master UNED 2022

# A partir de lista mantenida por RStudio:
# https://exts.ggplot2.tidyverse.org/gallery/

# Establece tu directorio de trabajo
setwd("/home/pedro/Escritorio/UNED_2023/UNED_master_visualizacion-main")

# 1 gganimate

if (!"gganimate" %in% installed.packages()) install.packages("gganimate")
if (!"gapminder" %in% installed.packages()) install.packages("gapminder")
if (!"av" %in% installed.packages()) install.packages("av")
if (!"gifski" %in% installed.packages()) install.packages("gifski")

library(gganimate)
library(gapminder)
library(gifski)



p <- ggplot(gapminder, aes(gdpPercap, 
                      lifeExp, 
                      size = pop, 
                      colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', 
       x = 'GDP per capita', 
       y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animate(p, renderer = file_renderer(dir = paste0(getwd(),'/animation/')))

animate(p, renderer = gifski_renderer(file = paste0(getwd(),'/gapminder_animation.gif')))

# Conviene devolver el output de gráficos a consola (RStudio)

dev.off()

# 2 ggrepel

# The easiest way to get ggrepel is to install it from CRAN:
install.packages("ggrepel")

# Ejemplo *sin* ggrepel

ggplot(mtcars, aes(wt, mpg, 
                   label = rownames(mtcars))) +
  geom_text() +
  geom_point(color = 'red') +
  theme_classic(base_size = 16)

# Ejemplo *con* ggrpel

library(ggrepel)
ggplot(mtcars, aes(wt, mpg, 
                   label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = 'red') +
  theme_classic(base_size = 16)

# 3 ggalluvial

install.packages("ggalluvial")

library(ggalluvial)
# Here is how to generate an alluvial plot representation 
# of the multi-dimensional categorical dataset of passengers on the Titanic:
  
titanic_wide <- data.frame(Titanic)
head(titanic_wide)

ggplot(data = titanic_wide,
       aes(axis1 = Class, axis2 = Sex, axis3 = Age,
           y = Freq)) +
  scale_x_discrete(limits = c("Class", "Sex", "Age"), 
                   expand = c(.2, .05)) +
  xlab("Demographic") +
  geom_alluvium(aes(fill = Survived)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  theme_minimal() +
  ggtitle("passengers on the maiden voyage of the Titanic",
          "stratified by demographics and survival")

ggplot(data = titanic_wide,
       aes(axis1 = Class, axis2 = Sex,
           y = Freq)) +
  scale_x_discrete(limits = c("Class", "Sex"), 
                   expand = c(.2, .05)) +
  xlab("Demographic") +
  geom_alluvium(aes(fill = Survived)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  theme_minimal() +
  ggtitle("passengers on the maiden voyage of the Titanic",
          "stratified by demographics and survival")


dev.off()

# 4 ggradar

if (!"devtools" %in% installed.packages()) install.packages("devtools")

devtools::install_github("ricardo-bion/ggradar", 
                         dependencies = TRUE)

library(ggradar)

library(dplyr)
library(scales)

# Gráfico básico. 
# Más opciones en
# https://r-charts.com/es/ranking/ggradar/


mtcars_radar <- mtcars %>% 
  select(-(cyl)) %>%
  as_tibble(rownames = "group") %>% 
  mutate_at(vars(-group), rescale) %>% 
  tail(4) %>% 
  select(1:10) 

ggradar(mtcars_radar)

# 5 ggmosaic

devtools::install_github("haleyjeppson/ggmosaic")

library(ggmosaic)

# Data from the results of a SurveyMonkey survey 
# commissioned by FiveThirtyEight 
# for the story 41 Percent of Fliers Say 
# It’s Rude To Recline Your Airplane Seat.

ggplot(data = fly) +
  geom_mosaic(aes(x = product(rude_to_recline), 
                  fill=do_you_recline)) +
  theme_mosaic()

# 6 Parliament plots (ggpol)

install.packages("ggpol")

library(ggpol)

# Datos Asamblea de Madrid
# https://es.wikipedia.org/wiki/Asamblea_de_Madrid

bt <- data.frame(
  parties = factor(c("PP", 
                     "PSOE", 
                     "Cs", 
                     "MasMadrid", 
                     "VOX", 
                     "UnidasPodemos"),
                   levels = c("PP", 
                              "PSOE", 
                              "Cs", 
                              "MasMadrid", 
                              "VOX", 
                              "UnidasPodemos")),
  seats   = c(30, 
              37, 
              21, 
              20, 
              12, 
              7),
  colors  = c("blue", 
              "red", 
              "orange", 
              "cyan", 
              "green", 
              "purple"),
  stringsAsFactors = FALSE)

ggplot(bt) + 
  geom_parliament(aes(seats = seats, 
                      fill = parties), 
                  color = "black") + 
  scale_fill_manual(values = bt$colors, 
                    labels = bt$parties) +
  coord_fixed() + 
  theme_void()

# Reordenamos dataframe para que salgan en orden dcha-izda

bt <- data.frame(
  parties = factor(c("VOX", 
                     "PP", 
                     "Cs", 
                     "PSOE", 
                     "MasMadrid", 
                     "UnidasPodemos"),
                   levels = c("VOX", 
                              "PP", 
                              "Cs", 
                              "PSOE", 
                              "MasMadrid", 
                              "UnidasPodemos")),
  seats   = c(12,
              30, 
              21, 
              37, 
              20, 
              7),
  colors  = c("green",
              "blue", 
              "orange", 
              "red", 
              "cyan", 
              "purple"),
  stringsAsFactors = FALSE)

ggplot(bt) + 
  geom_parliament(aes(seats = seats, 
                      fill = parties), 
                  color = "yellow") + 
  scale_fill_manual(values = bt$colors, 
                    labels = bt$parties) +
  coord_fixed() + 
  theme_void()

# 7 Time series plots

# This code comes from the excelent book
# Forecasting: Principles and Practice. 3rd. ed, 
# by Rob J. Hyndman and George Ahtanasopoulos, 
# from the Monash University in Australia.

# https://otexts.com/fpp3/

install.packages("fpp3")
library(fpp3)

# 1 Preparación de datos
# Adquisición de un medicamento anti-diabetes por día para varios años

PBS %>%
  filter(ATC2 == "A10") %>%
  select(Month, Concession, Type, Cost) %>%
  summarise(TotalC = sum(Cost)) %>%
  mutate(Cost = TotalC / 1e6) -> a10

# Time series plot

autoplot(a10, Cost) +
  labs(y = "$ (millions)",
       title = "Australian antidiabetic drug sales")

# Seasonal plot

a10 %>%
  gg_season(Cost, labels = "both") +
  labs(y = "$ (millions)",
       title = "Seasonal plot: Antidiabetic drug sales") +
  expand_limits(x = ymd(c("1972-12-28", "1973-12-04")))

# Seasonal subseries

a10 %>%
  gg_subseries(Cost) +
  labs(
    y = "$ (millions)",
    title = "Australian antidiabetic drug sales"
  )

# Función de autocorrelación

a10 %>%
  PACF(Cost, lag_max = 48) %>%
  autoplot() +
  labs(title="Australian antidiabetic drug sales")

