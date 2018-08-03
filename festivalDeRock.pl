%PUNTO1
estaDeModa(Banda):-
	banda(Banda,AnioCreacion,_,Popularidad),
	bandaReciente(AnioCreacion),
	Popularidad>70.

bandaReciente(AnioCreacion):-
	anioActual(AnioActual),
	(AnioActual-AnioCreacion)=<5.

%PUNTO2
esCareta(Festival):-
	festival(Festival,_,ListaBandas,_),
	careteadaDeBandas(ListaBandas).

careteadaDeBandas(ListaBandas):-
	tiene2BandasDeModa(ListaBandas).
careteadaDeBandas(ListaBandas):-
	tocaMiranda(ListaBandas).

tiene2BandasDeModa(ListaBandas):-
	findall(Banda,bandasDeModa(Banda,ListaBandas),ListaBandasDeModa),
	length(ListaBandasDeModa,CantidadBandasDeModa),
	CantidadBandasDeModa>=2.

bandasDeModa(Banda,ListaBandas):-
	member(Banda,ListaBandas),
	estaDeModa(Banda).

tocaMiranda(ListaBandas):-
	member(miranda,ListaBandas).

esCareta(Festival):-
	festival(Festival,_,_,Entradas),
	not(entradaRazonable(Festival,_)).

%PUNTO3
entradaRazonable(Festival,campo):-
	festival(Festival,_,Bandas,_),
	popularidadTotal(Festival,Bandas,PopularidadTotal),
	precioEntrada(Festival,campo,PrecioEntrada),
	PopularidadTotal<PrecioEntrada.
entradaRazonable(Festival,plateaGeneral(Zona)):-
	festival(Festival,lugar(Lugar,_),_,_),
	plusZona(Lugar,Zona,Plus),
	precioEntrada(Festival,plateaGeneral(Zona),PrecioEntrada),
	Plus<(PrecioEntrada*0.1).
entradaRazonable(Festival,plateaNumerada(Fila)):-
	festival(Festival,_,Bandas,_),
	noTocaNingunaBandaDeModa(Bandas),
	precioEntrada(Festival,plateaNumerada(Fila),PrecioEntrada),
	PrecioEntrada<=750.
entradaRazonable(Festival,plateaNumerada(Fila)):-
	festival(Festival,lugar(_,CapacidadEstadio),Bandas,_),
	member(Banda,Bandas),
	estaDeModa(Banda),
	precioEntrada(Festival,plateaNumerada(Fila),PrecioEntrada),
	popularidadTotal(Festival,Bandas,PopularidadTotal),
	PrecioEntrada<(CapacidadEstadio/PopularidadTotal).

popularidadTotal(Festival,Bandas,PopularidadTotal):-
	findall(Popularidad,bandasFestival(Bandas,Popularidad),ListaPopularidadBandas),
	sumlist(ListaPopularidadBandas,PopularidadTotal).

bandasFestival(Bandas,Popularidad):-
	member(Banda,Bandas),
	banda(Banda,_,_,Popularidad).	

noTocaNingunaBandaDeModa(Bandas):-
	forall(member(Banda,Bandas),not(estaDeModa(Banda))).

precioEntrada(Festival,campo,PrecioEntrada):-
	festival(Festival,_,_,PrecioEntrada).
precioEntrada(Festival,plateaGeneral(Zona),PrecioEntrada):-
	festival(Festival,lugar(Lugar,_),_,PrecioBase),
	plusZona(Lugar,Zona,Plus),
	PrecioEntrada is Plus+PrecioBase.
precioEntrada(Festival,plateaNumerada(Fila),PrecioEntrada):-
	festival(Festival,_,_,PrecioBase),
	PrecioEstrada is (PrecioBase+200/Fila).

%PUNTO4
nacanpop(Festival):-
	festival(Festival,_,ListaBandas,_),
	forall(member(Banda,ListaBandas),bandaNacional(Banda)),
	entradaRazonable(Festival,_).

bandaNacional(Banda):-
	banda(Banda,_,ar,_).

%PUNTO5
recaudacion(Festival,Total):-
	festival(Festival,_,_,_),
	findall(TotalSector,totalSector(Festival,TotalSector),ListaTotalesPorSector),
	sumlist(ListaTotalesPorSector,Total).

totalSector(Festival,TotalSector):-
	entradasVendidas(Festival,Entrada,CantidadVendida),
	precioEntrada(Festival,Entrada,PrecioEntrada),
	TotalSector is PrecioEntrada*CantidadVendida.