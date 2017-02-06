:-use_module(library(lists)).

% GETS

getCell(Board,Row,Column,Piece) :- nth0(Row, Board, NewRow), nth0(Column, NewRow, Piece).


getInfo1Piece(Piece):- write('Select the piece you want to move (a or b):'), read(Piece),checkPiece1(Piece).					
getInfo1Piece(Piece):- write('Wrong piece selection (a or b).'),nl,getInfo1Piece(Piece).

getInfo2Piece(Piece):- write('Select the piece you want to move (c or d):'), read(Piece),checkPiece2(Piece).
getInfo2Piece(Piece):- write('Wrong piece selection (c or d).'),nl, getInfo2Piece(Piece).


getInfoDirection(y,Direction):-write('Select the direction you want to move (w a s d):'), read(Direction), checkMove(Direction).
getInfoDirection(y,Direction):-write('Wrong direction input. ( w a s d)'), getInfoDirection(y,Direction).
getInfoDirection(n,Direction).

getInfoSecond(Response):-write('Would you like to move your pawn again? (y or n)'), read(Response), checkAnswer(Response).
getInfoSecond(Response):-write('Write y or n only!'),nl,getInfoSecond(Response).



getWallInfo(Answer,HwallsCount,VwallsCount):- write('Do you want to place a wall now? (y or n): '), nl, write('You have: '), write(HwallsCount), write(' horizonal walls left and '), write(VwallsCount), write(' vertical walls left .'),
read(Answer), checkAnswer(Answer).
getWallInfo(Answer,HwallsCount,VwallsCount):- write('Write y or n only!'), nl,getWallInfo(Answer,HwallsCount,VwallsCount).

% SETS

setCell(Board, Row, Column, Object, NewBoard):- nth0(Row, Board, CurrentRow),
																			setPart(Column,Object,CurrentRow,NewRow),
																			setPart(Row,NewRow,Board,NewBoard).

												
setPart(Pos, Object, List, NewList):-	length(TempList,Pos), 
														append(TempList,[_|Y],List), 
														append(TempList,[Object|Y],NewList).

