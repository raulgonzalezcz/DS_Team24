#NOS ASEGURAMOS DE ESTAR EN EL DIRECTORIO CORRECTO
getwd()
setwd("C:/Users/mgarc/OneDrive/Escritorio/9no Semestre/Bedu_Modulo_II/Sesion_5/")

#DESCARGAMOS EL ARCHIVO prouction.txt
url1 <- "https://raw.githubusercontent.com/beduExpert/Programacion-con-R-Santander/master/Sesion-05/Ejemplo-01/production.txt"
download.file(url1, destfile = "production.txt")
production <- read.table("production.txt", header = TRUE)
attach(production)
################################################################################
#EJEMPLO1: REGRES�ON LINEAL SIMPLE
################################################################################
#Hacemos el gr�fico de dispersi�n
plot(RunSize,RunTime, xlab = "Tama�o de la ejecuci�n",
     ylab = "Tiempo de ejecuci�n",
     pch = 16)

#Ajustamos un modelos de regresi�n lineal simple
m1 <- lm(RunTime~RunSize)
summary(m1)

#Graficamos los datos con la recta de regresi�n estimada
plot(RunSize, RunTime, xlab = "Tama�o de ejecuci�n", 
     ylab = "Tiempo de ejecuci�n", pch = 16)
abline(lsfit(RunSize, RunTime)) # Trazamos la recta de regresi�n estimada
mtext(expression(paste('Modelo de regresi�n lineal simple:',
                       ' ',
                       y[i] == beta[0] + beta[1]*x[i] + e[i])),
      side = 3, adj=1, font = 2)

# Recta de regresi�n poblacional

text(x = 200, y = 240, expression(paste('Recta de regresi�n:',
                                        ' ',
                                        y[i] == beta[0] + beta[1]*x[i])),
     adj = 1, font = 2)


# Recta de regresi�n estimada

text(x = 350, y = 180, expression(paste('Recta estimada:',
                                        ' ',
                                        hat(y)[i] == hat(beta)[0] + hat(beta)[1]*x[i])),
     adj = 1, font = 2)

# Recta de regresi�n estimada

text(x = 350, y = 160, expression(paste('Recta estimada:',
                                        ' ',
                                        hat(y)[i] == 149.74770 + 0.25924*x[i])),
     adj = 1, font = 2)

# Residuales

points(189, 215, pch=16, col = "red") # Punto muestral
149.74770 + 0.25924 * 189 # Valor y sobre la recta estimada
lines(c(189, 189), c(198.7441, 215), col = "red")

points(173, 166, pch=16, col = "red") # Punto muestral
149.74770 + 0.25924 * 173 # Valor y sobre la recta estimada
lines(c(173, 173), c(166, 194.5962), col = "red")

#Creamos un intervalo de confianza alrededor de nuestro ajuste lineal
confint(m1, level = 0.95)

#Encontramos intervalos de confienza al 95% para la recta de regresi�n poblacional
RunSize0 <- c(50,100,150,200,250,300,350) # Algunos posibles valores de RunSize

(conf <- predict(m1, newdata = 
                   data.frame(RunSize = RunSize0), 
                 interval = "confidence", level = 0.95))

# Podemos visualizar gr�ficamente estos intervalos de confianza

lines(RunSize0, conf[, 2], lty = 2, lwd = 2, col = "green") # l�mites inferiores
lines(RunSize0, conf[, 3], lty = 2, lwd = 2, col = "green") # l�mites superiores

# Podemos cear tambi�n intervalos de pron�stico
pred <- predict(m1, newdata = data.frame(RunSize = RunSize0),interval = "prediction", level = 0.95)
lines(RunSize0, pred[,2], lty = 2, lwd = 2, col = "blue")
lines(RunSize0, pred[,3], lty = 2, lwd = 2, col = "blue")

################################################################################
#EJEMPLO 2: REGRESI�N LINEAL M�LTIPLE
################################################################################
url2 <- "https://raw.githubusercontent.com/beduExpert/Programacion-con-R-Santander/master/Sesion-05/Ejemplo-02/nyc.csv"
nyc  <- read.csv(url2, header = TRUE)
attach(nyc)
#Ajustamos el modelo de regresi�n lineal m�ltiple
m1 <- lm(Price ~ Food + Decor + Service + East)
summary(m1)

m2 <- lm(Price ~ Food + Decor + East)
summary(m2)

#An�lisis de convarianza
mfull <- lm(Price ~ Food + Decor + Service + East + 
              Food:East + Decor:East + Service:East)
summary(mfull)
anova(m2,mfull)
pairs(~ Food + Decor + Service, data = nyc, gap = 0.4, cex.labels = 1.5)

#A continuaci�n veremos graficas de residuales estadarizados
m1 <- lm(Price ~ Food + Decor + Service + East)
summary(m1)
StanRes1 <- rstandard(m1)
par(mfrow = c(2, 2))
plot(Food, StanRes1, ylab = "Residuales Estandarizados")
plot(Decor, StanRes1, ylab = "Residuales Estandarizados")
plot(Service, StanRes1, ylab = "Residuales Estandarizados")
plot(East, StanRes1, ylab = "Residuales Estandarizados")
dev.off()

#Finalmente mostramos una gr�fica de Y, el precio contr los valores ajustados
plot(m1$fitted.values, Price, xlab = "Valores ajustados", ylab = "Price")
abline(lsfit(m1$fitted.values, Price))

################################################################################
#EJEMPLO 3: M�QUINAS DE VECTORES DE SOPORTE
################################################################################
download.packages("ISLR")
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(e1071)))
suppressMessages(suppressWarnings(library(ggplot2)))
suppressMessages(suppressWarnings(library(ISLR)))
