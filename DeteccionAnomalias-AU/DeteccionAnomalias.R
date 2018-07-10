#####################################################################
####################### Detección de Anomalias ######################
#####################################################################

#Instalacion de paquetes
#install.packages("IsolationForest", repos="http://R-Forge.R-project.org")
library(IsolationForest)

#Se obtienen los datos a procesar
d <- "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
data <- data.frame(readLines(d))
names(data)<- "diagnostData"

#Se separan los datos obtenidos
rsdata <- within(data=data, diagnostData <- data.frame
                 (do.call('rbind',strsplit(as.character(diagnostData),",",fixed=FALSE))))


##Se nombran las columnas
id_number <- rsdata$diagnostData$X1
Clump_Thickness <- rsdata$diagnostData$X2
Uniformity_of_Cell_Size <- rsdata$diagnostData$X3
Uniformity_Cell_Shape <- rsdata$diagnostData$X4
Marginal_Adhesion <- rsdata$diagnostData$X5
Single_Epithelial <- rsdata$diagnostData$X6
Bare_Nuclei <- rsdata$diagnostData$X7
Bland_Chromatin <- rsdata$diagnostData$X8
Normal_Nucleoli <- rsdata$diagnostData$X9
Mitoses <- rsdata$diagnostData$X10
Class <- rsdata$diagnostData$X11


#Se crea un dataframe con los datos a procesar
dia <- data.frame(id_number,Clump_Thickness,Uniformity_of_Cell_Size,Uniformity_Cell_Shape,Marginal_Adhesion,
                  Single_Epithelial,Bare_Nuclei,Bland_Chromatin,Normal_Nucleoli,Mitoses,Class)


#Se hace tratamiento de missing
dia <- dia[dia$Bare_Nuclei!="?",]
View(dia)

#Se cambia el tipo de dato
dia$Clump_Thickness <- as.numeric(dia$Clump_Thickness)
dia$Uniformity_of_Cell_Size <- as.numeric(dia$Uniformity_of_Cell_Size) 
dia$Uniformity_Cell_Shape <- as.numeric(dia$Uniformity_Cell_Shape) 
dia$Marginal_Adhesion <- as.numeric(dia$Marginal_Adhesion) 
dia$Single_Epithelial <- as.numeric(dia$Single_Epithelial) 
dia$Bare_Nuclei <- as.numeric(dia$Bare_Nuclei)
dia$Bland_Chromatin <- as.numeric(dia$Bland_Chromatin)
dia$Normal_Nucleoli <- as.numeric(dia$Normal_Nucleoli)
dia$Mitoses <- as.numeric(dia$Mitoses)

str(dia)



#Se crea un dataframe con el que se creara el modelo  que
#determine un diagnostico
dataP <- data.frame(dia$id_number,dia$Clump_Thickness,dia$Uniformity_of_Cell_Size,dia$Uniformity_Cell_Shape,dia$Marginal_Adhesion,
                          dia$Single_Epithelial,dia$Bare_Nuclei,dia$Bland_Chromatin,dia$Normal_Nucleoli,dia$Mitoses,dia$Class)

View(dataP)


#Se crea el conjunto de datos de test y el conjunto de datos de entrenamiento
data.entrenamiento <- dataP[1:544,]
data.test <- dataP[545:680,]
View(data.entrenamiento)


#Entrenamiento del modelo
model.1 <- IsolationTrees(data.entrenamiento[2:10],rFactor = 0)
model.1

#Se obtiene el score de la anomalia
score.1 <- AnomalyScore(data.entrenamiento[2:10], model.1)
score.1$outF

#Se prueba el modelo con los datos de test
score.2 <- AnomalyScore(data.test[2:10],model.1)
score.2$outF


#Funcion que clasifica el tipo de tumor de acuerdo al resultado del modelo
categorizar <- function(x) {
  x <- ifelse(x > 0.39,"Maligno","Benigno")
  return(x)
}

#Se agrega el resultado del modelo al dataframe
data.test$resultado_mod <- score.2$outF

#Se aplica la funcion
res <- apply(data.frame(data.test$resultado), MARGIN = 2, categorizar)


#Se agrega el resultado_final al dataframe
data.test$resultado_final <- res
View(data.test)