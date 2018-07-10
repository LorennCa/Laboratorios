from typing import List, Union

from enum import Enum

class Jugador(Enum):
    MIN = 0
    MAX = 1
    NONE = -1


class Tablero(object):

    tablero : List[Jugador]
    ultima_accion: int #ultima posicion creada o -1

    def __init__(self):
        self.tablero = [Jugador.NONE]*9
        self.ultima_accion = -1

    def __str__(self):
        res = "-------------\n"
        for i in range(0,3):
            res += "| {0} | {1} | {2} |\n".format(self.value_as_string(3*i),self.value_as_string(3*i+1),self.value_as_string(3*i+2))
            res += "-------------\n"

        return res

    def value_as_string(self, i: int)->str:
        if i >8 or i<0:
            return "N"
        if self.tablero[i]==Jugador.NONE:
            return " "
        if self.tablero[i]==Jugador.MIN:
            return "O"
        if self.tablero[i]==Jugador.MAX:
            return "X"

    def es_terminal(self)-> int:
        '''
        :return: Devuelve -1 si no es terminal, 1 si gana MAX 0 si gana MIN 2 si es empate
        '''
        result = False
        #Gana alguien?
        for valor in [Jugador.MAX,Jugador.MIN]:
            #filas
            result = result or self.tablero[0] == valor and self.tablero[1] == valor and self.tablero[2] == valor
            result = result or self.tablero[3] == valor and self.tablero[4] == valor and self.tablero[5] == valor
            result = result or self.tablero[6] == valor and self.tablero[7] == valor and self.tablero[8] == valor
            #columnas
            result = result or self.tablero[0] == valor and self.tablero[3] == valor and self.tablero[6] == valor
            result = result or self.tablero[1] == valor and self.tablero[4] == valor and self.tablero[7] == valor
            result = result or self.tablero[2] == valor and self.tablero[5] == valor and self.tablero[8] == valor
            #diagonales
            result = result or self.tablero[0] == valor and self.tablero[4] == valor and self.tablero[8] == valor
            result = result or self.tablero[2] == valor and self.tablero[4] == valor and self.tablero[6] == valor
            if result:
                return valor.value

        #Quedan huecos?
        for i in range(0,9):
            if self.tablero[i]==Jugador.NONE:
                return -1
        #Empate!!
        return 2

    def set_value(self, pos:int, val:Jugador):
        self.tablero[pos]=val
        self.ultima_accion = pos

    def expandir(self, jugador: Jugador)-> List['Tablero']:
        result = []
        for i in range(0,9):
            if self.tablero[i]==Jugador.NONE:
                copia = self.__copy__()
                copia.set_value(i,jugador)

                result.append(copia)
        return result

    def evaluacion(self)->int:
        res = 0

        terminal = self.es_terminal()
        if terminal==Jugador.MAX.value:
            return 1000
        elif terminal == Jugador.MIN.value:
            return -1000
        elif terminal == Jugador.NONE.value:
            return 0


        ##PARA MAX

        for row in range(0,3):

            if self.tablero[3*row]!=Jugador.MIN and self.tablero[3*row+1]!=Jugador.MIN and\
                            self.tablero[3*row+2]!=Jugador.MIN:
                res += 1
        ##PARA MIN
        for row in range(0, 3):

            if self.tablero[3 * row] != Jugador.MAX and self.tablero[3 * row + 1] != Jugador.MAX and\
                            self.tablero[ 3 * row + 2] != Jugador.MAX:
                res -= 1

        return res

    def __copy__(self):
        result = Tablero()
        result.tablero = self.tablero.copy()
        return result


class Nodo(object):
    tablero: Tablero
    nivel: int
    turno: Jugador
    padre: 'Nodo'
    accion: int #posicion donde se coloco la ultima pieza o -1


    def __init__(self, tab: Tablero, nivel: int, turno: Jugador, padre: Union['Nodo',None]):
        self.tablero = tab
        self.nivel = nivel
        self.turno = turno
        self.padre = padre
        self.accion = tab.ultima_accion

    def suspension(self, profundida: int)-> bool:
        return self.tablero.es_terminal() >= 0 or self.nivel == profundida

    def evaluacion(self)->int:
        return self.tablero.evaluacion()

    def expandir(self)->List['Nodo']:
        estados = self.tablero.expandir(self.turno)
        turno = Jugador.NONE

        if self.turno == Jugador.MAX:
            turno = Jugador.MIN
        else:
            turno = Jugador.MAX



        res = []
        for estado in estados:
            res.append(Nodo(estado,self.nivel+1,turno,self))

        return res

    def __str__(self):
        res = "Estado : \n{0}".format(self.tablero)

        res += "Nivel: {0} -> Turno: {1} -> accion: {2}\n".format(self.nivel, self.turno.name,self.accion)
        res += "Evaluacion ={0}".format(self.evaluacion())
        return res