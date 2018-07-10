#Se importan las bibliotecas que se van a usar en los diferentes códigos
from random import randint
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from IPython.display import display, HTML

#La celda 5 se divide en dos columnas con el objetivo de mostrar el datagrama y el pie chart horizontalmente
CSS = """
div.cell:nth-child(5) .output {
   flex-direction: row;
}
"""

HTML('<style>{}</style>'.format(CSS))

#Calcular el mcm de dos numeros
#Variables solicitadas por consola
num1 = int(input("Introduce el primer numero: "))
num2 = int(input("Introduce el segundo numero: "))

def calcularMCM(num1,num2):
    mcm = 0
    a = max(num1,num2)
    while(True):
        if (a%num1==0) and (a%num2==0):
            mcm = a
            break
        a +=1
    return mcm

print("El minimo comun multiplo es: " + str(calcularMCM(num1,num2)))

#Variables solicitadas por consola
num1 = int(input("Introduce el primer numero: "))
num2 = int(input("Introduce el segundo numero: "))
def calcularMCD(num1,num2):
        a = 0
        while (num2 > 0):
            a = num2
            num2 = num1 % num2
            num1 = a
        return num1
print("El máximo común divisor es: " + str(calcularMCD(num1,num2)))

#Método para generar un random en los porcentajes
def generaRandom(lim1, lim2):
    a = randint(lim1,lim2)
    return a

plt.ion()#Se activa el modo interactivo
poblacion =   [generaRandom(30,32),generaRandom(9,11),generaRandom(8,10),generaRandom(4,6),generaRandom(3,5),generaRandom(2,4),generaRandom(1,3),generaRandom(1,3),generaRandom(1,3),generaRandom(1,3)]
poblacion = np.append(poblacion, 100. - np.sum(poblacion))
ciudades = ['Bogotá', 'Medellín', 'Cali', 'Barranquilla', 'Cartagena', 'Cúcuta', 'Soledad', 'Ibagué', 'Soacha', 'Bucaramanga', 'Otros']
#Sobresalen algunas partes del pie chart para mejor entendimiento
explode = [0.3, 0.1, 0.1, 0.1, 0.1, 0.1, 0.3, 0, 0.3, 0.1, 0.1]
#Se dibuja el pie chart
plt.pie(poblacion, labels = ciudades, explode = explode, autopct='%.0f%%')
plt.title(u'Municipios de Colombia con mas de 200.000 habitantes')
datos = {'Ciudad': ['Bogotá', 'Medellín', 'Cali', 'Barranquilla','Cartagena','Cúcuta','Soledad','Ibagué','Soacha','Bucaramanga','Otros','Total'],
        'Poblacion': ['8.181.047','2.529.403','2.445.281','1.232.766','1.036.412','668.966','666.109','569.346','544.997','528.683','7.713.313','26.116.323']}
#Se dibuja el Dataframe
df = pd.DataFrame(datos,columns = ['Ciudad', 'Poblacion'])
df

np.random.seed(19680801)
N = 20
x = np.random.rand(N)
y = np.random.rand(N)
colors = np.random.rand(N)
area = np.pi * (15 * np.random.rand(N))**2

plt.scatter(x, y, s=area, c=colors, alpha=0.5)
plt.show()

#El diagrama de dispersion se utiliza para analizar la relación entre dos variables, una de ellas esta situada en el eje x
#y la otra variable esta ubicada en el eje y, dichas variables tienen una relación de causa y efecto. Los diagramas de
#dispersión son una herramienta para el control de la calidad, para identificar la raiz del problema, también se puede medir
#la eficacia de la gestión con el objetivo de obtener la relación entre el margen operativo y las utilidades, los diagramas
#de dispersión también se usa para investigaciones científicas o para comprobar teorías.
#Existen 3 tipos de diagrama de dispersión - correlacion: 1 - Ambas variables tienen en común que aumentan o disminuyen.
#2 - Una de las variables aumenta y la otra disminuye
#3 - No hay ninguna relación entre las variables.

#Para objetener varias gráficas en el mismo dibujo es necesario especificar las distintas funciones dentro del mismo
#comando "plot" ejemplo: plot [0:10] sin(x), 1-2*exp(-x/3).
#También se puede utilizar el comando "replot" para añadir funciones o datos al dibujo.
