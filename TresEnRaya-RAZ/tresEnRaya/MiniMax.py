from Estado import Tablero, Nodo


class MiniMax(object):
    profundidad: int

    def __init__(self, profundidad: int):
        self.profundidad = profundidad

    def MaxValor(self, estado: Nodo)-> Nodo:
        if estado.suspension(self.profundidad):
            return estado

        sucesores = estado.expandir()
        alpha = -1000
        nodo = None
        for estado in sucesores:
            min_valor = self.MinValor(estado)
            if min_valor==None:
                continue

            if min_valor.evaluacion() > alpha:
               alpha = min_valor.evaluacion()
               nodo = min_valor

        return nodo

    def MinValor(self, estado: Nodo)-> Nodo:
        if estado.suspension(self.profundidad):
            return estado

        sucesores = estado.expandir()
        beta = 1000
        nodo = None
        for estado in sucesores:
            max_valor = self.MaxValor(estado)
            if max_valor==None:
                continue

            if max_valor.evaluacion()<beta:
               beta = max_valor.evaluacion()
               nodo = max_valor

        return nodo