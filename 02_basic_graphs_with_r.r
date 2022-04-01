# master UNED visualizacion avanzada
# Tema 2 R-base ejemplos de visualización 

# Usaremos este conjunto de datos del paquete base

setwd("/home/pedro/Escritorio/UNED_2022/uned_master_big_data")

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
attach(mtcars)
?plot
plot(tons, 
     litperkm, 
     main = "Ejemplo gráfico de dispersión",
     xlab = "Peso del vehiculo (toneladas) ", 
     ylab = "Consumo (lit por km)", 
     pch = 17)


# Incluimos regresion lineal y lowess
abline(lm(litperkm ~ tons), 
       col="red") # regression line (y~x)
lines(lowess(tons, litperkm), 
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


# El paquete lattice proporciona las opciones para condicionar la matriz de graficos en un factor

# install.packages("lattice") ## no es necesario desde RSTudio
library(lattice)
?splom

splom(mtcars[c("litperkm",
               "disp",
               "drat",
               "tons")], 
      groups = cyl, 
      data = mtcars,
      panel = panel.superpose,
      auto.key = T)



# Scatterplot Matrices from the car Package

?scatterplotMatrix

scatterplotMatrix( ~ litperkm + disp + drat + tons | cyl, 
                    data = mtcars,
                    main = "Matriz de grafs dispersion por n cilindros")


# Scatterplot Matrices from the glus Package

install.packages("gclus")
library(gclus)
dta <- mtcars[c("litperkm",
                "disp",
                "drat",
                "tons")] # extraemos los datos de las columnas del dataset
dta.r <- abs(cor(dta)) # calculamos correlaciones (valor absoluto)
dta.col <- dmat.color(dta.r) # obtenemos colores mediante funcion dmat.color especifica

# reordenamos variables de tal modo que las que tienen corr mas alta
# esten mas cerca de la diagonal
dta.o <- order.single(dta.r)
cpairs(dta, 
       dta.o, 
       panel.colors = dta.col, 
       gap = .5,
       main = "Variables ordenadas y coloreadas por la correlacion" )


# Cuando hay muchos puntos de datos y una superposicion significativa
# los graficos bivariantes o de dispersion son menos utiles.

# Hay varias estrategias cuando esto ocurre.
# Una es utilizar la funcion hexbin(x, y), que encapsula en hexagonos conjuntos de puntos
# Necesaria la libreria hexbin

install.packages("hexbin")
library(hexbin)
x <- rnorm(1000) # Generamos una distribucion normal de mil puntos, aleatoria
y <- rnorm(1000) # Y otra mas
bin <- hexbin(x, y, xbins=50)
plot(bin, main="Hexagonal Binning")


# Tabmien puedes utilizar transparencia de color 
# para mejor mostrar esta superposicion de puntos

x <- rnorm(1000)
y <- rnorm(1000)
plot(x, y, 
     main = "PDF Scatterplot Example", 
     col = rgb(0, 100, 0, 50, maxColorValue = 255), 
     pch=16)


# Podemos crear graficos 3D aunque francamente no sean muy aconsejables asi en general
# La libreria scatterplot3d permite hacerlo con mucha facilidad

install.packages("scatterplot3d")
library(scatterplot3d)
attach(mtcars)
scatterplot3d(tons, 
              disp, 
              litperkm, 
              main = "3D Scatterplot")


# 3D Scatterplot con plano de regresion
library(scatterplot3d)
attach(mtcars)
s3d <- scatterplot3d(tons, 
                     disp, 
                     litperkm, 
                     pch = 16, 
                     highlight.3d = TRUE,
                     type = "h", 
                     main = "3D Scatterplot")
fit <- lm(litperkm ~ tons + disp)  # Calculamos el plano de regresion
s3d$plane3d(fit) # Lo adjuntamos al objeto de grafico bivariante

# Grafico 3D interactivo con el paquete rgl

install.packages("rgl")
library(rgl)

plot3d(tons, 
       disp, 
       litperkm, 
       col="red", 
       size=3)


# Y algo similar se puede conseguir con scatter3d(x, y, z) en Rcmdr

#install.packages("Rcmdr")  # no es necesario desde dentro de RStudio
#library(Rcmdr)
attach(mtcars)
scatter3d(wt, disp, mpg) 

# Guardamos el objeto para futuro uso

save(mtcars, file ="mtcars.rda")
getwd()
