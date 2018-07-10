#Inicio del programa
#Se cargan las bibliotecas necesarias
from skimage.io import imread
import skimage
from skimage.transform import resize
from matplotlib import pyplot as plt
import matplotlib.cm as cm
import numpy as np
import scipy
from scipy import ndimage
import pandas as pd
pd.set_option('display.max_columns', 500)
pd.set_option('display.max_rows', 500)

#Se carga la imagen, se muestra en escala de grises con sus dimensiones, máximo y mínimo

image = 'C:/Users/Lore/Documents/IA/IA/IA/Actividad_1-PC/images/images.jpg'
img = imread(image,as_grey=True)
plt.imshow(img, cmap=cm.gray)
print("Dimensiones: ",img.shape)
print("values = min: ",str(img.min())," max: ",str(img.max()))

#Sumatoria de componentes
#Representación de la sumatoria de los vectores
#plt.plot(x, color='r')
#plt.plot(y, color='b')

#Se obtiene el valor máximo y mínimo de la imagen y su posición (coordenada (x,y)) dentro de la imagen

image = 'C:/Users/Lore/Documents/IA/IA/IA/Actividad_1-PC/images/images.jpg'
img = imread(image,as_grey=True)
plt.imshow(img, cmap=cm.gray)
x = pd.DataFrame(img.sum(axis = 0))
y = pd.DataFrame(img.sum(axis = 1))
#Se recorren los vectores de los componente de la imagen para obtener el
#mínimos y el maximo para poder marcar la imagen con +
for i in range (0,img.shape[0]):
    for j in range (0,img.shape[1]):
        if (img[i,j]==img.min()):
            plt.plot(i, j,marker='+', color='w')
        if (img[i,j]==img.max()):
            plt.plot(i, j,marker='+', color='w')

#Rotación de la imagen

rotar = ndimage.rotate(img,180)
rotate_prueba = ndimage.rotate(img,180,reshape=False)
plt.imshow(rotar, cmap=plt.cm.gray)
plt.axis('off')
plt.imshow(rotate_prueba, cmap=plt.cm.gray)
plt.axis('off')
plt.subplots_adjust(wspace=0.02, hspace=0.3, top=1, bottom=0.1, left=0,right=1)
plt.show()

