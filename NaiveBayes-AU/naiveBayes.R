###################################################
####### Trabajo Aprendizaje Automático ############
###################################################
library(tm)
library(e1071)

################################
### 1: Preparacion de datos ####
################################

datos_votaciones <- read.csv("C:/Users/Sandra_Cardona/Documents/IA/Ficheros/house-votes-84.csv",stringsAsFactors = FALSE)
head(datos_votaciones)
tail(datos_votaciones)

#Hacemos que la columna party sea factor
datos_votaciones$party <- as.factor(datos_votaciones$party)

#Veamos cuantas instancias tenemos de cada clase
prop.table(table(datos_votaciones$party))


#Dividimos los datos en componentes individuales
raw_train <- datos_votaciones[1:348,]
raw_test <- datos_votaciones[349:435,]

#Observamos como se mantienen las proporciones
prop.table(table(raw_train$party))
prop.table(table(raw_test$party))

# Definimos la función para transformación de variables
convert_valuesV <- function(x){
  x <- as.factor(x)
  return(x)
}

#Transformamos todas las variables numéricas a variables categóricas
train_votaciones <- apply(raw_train, MARGIN = 2, convert_valuesV)
test_votaciones <- apply(raw_test,MARGIN = 2,convert_valuesV)

#Definimos nuestro clasificador Naive Bayes, el modelo utiliza la presencia o ausencia de un valor para
#evaluar la probabilidad de voto hacia un partido
classifier_votac <- naiveBayes(train_votaciones,raw_train$party)

#Prediccion de la clase mas probable
prediccion_test <- predict(classifier_votac,test_votaciones,type = "class")



#creamos la matriz de confusion
table(prediccion_test,raw_test$party)
prop.table(table(prediccion_test,raw_test$party))


#Pintar histograma
prediccion_test <- predict(classifier_votac,test_votaciones,type = "raw")
prediccion_test <- as.data.frame(prediccion_test)
hist(prediccion_test$republican)