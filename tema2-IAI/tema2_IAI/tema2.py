import pandas as pd
from IPython.display import display
from IPython.display import Image
import unicodedata
import codecs
import pprint

#Se cargan los archivos para la primera parte de la actividad

f = open("D:/IA/tema2-IAI/archivos/FicheroALeer.txt",'r')
outfile = open("D:/IA/tema2-IAI/archivos/resultado.txt",'w')
lines = f.readlines()

#Metodo para eliminar tildes

def eliminaTildes(s):
    return ''.join((c for c in unicodedata.normalize('NFD',s) if unicodedata.category(c)!='Mn'))

#Se declaran las variables necesarias para la actividad de la primera parte

word='el'
a = []
count = 0

#Se realiza el conteo del articulo 'el', en el archivo

for line in lines:
    palabras = line.split(' ')
    for p in palabras:
        if p == word:
            count += 1
repetidas = "El articulo 'el' se repite: " + str(count) +" veces"


#Se obtiene el conteo de lineas del archivo, y finalmente se escribe nuevamente el archivo con los requerimientos: sin tildes y en minuscula


tamano = "El tamano del archivo es de: " + str(len(lines))
outfile.write(tamano+'\n')
outfile.write(repetidas+'\n')
for line in lines:
    b = eliminaTildes(line)
    b = b.lower()
    a.append(b)
    outfile.write(str(b))
outfile.close()
f.close()

#Segunda parte de la actividad
#Se carga el fichero poblacionMunicipios

archivo_1 = pd.read_csv('D:/IA/tema2-IAI/archivos/poblacionMunicipios.csv')

#Se eliminan las filas que en poblacion contengan 0 habitantes


for v in archivo_1.Poblacion:
    if(v==0):
        archivo_1.drop(archivo_1.Poblacion[v],inplace=True)

#Se dibuja en un Dataframe el total de habitantes por provincia
sum_pob = archivo_1['Poblacion'].groupby(archivo_1['Provincia']).sum()
df_suma = pd.DataFrame(data=sum_pob)
df_suma

#Se calculan las estadísticas de la poblacion para obtener la desviación tipica

estadistica = archivo_1['Poblacion'].groupby(archivo_1['Provincia']).describe()
desviacion=pd.DataFrame(data=estadistica,columns=["std","count"])
union = pd.concat([sum_pob, desviacion], axis=1)
union.rename(columns={'Poblacion': 'Poblacion Total','std': 'Desviacion Standar','count': 'Cantidad de Municipios'}, inplace=True)
union

#Se carga segundo archivo para relacionar y se cruzan

archivo_2=pd.read_csv('D:/IA/tema2-IAI/archivos/CP_Municipios.csv')
cruce_archivos =pd.merge(archivo_1, archivo_2, on=['CodProvincia','CodMunicipio'],how='inner')
cruce_archivos

#Se hace la relación de los archivo a traves del código postal y se genera el archivo de faltantes

codigo_postal =pd.merge(cruce_archivos, archivo_2, on=['CP'], how="inner", indicator=True )
df = codigo_postal[(codigo_postal['CP'].notnull()) & (codigo_postal['CP'].isin(archivo_2))]
df
df.to_csv("D:/IA/tema2-IAI/archivos/falta.csv")

#Se agrupa la información por código postal

u = pd.merge(archivo_1, archivo_2, on=['Municipio','CodProvincia','Municipio','CodMunicipio'], how='inner')
u = pd.DataFrame(data=u,columns= ['CP','Municipio','Poblacion'])
suma_poblacion = u['Poblacion'].groupby(u['CP']).sum()

grupo_stadistica = u['Poblacion'].groupby(u['CP']).describe()
print(grupo_stadistica)
union_dataframes= pd.DataFrame(data=grupo_stadistica,columns=["count","top"])
union_dataframes

#Metodo para generar union entre suma_poblacion y union_dataframes
ultima_union=pd.concat([suma_poblacion, union_dataframes], axis=1)
#Metodo para establecer cuales columnas se deben mostrar
ultima_union=pd.DataFrame(data=ultima_union, columns=["count","Poblacion","top"])
#Renonanmbrar las columnas para hacer mas entendible la informacion obtenida
ultima_union.rename(columns={'CP_y': 'Codigo Postal','count': 'Numero De Municipios','Poblacion': 'Poblacion Total','top': 'Provincia'}, inplace=True)
ultima_union




