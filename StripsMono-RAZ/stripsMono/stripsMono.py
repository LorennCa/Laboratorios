from typing import List, Dict
from copy import deepcopy

POSICIONES = [0, 1, 2, 3]


class Propiedad(object):
    nombre: str
    activa: bool

    def __init__(self, nombre):
        self.nombre = nombre
        self.activa = False

    def __eq__(self, other):
        if not isinstance(other,Propiedad):
            return False

        return self.nombre == other.nombre

    def __str__(self):
        return self.nombre


class PropiedadPosicion(Propiedad):
    posicion: int

    def __init__(self, nombre, posicion):
        if not posicion in POSICIONES:
            raise Exception("Posicion no aplicable {}".format(posicion))
        self.posicion = posicion
        Propiedad.__init__(self, "{} {}".format(nombre,posicion))


class MonoPosicion(PropiedadPosicion):
    def __init__(self, posicion):
        PropiedadPosicion.__init__(self, "Mono en", posicion)


class ConPlatano(Propiedad):
    def __init__(self):
        Propiedad.__init__(self, "Con Platano")


class SobreCaja(PropiedadPosicion):
    def __init__(self, pos):
        PropiedadPosicion.__init__(self, "Sobre la Caja", pos)

class EnSuelo(Propiedad):
    def __init__(self):
        Propiedad.__init__(self, "En Suelo")

class CajaPosicion(PropiedadPosicion):
    def __init__(self, posicion):
        PropiedadPosicion.__init__(self, "Caja en", posicion)

class PlatanoPosicion(PropiedadPosicion):
    def __init__(self, posicion):
        PropiedadPosicion.__init__(self, "Platano en", posicion)

class Estado(object):
    propiedades: Dict[str,Propiedad]

    def __init__(self):
        self.propiedades = dict()
        self.__crear_propiedades()
        print("propiedades tiene: " +str(self.propiedades))

    def __crear_posiciones(self):
        for i in POSICIONES:
            m = MonoPosicion(i)
            self.propiedades[m.nombre] = m
            c = CajaPosicion(i)
            self.propiedades[c.nombre] = c
            p = PlatanoPosicion(i)
            self.propiedades[p.nombre] = p
            s = SobreCaja(i)
            self.propiedades[s.nombre] = s

    def __crear_propiedades(self):
        self.__crear_posiciones()

        s = EnSuelo()
        self.propiedades[s.nombre] = s
        s = ConPlatano()
        self.propiedades[s.nombre] = s

    def configurar(self, props: List[Propiedad]):
        for p in props:
            self.propiedades[p.nombre].activa = True

    def pendientes(self, props: List[Propiedad])-> List[Propiedad]:
        result = []
        for p in props:
            if not self.propiedades[p.nombre].activa:
                result.append(p)
        return result

    def __str__(self):
        techo = ""
        for i in POSICIONES:
            platano = PlatanoPosicion(i)
            if self.propiedades[platano.nombre].activa:
                techo+=" P "
            else:
                techo+="   "
        suelo_m = ""
        for i in POSICIONES:
            mono = MonoPosicion(i)
            if self.propiedades[mono.nombre].activa:
                suelo_m+=" M "
            else:
                suelo_m+="   "

        suelo_c = ""
        for i in POSICIONES:
            caja = CajaPosicion(i)
            if self.propiedades[caja.nombre].activa:
                suelo_c += " C "
            else:
                suelo_c += "   "

        if self.propiedades[EnSuelo().nombre].activa:
            ensuelo = "En Suelo"
        else:
            ensuelo = "Sobre Caja"

        conplatano = ""
        if self.propiedades[ConPlatano().nombre].activa:
            conplatano = "Con Platano"
        return "{}\n{}\n{}\n {} {}".format(techo,suelo_m,suelo_c,ensuelo,conplatano)

###################

class Operador(object):
    nombre: str
    PC: List[Propiedad]
    A : List[Propiedad]
    E : List[Propiedad]

    def __init__(self, nombre):
        self.nombre = nombre
        self.PC = []
        self.A = []
        self.E = []

    def aplicar(self, estado: Estado)->Estado:
        result = deepcopy(estado)

        for i in self.A:
            result.propiedades[i.nombre].activa=True

        for i in self.E:
            result.propiedades[i.nombre].activa=False

        return result

    def aplicable(self, estado:Estado)->bool:
        for i in self.PC:
            if not estado.propiedades[i.nombre].activa:
                return False

        return True

    def __str__(self):
        return self.nombre

class MoverMono(Operador):
    def __init__(self, origen: int, destino:int):
        Operador.__init__(self,"MoverMono({},{})".format(origen,destino))
        self.PC.append(EnSuelo())
        self.PC.append(MonoPosicion(origen))

        self.A.append(MonoPosicion(destino))

        self.E.append(MonoPosicion(origen))

class MoverCaja(Operador):
    def __init__(self, origen: int, destino: int):
        Operador.__init__(self, "MoverCaja({},{})".format(origen, destino))
        self.PC.append(EnSuelo())
        self.PC.append(MonoPosicion(origen))
        self.PC.append(CajaPosicion(origen))

        self.A.append(CajaPosicion(destino))

        self.E.append(CajaPosicion(origen))


class Subir(Operador):
    def __init__(self, origen: int):
        Operador.__init__(self, "SubirCaja({})".format(origen))
        self.PC.append(EnSuelo())
        self.PC.append(MonoPosicion(origen))
        self.PC.append(CajaPosicion(origen))

        self.A.append(SobreCaja(origen))

        self.E.append(EnSuelo())

class Bajar(Operador):
    def __init__(self, origen):
        Operador.__init__(self, "BajarCaja({})".format(origen))
        self.PC.append(SobreCaja(origen))

        self.A.append(EnSuelo())

        self.E.append(SobreCaja(origen))

class ObtenerPlatano(Operador):
    def __init__(self, origen: int):
        Operador.__init__(self, "ObtenerPlatano({})".format(origen))
        self.PC.append(SobreCaja(origen))
        self.PC.append(PlatanoPosicion(origen))
        self.PC.append(MonoPosicion(origen))

        self.A.append(ConPlatano())

        self.E.append(PlatanoPosicion(origen))

class Acciones(object):
    disponibles: List[Operador]

    def __init__(self):
        self.disponibles = []
        for i in POSICIONES:
            self.disponibles.append(Subir(i))
            self.disponibles.append(ObtenerPlatano(i))
            for j in POSICIONES:
                if i != j:
                    self.disponibles.append((MoverCaja(i, j)))
                    self.disponibles.append((MoverMono(i, j)))

    def aplicables(self, estado:Estado)->List[Operador]:
        result = []
        for a in self.disponibles:
            if a.aplicable(estado):
                result.append(a)
        return result

    def produce(self, prop: Propiedad)-> List[Operador]:
        result = []
        for a in self.disponibles:
            if prop in a.A:
                result.append(a)
        return result


if __name__ == "__main__":
    e = Estado()
    e.configurar([MonoPosicion(0),CajaPosicion(2),PlatanoPosicion(1), EnSuelo()])

    acciones = Acciones()

    print (e)
    for a in acciones.aplicables(e):
        if a.aplicable(e):
            print ("{} Aplicable".format(a.nombre))
            o = a.aplicar(e)
            print (o)

    for a in acciones.produce(MonoPosicion(1)):
        print ("{} Produce".format(a.nombre))

