:-use_module(library(random)).
:-include('Blockade_sets_gets').

compTrading(0,a).
compTrading(1,b).
compTrading(2,c).
compTrading(3,d).
compTrading(a,0).
compTrading(b,1).
compTrading(c,2).
compTrading(d,3).
compTrading(4,w).
compTrading(5,a).
compTrading(6,s).
compTrading(7,d).
compTrading(8,y).
compTrading(9,n).
compTrading(10,h).
compTrading(11,v).

getInfoComputer(N,Difficulty,Board,Piece,Direction):-
	N2 is N+2, random(N,N2,P), compTrading(P,P1), write('piece: '),write(P1), nl, Piece = P1, !,
	(Difficulty == 0 -> random(4,8,D);
	(Difficulty == 1 ->	
		P2 is P + 1, getCell(Board,Row,Column,P2), Dx1 is 3-Column, Dx2 is 7-Column, Dx1mod is abs(Dx1), Dx2mod is abs(Dx2), (Dx1mod < Dx2mod -> Directionx is Dx1; Directionx is Dx2),
		N3 is N * 3.5, N4 is 10 - N3, Directiony is N4-Row,
		random(0,2,Ori), 
		(Ori < 1 ->
			(Directionx > 0-> D is 5;
				(Directionx < 0-> D is 7;
					(Directiony < 0-> D is 4;
						D is 6)));
			(Directiony < 0-> D is 4;
				(Directiony > 0-> D is 6;
					(Directionx > 0-> D is 5;
						D is 7)))); write(Difficulty))), 
	compTrading(D,D1), write('direction: '),write(D1), nl, Direction = D1.
getInfoComputer(N,Difficulty,Board,Piece,Direction,Piece):-getInfoComputer(N,Difficulty,Board,Piece,Direction,Piece).



getInfoComputerSecond(N,Difficulty,Board,Direction,Piece):-
	(Difficulty == 0 -> random(4,8,D);
	(Difficulty == 1 ->	
		compTrading(Piece,P),
		P2 is P + 1, getCell(Board,Row,Column,P2), Dx1 is 3-Column, Dx2 is 7-Column, Dx1mod is abs(Dx1), Dx2mod is abs(Dx2), (Dx1mod < Dx2mod -> Directionx is Dx1; Directionx is Dx2),
		N3 is N * 3.5, N4 is 10 - N3, Directiony is N4-Row,
		random(0,2,Ori), 
		(Ori < 1 ->
			(Directionx > 0-> D is 5;
				(Directionx < 0-> D is 7;
					(Directiony < 0-> D is 4;
						D is 6)));
			(Directiony < 0-> D is 4;
				(Directiony > 0-> D is 6;
					(Directionx > 0-> D is 5;
						D is 7)))); write(Difficulty))),
	compTrading(D,D1), write('direction: '),write(D1), nl, Direction = D1.
getInfoComputerSecond(N,Difficulty,Board,Direction,Piece):-getInfoComputerSecond(N,Difficulty,Board,Direction,Piece).




getWallInfoComputer(Answer):- random(8,10,Answer1), compTrading(Answer1, Answer), write('walls: '),write(Answer), nl.


setWallsComputer(n,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-NV = V, NH = H,CountH = HwallsCount, CountV = VwallsCount.
setWallsComputer(y,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-random(10,12,Pos), compTrading(Pos,Pos1), checkPos(Pos1,HwallsCount,VwallsCount),write('orientation: '),write(Pos1), nl,insertWallComputer(Pos1,V,H,NewV,NewH,HwallsCount,VwallsCount,CountH,CountV),NV=NewV, NH=NewH.
setWallsComputer(y,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-NV = V, NH = H,CountH = HwallsCount, CountV = VwallsCount.

insertWallComputer(h,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-  random(0,13,Row),random(0,10,Column),write('row: '),write(Row), nl,write('column: '),write(Column), nl,
				checkWall(h,V,H,Row,Column),setCell(H,Row,Column,1,NewH),NewColumn is Column +1, setCell(NewH,Row,NewColumn,1,NewNewH), NV = V, NH = NewNewH,CountV = VwallsCount, CountH is HwallsCount - 1.
insertWallComputer(v,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):- random(0,13,Row),random(0,10,Column),write('row: '),write(Row), nl,write('column: '),write(Column), nl,
				checkWall(v,V,H,Row,Column),setCell(V,Row,Column,1,NewV),NewRow is Row +1, setCell(NewV,NewRow,Column,1,NewNewV), NV = NewNewV, NH = H,CountV is VwallsCount - 1, CountH = HwallsCount.
insertWallComputer(_,B,V,H,NV,NH,HwallsCount,VwallsCount):-write('write only y or n!!!'), nl,setWall(y,B,V,H,NV,NH,HwallsCount,VwallsCount).
	
	

compMove(N,Difficulty,Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):-
getInfoComputer(N,Difficulty,Board,Piece2,Direction),trading(Piece2,PieceN),getCell(Board,Row,Column,PieceN), move(y,Piece2,Direction,Board,NewBoard,V,H,Over), computerMove2(N,Difficulty,NewBoard,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV,Piece2).
compMove(N,Difficulty,Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):-write('Invalid move from computer'),nl,compMove(N,Difficulty,Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over).

computerMove2(N,Difficulty,Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Piece2):-getInfoComputerSecond(N,Difficulty,Board,Direction,Piece2),move(y,Piece2,Direction,Board,NBoard,V,H,Over),computerMove3(N,Difficulty,Board,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV).
computerMove2(N,Difficulty,Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Piece2):-write('Invalid move from computer!!!'),nl,computerMove2(N,Difficulty,Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Piece2).
computerMove2(N,Difficulty,Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV,Piece2).

computerMove3(N,Difficulty,Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV):-getWallInfoComputer(Answer),nl,setWallsComputer(Answer,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV).
computerMove3(N,Difficulty,Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV).
