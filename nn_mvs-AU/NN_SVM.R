#Se instalan las bibliotecas necesarias para el laboratorio
#install.packages("readxl")
#install.packages("e1071")
#install.packages("neuralnet")

#Importamos las librerias necesarias
library(readxl)
library(e1071)
library(neuralnet)

#################################################################
### Modelando el consumo (millas por galon) de unos vehiculos ###
#################################################################

#Cargamos el set de datos con el que haremos nuestra prediccion
auto <- read_excel("C:/Users/Lore/Documents/IA/Aprendizaje_Automatico/auto-mpg.xlsx")
View(auto)


#Los datos proporcionados vienen sin encabezados, a continuacion se incluyen
names(auto)[1]<-"mpg"
names(auto)[2]<-"cylinders"
names(auto)[3]<-"displacement"
names(auto)[4]<-"horsepower"
names(auto)[5]<-"weight"
names(auto)[6]<-"acceleration"
names(auto)[7]<-"model_year"
names(auto)[8]<-"origin"
names(auto)[9]<-"car_name"
View(auto)
str(auto)

#Dentro del dataset existen algunas variables desconocidas
#No podemos realizar cálculos con dichas variables, por ello se hace 
#tratamiento de missing
autoSinDes <- auto[auto$horsepower!="?",]
View(autoSinDes)

#Los datos proporcionados son de tipo char, se cambia el tipo de dato para los calculos
mpgNorm <- as.numeric(autoSinDes$mpg) 
cylindersNorm <- as.integer(autoSinDes$cylinders)
displacementNorm <- as.numeric(autoSinDes$displacement)
horsepowerNorm <- as.numeric(autoSinDes$horsepower)
weightNorm <- as.numeric(autoSinDes$weight)
accelerationNorm <- as.numeric(autoSinDes$acceleration)
model_yearNorm <- as.integer(autoSinDes$model_year)
originNorm <- as.integer(autoSinDes$origin)
car_nameNorm <- as.character(autoSinDes$car_name)


#En un dataframe se ponen los datos a normalizar y con los que se creara la
#red neuronal, en este caso el campo car_name no aplica por ser de tipo character
dataToNormalize <- data.frame(mpgNorm,cylindersNorm,displacementNorm,horsepowerNorm,weightNorm,
                              accelerationNorm,model_yearNorm,originNorm)

#Función para normalizar el dataframe dataToNormalize
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))    
}


#Se aplica normalizacion
auto.norm <- as.data.frame(lapply(dataToNormalize, normalize))

#A los datos normalizados le agregamos la columna car_name
auto.norm$car_name = autoSinDes$car_name

#Separamos los datos de entrenamiento y los datos de test
mpg.train <- auto.norm[1:293,]
mpg.test <- auto.norm[294:391,]


#Se crea la semilla para la primera red neuronal
set.seed(1234)
#Se crea la primera red neuronal con el hidden por defecto que corresponde a una
#neurona oculta

mpg.model <- neuralnet(mpgNorm ~ cylindersNorm + displacementNorm + horsepowerNorm + weightNorm + 
                         accelerationNorm + model_yearNorm + originNorm, data = mpg.train)

plot(mpg.model)

#Se evaluan los resultados de la red neuronal
model.result <- compute(mpg.model,mpg.test[,c(2:8)])
mpg.prediction <- model.result$net.result
#Comparacion de los resultados de la prediccion vs realidad
head(model.result$net.result)
head(mpg.test$mpgNorm)


#Correlacion entre la prediccion vs realidad
cor(mpg.prediction,mpg.test$mpgNorm)

#Se calcula el root-mean-square error de la prediccion
RMSE <- sqrt(mean((mpg.test$mpgNorm - mpg.prediction)^2))
RMSE

#Se calcula el error cuadratico medio
MSE <- mean((mpg.test$mpgNorm  - mpg.prediction)^2)
MSE

#Se crea el plot de la primera prediccion
plot(mpg.test$mpgNorm,mpg.prediction,col='green'
     ,main='Real vs predicho NN 1',pch=18,cex=0.7)
abline(0,1,lwd=1)

#Generamos nuevamente la semilla para que los resultados de las funciones sean constantes
#y se genera la siguiente red neuronal pero con mas neuronas ocultas para ver si asi mejora el 
#resultado
set.seed(1234)
mgp.model.2 <- neuralnet(mpgNorm ~ cylindersNorm + displacementNorm + horsepowerNorm + weightNorm + 
                           accelerationNorm + model_yearNorm + originNorm, 
                         data = mpg.train, hidden = c(2 , 2, 2),act.fct = 'tanh')

plot(mgp.model.2)

#Se evalua el resultado
model.result.2 <- compute(mgp.model.2, mpg.test[,c(2:8)])
mpg.prediction.2 <- model.result.2$net.result

#Nuevamente se comparan los resultados de la prediccion vs la realidad
head(model.result.2$net.result)
head(mpg.test$mpgNorm)

#Correlacion entre el resultado vs la realidad
cor(mpg.prediction.2, mpg.test$mpgNorm)



RMSE <- sqrt(mean((mpg.test$mpgNorm - mpg.prediction.2)^2))
RMSE

MSE <- mean((mpg.test$mpgNorm  - mpg.prediction.2)^2)
MSE

#Plot de la segunda prediccion
plot(mpg.test$mpgNorm,mpg.prediction.2,col='green',main='Real vs predicho NN 2',
     pch=18,cex=0.7)
abline(0,1,lwd=2)


