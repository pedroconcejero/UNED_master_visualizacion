# master UNED visualizacion avanzada
# Tema 2 R-base ejemplos de visualización 

# Usaremos este conjunto de datos del paquete base

setwd("/home/pedro/Escritorio/UNED_2023/UNED_master_visualizacion-main")

summary(mtcars)
str(mtcars)
?mtcars
mtcars

plot(mtcars$disp, mtcars$mpg)

mtcars$cyl <- as.factor(mtcars$cyl)

boxplot(mtcars$mpg ~ mtcars$cyl)


# Convertimos consumo a litros por km
mtcars$litperkm <- 235.215 / mtcars$mpg

# Convertimos peso a kilos
mtcars$tons <- mtcars$wt * 0.4535923


plot(mtcars$disp, mtcars$litperkm)
boxplot(mtcars$litperkm ~ mtcars$cyl)

# Scatterplots
# A partir de los ejemplos fabulosos de esta pagina:
# http://www.statmethods.net/graphs/scatterplot.html 

# # Simple Scatterplot
?plot
plot(mtcars$tons, 
     mtcars$litperkm, 
     main = "Ejemplo gráfico de dispersión",
     xlab = "Peso del vehiculo (toneladas) ", 
     ylab = "Consumo (lit por km)", 
     pch = 10)


# Incluimos regresion lineal y lowess
abline(lm(litperkm ~ tons, 
          data = mtcars), 
       col="red") # regression line (y~x)
lines(lowess(mtcars$tons, mtcars$litperkm), 
      col="blue") # lowess line (x,y)


# La funcion scatterplot en el paquete car ofrece muchas funciones mejoradas,
# incluyendo lineas de ajuste, box plots marginales, condicionamiento en un factor
# e identificar puntos de forma interactiva. Todas estas caracteristicas son opcionales


# bivariado de mpg en funcion de peso condicionado a numero de cilindros

install.packages("car")
library(car)

scatterplot(litperkm ~ tons | cyl, 
            data = mtcars,
            xlab = "Peso (tons)", ylab="Consumo (lit por km)",
            main = "Grafico dispersion mejorado")

text(litperkm ~ tons, 
     labels=rownames(mtcars),
     data=mtcars, cex=0.6, font=2)


# MATRICES DE GRAFICOS DE DISPERSION
# Hay al menos 4 funciones para crear estas matrices de graficos
# esenciales para cualquier analista para observar las multiples relaciones entre variables

# Basic Scatterplot Matrix
pairs(~ litperkm + disp + drat + tons,
      data = mtcars,
      main = "Matriz de graficos bivariantes")



# Scatterplot Matrices from the car Package

?scatterplotMatrix

scatterplotMatrix( ~ litperkm + disp + drat + tons | cyl, 
                    data = mtcars,
                    main = "Matriz de grafs dispersion por n cilindros")



# Cuando hay muchos puntos de datos y una superposicion significativa
# los graficos bivariantes o de dispersion son menos utiles.

# Hay varias estrategias cuando esto ocurre.
# Una es utilizar la funcion hexbin(x, y), que encapsula en hexagonos conjuntos de puntos
# Necesaria la libreria hexbin

install.packages("hexbin")
library(hexbin)
x <- rnorm(1000) # Generamos una distribucion normal de mil puntos, aleatoria
y <- rnorm(1000) # Y otra mas
plot(x, y)

bin <- hexbin(x, y, xbins=50)
plot(bin, main="Hexagonal Binning")


# Tabmien puedes utilizar transparencia de color 
# para mejor mostrar esta superposicion de puntos

x <- rnorm(1000)
y <- rnorm(1000)
bin <- hexbin(x, y, xbins=50)
plot(x, y, 
     main = "PDF Scatterplot Example", 
     col = rgb(0, 100, 0, 50, maxColorValue = 255), 
     pch=16)


# Grafico 3D interactivo con el paquete rgl

install.packages("rgl")
library(rgl)

plot3d(mtcars$tons, 
       mtcars$disp, 
       mtcars$litperkm, 
       col="red", 
       size=3)


# Y algo similar se puede conseguir con scatter3d(x, y, z) en Rcmdr

#install.packages("Rcmdr")  # no es necesario desde dentro de RStudio
#library(Rcmdr)

scatter3d(mtcars$wt, 
          mtcars$disp, 
          mtcars$mpg) 

# Guardamos el objeto para futuro uso

save(mtcars, file ="mtcars.rda")
getwd()
