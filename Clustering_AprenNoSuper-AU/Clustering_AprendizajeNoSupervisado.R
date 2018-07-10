#install.packages("cluster")
library(cluster)
data <- read.csv("C:/Users/Sandra_Cardona/Documents/IA/Aprendizaje_Automatico/TEMA_11/Wholesale_customers_data.csv")

View(data)

#Visualización de los datos por canal
table(data$Channel)
#Visualización de los datos por Region
table(data$Region)

#Summary por productos
summary(data$Fresh)
summary(data$Milk)
summary(data$Grocery)
summary(data$Frozen)
summary(data$Detergents_Paper)
summary(data$Delicassen)

#Se pueden evidenciar algunos picos en los datos como son los siguientes casos
plot(data$Milk, main = "Lacteos")
plot(data$Grocery, main = "Abarrotes")

#Procesamos los datos
datosEsc <- data[3:7]
datosEsc_x <- as.data.frame(lapply(datosEsc, scale))

#Se unifica la información en un dataframe
datosEsc_x$Channel = data$Channel
datosEsc_x$Region = data$Region

#Se pone la semilla
set.seed(1234)
#Se crea el clustering aplicado el algoritmo kmeans en tres grupos
data.cluster <- kmeans(datosEsc_x,3)

#Se plotea el cluster creado para ver mejor los resultados
clusplot(datosEsc_x, 
         data.cluster$cluster,
         color = TRUE,
         col.clus = c(1:3)[unique(data.cluster$cluster)],
         shade = TRUE,
         labels = 0,
         lines = 0,
         main = "Distribucion por Channel, Region y alimentos")

data.cluster$size
data.cluster$centers