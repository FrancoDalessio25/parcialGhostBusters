%herramientasRequeridas(Tarea,Elementos)
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradora, cera, aspiradora(300)]).
herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).

%1  tiene(Persona,Elemento)

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,varitaDeNeutrones).

%2 satisfaceNecesidad(Persona,Herramienta)

satisfaceNecesidad(Persona,Herramienta):-
    tiene(Persona,Herramienta).

satisfaceNecesidad(Persona,aspiradora(PoternciaRequerida)):-
    tiene(Persona,aspiradora(PotenciaAEvaluar)),
    PotenciaAEvaluar >= PoternciaRequerida.

%3 puedeRealizarTarea(Persona,Tarea)

puedeRealizarTarea(Persona,Tarea):-
    tiene(Persona,varitaDeNeutrones),
    herramientasRequeridas(Tarea,_).

puedeRealizarTarea(Persona,Tarea):-
    tiene(Persona,_),
    herramientasRequeridas(Tarea,_),
    forall(necesitaHerramienta(Tarea,Herramienta), satisfaceNecesidad(Persona,Herramienta)).
    
necesitaHerramienta(Tarea,Herramienta):-
    herramientasRequeridas(Tarea,Herramientas),
    member(Herramienta, Herramientas).

%4 NO ENTENDIA Y FUI A VER LA SOLUCION.

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

precioACobrarAlCliente(Cliente,PrecioACobrar):-
    tareaPedida(_,Cliente,_),
    findall(Precio, precioPorMetroCuadrado(Cliente,Tarea,Precio) , ListaDePrecios),
    sumlist(ListaDePrecios, PrecioACobrar).
    
precioPorMetroCuadrado(Cliente,Tarea,Precio):-
    precio(Tarea,PrecioPorMetroCuadrado),
    tareaPedida(Tarea,Cliente,MetrosCuadrados),
    Precio is PrecioPorMetroCuadrado * MetrosCuadrados. 


%5 aceptaPedido(Cazador,Cliente)

aceptaPedido(Cazador,Cliente):-
    puedeRealizarTodasLasTarea(Cazador,Cliente),
    estaDispuestoAAceptarPedido(Cazador,Cliente).

puedeRealizarTodasLasTarea(Cazador,Cliente):-
    tareaPedida(_,Cliente,_),
    tiene(Cazador,_),
    forall(tareaPedida(Tarea,Cliente,_),puedeRealizarTarea(Cazador,Tarea)).

estaDispuestoAAceptarPedido(ray,Cliente):-
    not(tareaPedida(limpiarTecho,Cliente,_)).

estaDispuestoAAceptarPedido(winston,Cliente):-
    tareaPedida(Tarea,Cliente,_),
    precio(Tarea,Precio),
    Precio > 500.

estaDispuestoAAceptarPedido(egon,Cliente):-
    tareaPedida(Tarea,Cliente,_),
    not(tareaCompleja(Tarea)).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas, CantidadHerramientas),
    CantidadHerramientas > 2.

tareaCompleja(limpiarTecho).
    