# Autores : Brian David PeNa M , Sandra Lorena Cardona z.
# Pais    : Colombia.
# -------------------------------------
# Instalacion de packages
# install.packages("randomForest")
# install.packages("gmodels")
# install.packages("tree")
# carga de Librerias.
library(randomForest)
library(tree)
library(gmodels)
# ------------------------------------------------------------------------------------ARBOL DE REGRESION

# Inicializacion de semilla.
set.seed(1)
# Cargue de archivo .csv, sin variables Factor.
datos.cargados <- read.csv("/home/david/Documents/Laboratorio tree/hour.csv", stringsAsFactors = FALSE)

#Verificacion de estructura y estadisticas de la variable que contiene el archivo.
str(datos.cargados)
summary(datos.cargados)

# Creacion del cojunto de entrenamiento para usuarlo en el arbol
train <- sample(1:nrow(datos.cargados), nrow(datos.cargados)/2)
arbol.datos <- tree(cnt ~ . -dteday, datos.cargados[train, ]) 


# verificacion del detalle del arbol.
summary(arbol.datos)
# impresion en pantalla del arbol grafico.
plot(arbol.datos)
text(arbol.datos, pretty = 0)
# Cross-validation para buscar el mejor modelo y se muestra en pantalla
cv.datos <- cv.tree(arbol.datos, K = 10)
plot(cv.datos$size, cv.datos$dev, type = 'b')
# mejor modelo entrenado 
prune.datos <- prune.tree(arbol.datos, best = 9)
plot(prune.datos)
text(prune.datos, pretty = 0)

# Prediccion 
yhat <- predict(arbol.datos, newdata = datos.cargados[-train, ])
datos.test <- datos.cargados[-train, "cnt"]
plot(yhat, datos.test, main = "arbol sin podar")
abline(0, 1)

# Poda
yhat.prune <- predict(prune.datos, newdata = datos.cargados[-train, ])
plot(yhat.prune, datos.test, main = "arbol podado")
abline(0, 1)


# Mean Square Error (MSE)
sqrt(mean((yhat - datos.test)^2))/8690
sqrt(mean((yhat.prune - datos.test)^2))/8690

# -------------------------------------------------------------------------------ARBOL DE CLASIFICACION

datos.cargados2 <- read.csv("/home/david/Documents/Laboratorio tree/hour.csv" , stringsAsFactors = FALSE)
#Verificacion de estructura y estadisticas de la variable que contiene el archivo.
str(datos.cargados2)
summary(datos.cargados2)

# Discretizamos la variable High
High <- ifelse(datos.cargados2$cnt <= 20, "Bajas", "Altas")
datos.cargados2 <- data.frame(datos.cargados2, High)
str(datos.cargados2)

# Vamos a construir un arbol de clasificacion para predecir High
# utilizando todas las variables, excepto cnt Y dteday
tree.1 <- tree(High ~ .-cnt -dteday , datos.cargados2)
summary(tree.1)

# El training error es del 0.006% (Misclassifcation error rate)
plot(tree.1)
text(tree.1, pretty = 0)
# El indicador mas importante para las ventas parace ser registered.
tree.1


# Vamos a evaluar el arbol con conjuntos de train/test


train <- sample(1:nrow(datos.cargados2), 8690)
test <- datos.cargados2[-train, ]
High.test <- High[-train]


tree.2 <- tree(High ~ .-cnt -dteday, datos.cargados2, subset = train)
plot(tree.2)
text(tree.2, pretty = 0)

tree.pred <- predict(tree.2, test, type = "class")
table(tree.pred, High.test)
prop.table(table(tree.pred, High.test), margin = 2)

# Precision
precision <- (7167 + 1453) / 8690 
precision


#se poda elarbolpara ver simejoralaprecision
cv.tree.3 <- cv.tree(tree.2,FUN = prune.misclass)
names(cv.tree.3)
cv.tree.3
par(mfrow = c(1,2))
plot(cv.tree.3$size,cv.tree.3$dev,type = 'b')
plot(cv.tree.3$k,cv.tree.3$dev,type = 'b')


prune.poda <- prune.misclass(tree.2, best = 6)

plot(prune.poda)
text(prune.poda,pretty = 0)

#veamos el comportamiento
tree.predd <- predict(prune.poda,test, type = "class")
table(tree.predd,High.test)



# --------------------------------------------------------------------------

set.seed(1234)

# Cargue de datos y verificacion de estructura
input.folder <- "/home/david/Documents/Laboratorio tree/"
archivo.cargado <- read.csv(paste0(input.folder, "hour.csv"))
str(archivo.cargado)


