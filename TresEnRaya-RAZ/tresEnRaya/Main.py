from timeit import time

from Estado import Tablero,Jugador,Nodo
from MiniMax import MiniMax

def test_tablero():
    estado = Tablero()
    estado.set_value(0, Jugador.MAX)

    estado.set_value(3, Jugador.MIN)

    estado.set_value(6, Jugador.MAX)
    print(estado, estado.es_terminal())

    res = estado.expandir(Jugador.MIN)
    for r in res:
        print(r, r.evaluacion())

if __name__ == "__main__":



    tablero = Tablero()
    estado = Nodo(tablero,0,Jugador.MAX, None)
    minimax = MiniMax(3)
    resultado = estado
    while resultado.tablero.es_terminal()<0:
        start = time.time()

        resultado = minimax.MaxValor(estado)
        estado = resultado.padre

        print(estado)
        estado.nivel =0

        end = time.time()
        print("Time: {0}".format(end - start))

    print(resultado)
