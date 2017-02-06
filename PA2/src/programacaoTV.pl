:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-include('examples.pl').


solver:- series(Series), slots(Slots), votacao(Votacao), rest_series(Rest_series), rest_series_hours(Rest_series_hours),
makeVarList(Slots,[],Var),
length(Series,SeriesSize),
domain(Var,1,SeriesSize),
makeLT(Slots,[ [], [], [], [], [], [], [] ], LT) ,
%makeList(LT,L1,L2,L3,L4,L5,L6,L7), -> divide em listas para cada dia
linkVarLT(Var,LT),
makeMachine(Series,[],Machines),
%write(Machines),nl,
append(LT,NewLT),
%write(NewLT), nl,
%restricoes

restrictDay(LT,Rest_series),
restrictHours(NewLT,Rest_series_hours),
getValor(Var, Valor, 1, Votacao, Series),
cumulatives(NewLT,Machines),
all_distinct(Var),
statistics(walltime, _),
labeling([maximize(Valor)],Var),
statistics(walltime, [_|[ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl,
write(Var),displayVar(Slots,Series).

insert_matrix([],_,_,_,F,F).
insert_matrix([R1|Rn],Elem,Row,Row,T,Mf) :-  append(R1,[Elem],NR),
																		append(T,[NR],Mt),
																		append(Mt,Rn,Mf).
																		
insert_matrix([R1|Rn],Elem,Row,C,T,Mf)  :-  C < Row,
																	C1 is C + 1,
																	append(T,[R1],T2),
																	insert_matrix(Rn,Elem,Row,C1,T2,Mf).



% makeLT(+Slots,+List, -LT) -> transforma a lista de Slots numa matriz de tasks, organizada por dias.													
makeLT([],LT,LT).
makeLT([[ID,Day,StartTime,IDSerie]|List],Temp,LT):- NewStartTime is StartTime + 30,
insert_matrix(Temp,task(StartTime,30,NewStartTime,1,IDSerie), Day, 1, [], NewTemp),
makeLT(List,NewTemp,LT).


% makeVarList(+Slots,+Temp,-Var) -> obtem-se a lista de variáveis para fazer labeling com recurso à lista de slots.
makeVarList([],Var,Var).
makeVarList([[_,_,_,IDSerie]|List],Temp,Var):-append(Temp,[IDSerie],NewTemp),makeVarList(List,NewTemp,Var).

makeList([L1,L2,L3,L4,L5,L6,L7],L1,L2,L3,L4,L5,L6,L7).


% linkVarLT(+VarList, +LT) garante que as variáveis na lista de variáveis são as mesmas que estão na Lista de Tasks.
linkVarLT(X,[]).
linkVarLT([],X).
linkVarLT([],[]).
linkVarLT([Var|List],[[]|LT]):- linkVarLT([Var|List],LT).
linkVarLT([Var|List],[[task(_,_,_,_,Var2)|DayTasks]|LT]):- Var#=Var2, linkVarLT(List,[DayTasks|LT]).

% makeMachine(+Series, +Temp, -Machines) -> Cria uma lista de machines usando as séries
makeMachine([],Machine,Machine).
makeMachine([[IDSerie,_,_,Dur]|Series],Temp,Machines):- NewDur is div(Dur,30), append(Temp,[machine(IDSerie,NewDur)],NewTemp), makeMachine(Series,NewTemp,Machines).

% getValor(+Vars, -Valor, +Cont, +Votacoes, +Series)-> Com recurso à lista de variaveis, lista de votacoes e lista de series, percorre-as (com auxílio de um contador Cont), e "faz" o valor para, no labeling, optimizar
getValor([],0,_,_,_).
getValor([Var|Vars],Valor,Cont,Votacoes,Series):- getVotacao(Var,Cont,Votacao,Votacoes), getCost(Var,Cost,Series) , Valor #= Valor1 + Votacao/Cost, Cont2 is Cont +1, getValor(Vars, Valor1, Cont2, Votacoes, Series).

% getVotacao(+IDSerie, +IDSlot, +Votacao, +VS) -> percorre as votacoes aplicando as restricoes
getVotacao(_,_,_,[]).
getVotacao(IDSerie,IDSlot,Votacao,[[IDSerie1,IDSlot1,Votacao1]|VS]):- ((IDSerie #= IDSerie1) #/\ (IDSlot1#=IDSlot) ) #=> (Votacao #= Votacao1), getVotacao(IDSerie,IDSlot,Votacao,VS).

% getCost(+IDSerie,+Cost,+Series) -> percorre as Series e aplica as restricoes
getCost(_,_,[]).
getCost(IDSerie,Cost,[[IDSerie1,_,Cost1,_]|Series]):- (IDSerie #= IDSerie1) #=> (Cost #= Cost1), getCost(IDSerie, Cost, Series).

% displayVar(+Slots,+Series) -> faz o display para uma leitura fácil.
displayVar([],_).
displayVar([[SlotID,Day,StartTime,Title]|Slots],Series):- getTitle(Title,Series,Result),
NS is (StartTime-((Day-1)*(24*60)))/60,
NS2 is NS + 0.5,
nl,write(Result), write(' vai ser emitido '), switchDay(Day,DayWord), write(DayWord), write(' das '), write(NS), write(' as '), write(NS2), displayVar(Slots,Series).

% getTitle(+Title,+Series,-Result) -> usando o titulo de uma slot, vai buscar a serie correspondente, tendo assim o título da série.
getTitle(Title,[],Result).
getTitle(Title,[[SerieID,SerieTitle,SerieCost,SerieDuration]|Series],Result):-Title is SerieID, Result = SerieTitle.
getTitle(Title,[Serie|Series],Result):-getTitle(Title,Series,Result).


restrictDay(_,[]).
restrictDay(LT,[Restriction|Restrictions]):- restrictDay2(LT,Restriction), restrictDay(LT,Restrictions).

restrictDay2([],_).
restrictDay2([[]|LT],A):-restrictDay2(LT,A).
restrictDay2([[task(_,_,_,_,Title)|RestDay]|LT],[IDSerie1,IDSerie2]):- restrictDay3(RestDay,[IDSerie1,IDSerie2],Bo), ((Title #= IDSerie1) #\/ (Title #= IDSerie2) ) #<=> Exists, Exists #=> Bo , restrictDay2([RestDay|LT],[IDSerie1,IDSerie2]).
restrictDay3([],_,1).
restrictDay3([task(S,_,_,_,Title)|RestDay],[IDSerie1,IDSerie2],Bo):- Bo #<=> (Title #\= IDSerie1 #/\ Title #\= IDSerie2 #/\ Bo1), restrictDay3(RestDay,[IDSerie1,IDSerie2],Bo1).


restrictHours(_,[]).
restrictHours(LT,[Rest|Restrictions]):- restrictHours2(LT,Rest),restrictHours(LT,Restrictions).
restrictHours2([],_).
restrictHours2([task(StartTime,_,_,_,Title)|LT],[IDSerie,1,Time]):-NS is StartTime / 1440, NS2 is floor(NS), NS3 is 1440 * NS2, NewTime is StartTime - NS3, NS3 < Time, Title #\= IDSerie, restrictHours2(LT,[IDSerie,1,Time]).
restrictHours2([task(StartTime,_,_,_,Title)|LT],[IDSerie,1,Time]):-restrictHours2(LT,[IDSerie,1,Time]).
restrictHours2([task(StartTime,_,_,_,Title)|LT],[IDSerie,2,Time]):-NS is StartTime / 1440, NS2 is floor(NS), NS3 is 1440 * NS2, NewTime is StartTime - NS3, NS3 > Time, Title #\= IDSerie,restrictHours2(LT,[IDSerie,2,Time]).
restrictHours2([task(StartTime,_,_,_,Title)|LT],[IDSerie,2,Time]):-restrictHours2(LT,[IDSerie,2,Time]).