# asegurando el tipo de dato de cada columna
archivo.cargado$dteday <- as.Date(archivo.cargado$dteday)
archivo.cargado$instant <- as.integer(archivo.cargado$instant)
archivo.cargado$season <- as.integer(archivo.cargado$season)
archivo.cargado$yr <- as.integer(archivo.cargado$yr)
archivo.cargado$mnth <- as.integer(archivo.cargado$mnth)
archivo.cargado$hr <- as.integer(archivo.cargado$hr)
archivo.cargado$holiday <- as.integer(archivo.cargado$holiday)
archivo.cargado$weekday <- as.integer(archivo.cargado$weekday)
archivo.cargado$workingday <- as.integer(archivo.cargado$workingday)
archivo.cargado$weathersit <- as.integer(archivo.cargado$weathersit)
archivo.cargado$temp <- as.numeric(archivo.cargado$temp)
archivo.cargado$atemp <- as.numeric(archivo.cargado$atemp)
archivo.cargado$hum <- as.numeric(archivo.cargado$hum)
archivo.cargado$windspeed <- as.numeric(archivo.cargado$windspeed)
archivo.cargado$casual <- as.integer(archivo.cargado$casual)
archivo.cargado$registered <- as.numeric(archivo.cargado$registered)
archivo.cargado$cnt <- as.integer(archivo.cargado$cnt)
str(archivo.cargado)

# creacion de nuevo dataframe para su posterior tratmiento
archivo.cargadox <- data.frame(archivo.cargado$dteday, 
  archivo.cargado$instant,
  archivo.cargado$season,
  archivo.cargado$yr, 
  archivo.cargado$mnth, 
  archivo.cargado$hr,
  archivo.cargado$holiday, 
  archivo.cargado$weekday, 
  archivo.cargado$workingday,
  archivo.cargado$weathersit, 
  archivo.cargado$temp, 
  archivo.cargado$atemp, 
  archivo.cargado$hum, 
  archivo.cargado$windspeed, 
  archivo.cargado$casual, 
  archivo.cargado$registered, 
  archivo.cargado$cnt )
str(archivo.cargadox)

# Se cambian los nombres de las columnas para dejar los datos exactamente iguales
names(archivo.cargadox)[	1	]<-"dteday"
names(archivo.cargadox)[	2	]<-"instant"
names(archivo.cargadox)[	3	]<-"season"
names(archivo.cargadox)[	4	]<-"yr"
names(archivo.cargadox)[	5	]<-"mnth"
names(archivo.cargadox)[	6	]<-"hr"
names(archivo.cargadox)[	7	]<-"holiday"
names(archivo.cargadox)[	8	]<-"weekday"
names(archivo.cargadox)[	9	]<-"workingday"
names(archivo.cargadox)[	10	]<-"weathersit"
names(archivo.cargadox)[	11	]<-"temp"
names(archivo.cargadox)[	12	]<-"atemp"
names(archivo.cargadox)[	13	]<-"hum"
names(archivo.cargadox)[	14	]<-"windspeed"
names(archivo.cargadox)[	15	]<-"casual"
names(archivo.cargadox)[	16	]<-"registered"
names(archivo.cargadox)[	17	]<-"cnt"

# se asegura que el formato de la columna dteday teng DATE
archivo.cargadox$dteday <- as.Date(archivo.cargadox$dteday)

# Validacion de la estructura
str(archivo.cargadox)


High <- ifelse(archivo.cargadox$cnt <= 20, 0 , 1)
str(High)

archivo.cargadox <- data.frame(archivo.cargadox, High)
archivo.cargadox <- subset( archivo.cargadox, select = -cnt )
str(archivo.cargadox)

archivo.cargadox$High <- as.factor(archivo.cargadox$High)

str(archivo.cargadox)
archivo.cargado.rand  <- archivo.cargadox[order(runif(17379)),]
archivo.cargado.train <- archivo.cargado.rand[1:13903, ]
archivo.cargado.test  <- archivo.cargado.rand[13904:17379, ]
str(archivo.cargado.train)
prop.table(table(archivo.cargado.train$High))
prop.table(table(archivo.cargado.test$High))


rf.model <- randomForest(x = archivo.cargado.train[, -17],
                         y = archivo.cargado.train$High,
                         data = archivo.cargado.train, 
                         ntree = 500,
                         do.trace= T)

# El OOB es un estimador razonable de error en test/validation
rf.model
plot(rf.model)

# Podemos ver la importancia de las variables
varImpPlot(rf.model)
# hacemos una prediccion en test
rf.pred <- predict(rf.model, archivo.cargado.test)
head(rf.pred)

CrossTable(archivo.cargado.test$High, rf.pred, prop.chisq = F, prop.c = F, prop.r = T, prop.t = F,  
           dnn = c("actual default", "predicted default"))
# Recordemos la distribucion orginal de las clases
prop.table(table(archivo.cargado.train$High))