#Probamos la regresion lineal
lm.model <- lm(mpgNorm ~ cylindersNorm + displacementNorm + horsepowerNorm + weightNorm + 
                 accelerationNorm + model_yearNorm + originNorm, data = mpg.train)

pred.lm <- predict(lm.model, mpg.test[,c(2:8)])
cor(pred.lm,mpg.test$mpgNorm)

RMSE <- sqrt(mean((mpg.test$mpgNorm - pred.lm)^2))
RMSE

#Se genera el plot de lm
plot(mpg.test$mpgNorm,pred.lm,col='green',main='Real vs predicho lm',pch=18,cex=0.7)
abline(0,1,lwd=2)

#Visualizamos las tres predicciones

par(mfrow=c(1,3))
#Prediccion_1
plot(mpg.test$mpgNorm,mpg.prediction,col='green'
     ,main='Real vs predicho NN 1',pch=18,cex=0.7)
abline(0,1,lwd=1)
#Prediccion_2
plot(mpg.test$mpgNorm,mpg.prediction.2,col='blue',main='Real vs predicho NN 2',
     pch=18,cex=0.7)
abline(0,1,lwd=2)
#Prediccion_3
plot(mpg.test$mpgNorm,pred.lm,col='red',main='Real vs predicho lm',pch=18,cex=0.7)
abline(0,1,lwd=2)



#Ahora vamos a ejecutar nuestro modelo con los datos de train
#los resultados se veran mucho mejores ya que tenemos muchos mas datos
model.results.2.tr <- compute(mgp.model.2, mpg.train[,c(2:8)])
mpg.prediction.2.tr <- model.results.2.tr$net.result
plot(mpg.train$mpgNorm,mpg.prediction.2.tr,col='green',main='Real vs predicho NN 2',
     pch=18,cex=0.7)
abline(0,1,lwd=2)



##################################
#### Maquina de vector soporte ###
##################################

#Pasamos a crear la maquina de vector soporte
#Debemos disponer la semilla
set.seed(1)


auto <- read_excel("C:/Users/Sandra_Cardona/Documents/IA/Aprendizaje_Automatico/auto-mpg.xlsx")
autoSinDes <- auto[auto$`130.0`!="?",]

#Se aplica normalizacion

mpgNorm <- as.numeric(autoSinDes$`18.0`)
cylindersNorm <- as.numeric(autoSinDes$`8`)
displacementNorm <- as.numeric(autoSinDes$`307.0`)
horsepowerNorm <- as.numeric(autoSinDes$`130.0`)
weightNorm <- as.numeric(autoSinDes$`3504.`)
accelerationNorm <- as.numeric(autoSinDes$`12.0`)
model_yearNorm <- as.numeric(autoSinDes$`70`)
originNorm <- as.numeric(autoSinDes$`1`)
car_nameNorm <- as.character(autoSinDes$`chevrolet chevelle malibu`)

dataToNormalize = data.frame(mpgNorm,cylindersNorm,displacementNorm,horsepowerNorm,weightNorm,
                             accelerationNorm,model_yearNorm,originNorm)
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))    
}

auto.normsvm <- as.data.frame(lapply(dataToNormalize, normalize))

mpgsvn.train <- auto.normsvm[1:293,]
mpgsvmotr.test <- auto.normsvm[154:170,]
mpgsvm.test <- auto.normsvm[294:310,]

#Se preparan los datos con los que la máquina de vector soporte realizará los cálculos
x=c(mpgsvm.test$cylindersNorm,mpgsvm.test$displacementNorm,mpgsvm.test$horsepowerNorm)
y=c(mpgsvm.test$weightNorm,mpgsvm.test$accelerationNorm,mpgsvm.test$model_yearNorm)

#Ponemos la semilla
set.seed(1)
#Codificamos la variable mpgNorm como factor para el resultado
resultado = as.factor(mpgsvm.test$mpgNorm)
datos=data.frame(x,y,resultado)


#Se crea la maquina vector soporte
modelo=svm(resultado ~ y + x, data = datos, method="C-classification",
           kernel="radial",cost=1,scale=F)

plot(modelo,data = datos,formula = y ~ x + y,
     svSymbol = "x",dataSymbol = "o")


modelo$index
summary(modelo)

plot(x,y ,col = c("blue", "orange"))



set.seed(1)
#Vamos a probar nuestra máquina de vector soporte con varios parametros de coste
#para obtener el mejor coste del modelo
tune.out <- tune(svm, resultado ~ y + x, data = datos, kernel = "linear",
                 ranges = list(cost = c( 0.001,0.01,0.1,1,10,100)),
                 tunecontrol = tune.control(sampling = "cross",cross = 5))

summary(tune.out)
best.model <- tune.out$best.model
#El tune.out indica que el mejor coste para el modelo es 1
summary(best.model)


#Vamos a usar el metodo predict para prodecir en un nuevo conjunto de test
xtest=c(mpgsvmotr.test$cylindersNorm,mpgsvmotr.test$displacementNorm,mpgsvmotr.test$horsepowerNorm)
ytest=c(mpgsvmotr.test$weightNorm,mpgsvmotr.test$accelerationNorm,mpgsvmotr.test$model_yearNorm)
grupotest=mpgsvmotr.test$mpgNorm
test.data <- data.frame(xtest,ytest,grupotest)
predic <- predict(best.model,test.data)
table(predict=predic,truth  = test.data$ytest)
predic
test.data$ytest
set.seed(1)
sample.rows <- sample (17,7)
svm.fit_4 <- svm(grupotest ~ ytest + xtest, data = test.data[sample.rows,],
                 kernel = "radial",gamma=1, cost = 1)

plot(svm.fit_4,test.data[sample.rows])