setWalls(n,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-NV = V, NH = H,CountH = HwallsCount, CountV = VwallsCount.
setWalls(y,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):-write('Insert the position you want your wall in (h or v):'),read(Pos),checkPos(Pos,HwallsCount,VwallsCount), insertWall(Pos,V,H,NewV,NewH,HwallsCount,VwallsCount,CountH,CountV),NV=NewV, NH=NewH.


insertWall(h,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):- write('Insert the number of the row you want your wall: '), read(Row),write('Insert the number of the column you want your wall to start (note that the wall will have the length of 2 cells) :'), read(Column),
				checkWall(h,V,H,Row,Column),setCell(H,Row,Column,1,NewH),NewColumn is Column +1, setCell(NewH,Row,NewColumn,1,NewNewH), NV = V, NH = NewNewH, CountV = VwallsCount, CountH is HwallsCount - 1.
insertWall(v,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV):- write('Insert the number of the column you want your wall: '), read(Column), write('Insert the number of the row you want your wall to start (note that the wall will have the length of 2 cells) :'), read(Row),
				checkWall(v,V,H,Row,Column),setCell(V,Row,Column,1,NewV),NewRow is Row +1, setCell(NewV,NewRow,Column,1,NewNewV), NV = NewNewV, NH = H, CountV is VwallsCount - 1, CountH = HwallsCount.
insertWall(_,B,V,H,NV,NH,HwallsCount,VwallsCount):-write('Wrong wall input!!!'), nl,setWall(y,B,V,H,NV,NH,HwallsCount,VwallsCount).

										

														
% CHECKS

checkPiece1(a).
checkPiece1(b).
checkPiece2(c).
checkPiece2(d).

checkMove(w).
checkMove(a).
checkMove(s).
checkMove(d).

checkAnswer(y).
checkAnswer(n).

checkDestination(Row,Column,w,Board,NewRow,NewColumn,V,H):-Row > 0, NewRow is Row-1, NewColumn is Column,getCell(H,NewRow,Column,0).
checkDestination(Row,Column,s,Board,NewRow,NewColumn,V,H):- Row < 14, NewRow is Row+1, NewColumn is Column, getCell(Board,NewRow,NewColumn,0),getCell(H,Row,Column,0).
checkDestination(Row,Column,a,Board,NewRow,NewColumn,V,H):- Column > 0, NewRow is Row, NewColumn is Column-1, getCell(Board,NewRow,NewColumn,0),getCell(V,Row,NewColumn,0).
checkDestination(Row,Column,d,Board,NewRow,NewColumn,V,H):- Column < 11, NewRow is Row, NewColumn is Column+1, getCell(Board,NewRow,NewColumn,0),getCell(V,Row,Column,0).

checkBoard(Row,Column,w,Board,NewRow,NewColumn,V,H):-getCell(Board,Row,Column,0), NewRow = Row, NewColumn = Column.
checkBoard(Row,Column,w,Board,NewRow,NewColumn,V,H):-checkDestination(Row,Column,w,Board,NRow,NColumn,V,H), getCell(Board,NRow,NColumn,0), NewRow = NRow, NewColumn = NColumn.
checkBoard(Row,Column,s,Board,NewRow,NewColumn,V,H):-getCell(Board,Row,Column,0), NewRow = Row, NewColumn = Column.
checkBoard(Row,Column,s,Board,NewRow,NewColumn,V,H):-checkDestination(Row,Column,s,Board,NRow,NColumn,V,H), getCell(Board,NRow,NColumn,0), NewRow = NRow, NewColumn = NColumn.
checkBoard(Row,Column,a,Board,NewRow,NewColumn,V,H):-getCell(Board,Row,Column,0), NewRow = Row, NewColumn = Column.
checkBoard(Row,Column,a,Board,NewRow,NewColumn,V,H):-checkDestination(Row,Column,a,Board,NRow,NColumn,V,H), getCell(Board,NRow,NColumn,0), NewRow = NRow, NewColumn = NColumn.
checkBoard(Row,Column,d,Board,NewRow,NewColumn,V,H):-getCell(Board,Row,Column,0), NewRow = Row, NewColumn = Column.
checkBoard(Row,Column,d,Board,NewRow,NewColumn,V,H):-checkDestination(Row,Column,d,Board,NRow,NColumn,V,H), getCell(Board,NRow,NColumn,0), NewRow = NRow, NewColumn = NColumn.


checkPos(h,HwallsCount,VwallsCount):- HwallsCount>0.
checkPos(v,HwallsCount,VwallsCount):-VwallsCount>0.

%checks if the wall the player is building is a legal move
checkWall(_Pos,V,H,Row,Column) :- Column < 10, Column >= 0, Row <13, Row >=0 ,!, checkSetWall(Pos,V,H,Row,Column), checkBlocksWay(Pos,V,H,Row,Column).

%checks if the wall is being positioned on top of any wall
checkSetWall(v,V,H,Row,Column):-!,getCell(V,Row,Column,0), NewRow is Row+1, getCell(V,NewRow,Column,0),checkSetWallV(V,H,Row,Column).
checkSetWall(h,V,H,Row,Column):-!,getCell(H,Row,Column,0), NewColumn is Column+1, getCell(H,Row,NewColumn,0),checkSetWallH(V,H,Row,Column).

%check if an intersection happens when putting a wall (against the rules).
checkSetWallV(V,H,Row,Column):-getCell(H,Row,Column,0).
checkSetWallV(V,H,Row,Column):-NewColumn is Column +1, getCell(H,Row,NewColumn,0).
checkSetWallH(V,H,Row,Column):-getCell(V,Row,Column,0).
checkSetWallH(V,H,Row,Column):-NewRow is Row+1, getCell(V,NewRow,Column,0).

%checks if the placement of the wall will block anyone from getting to any objective base.
%checks if the column is being filled, in other words, if that column already has 12 walls placed, nobody can place anything else on that column.
checkBlocksWay(v,V,H,Row,Column):-checkBlocksWay2(v,V,Row,Column,0,0).
checkBlocksWay(h,V,H,Row,Column):-checkBlocksWay2(h,H,Row,Column,0,0).

checkBlocksWay2(v,_,_,_,13,WallCounter):-WallCounter < 11.
checkBlocksWay2(v,Matrix,Row, Column, Counter,WallCounter):-getCell(Matrix,Counter,Column,Piece), NewWallCounter is WallCounter+Piece, NewCounter is Counter+1, checkBlocksWay2(v,Matrix,Row,Column, NewCounter, NewWallCounter).

%The matrix is 11x14, therefore it's impossible for the user to fill a row with walls (since they occupy 2 spaces each).
checkBlocksWay2(h,_,_,_,_,_).


checkGameOver(Board,Over):- getCell(Board,3,3,3), write('TEAM C AND D WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,3,3,4), write('TEAM C AND D WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,3,7,3), write('TEAM C AND D  WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,3,7,4), write('TEAM C AND D WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,10,3,1), write('TEAM A AND B  WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,10,3,2), write('TEAM A AND B WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,10,7,1), write('TEAM A AND B WINS!'), Over = 1.
checkGameOver(Board,Over):- getCell(Board,10,7,2), write('TEAM A AND B WINS!'), Over = 1.
checkGameOver(_,Over):- Over = 0.

checkNewGame(0).
checkNewGame(1).
checkNewGame(2).
checkNewGame(3).

checkDifficulty(0).
checkDifficulty(1).