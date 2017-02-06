:-include('Blockade_display').
:-include('Blockade_states').
:-include('Blockade_sets_gets').
:-include('Blockade_ai').


% ENGINE

% STARTS NEW GAME

start:-newgame.
newgame:-nl,write('Welcome to BLOCKADE board game, this game is made in prolog by Mario Fernandes and Luis Alves.'),nl,
write('Every input in this game needs to be followed by a dot, for example, if you want to choose menu 0, write "0.".'),nl,nl,
write('0. How to play'), nl , write('1. Player vs Player'),nl, write('2. Player vs AI'),nl, write('3. AI vs AI'), nl,read(X),checkNewGame(X), newgame(X).
newgame:-write('Please make valid inputs!'), nl,nl.

newgame(0):- write('How to play: The objective of the game is to get to one of the starting point of the opposing team with any of your pawns.'), nl,
write('Every turn you can move one of your pawns up to 2 cells in any direction you want and you can place one wall but remember that you only have 9 vertical and 9 horizontal walls!'),nl, 
write('Good Luck!'), nl, board_how_to_play(B),wall_vert_start(V), wall_hori_start(H),display_board(B,V,H),newgame.


newgame(1):- board_start(B), wall_vert_start(V), wall_hori_start(H), game(B,V,H,9,9,9,9,0).

newgame(2):- write('Choose the difficulty of  the computer (0 or 1): '), read(Difficulty),checkDifficulty(Difficulty),
board_start(B), wall_vert_start(V), wall_hori_start(H),  gamevscomputer(B,V,H,Difficulty,9,9,9,9,0).
newgame(2):- write('Wrong input'), nl, newgame.


newgame(3):-write('Choose the difficulty of  the 1st computer (0 or 1): '), read(Difficulty),checkDifficulty(Difficulty),
write('Choose the difficulty of  the 2nd computer (0 or 1): '), read(Difficulty2),checkDifficulty(Difficulty2),
board_start(B), wall_vert_start(V), wall_hori_start(H),  gameauto(B,V,H,Difficulty,Difficulty2,9,9,9,9,0).
newgame(3):-write('Wrong input'), nl, newgame.



% RECURSIVE PLAYER VS PLAYER GAME

game(Board,VWalls,HWalls,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,1).
game(Board,VWalls,HWalls,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,0):- display_board(Board,VWalls,HWalls),
player1Move(Board,VWalls,HWalls,NBoard,NVWalls,NHWalls,HwallsCount1,VwallsCount1,CountH,CountV,Over),game2(NBoard,NVWalls,NHWalls,CountH,CountV,HwallsCount2,VwallsCount2,Over).
game2(NBoard,NVWalls,NHWalls,CountH,CountV,HwallsCount2,VwallsCount2,1).
game2(NBoard,NVWalls,NHWalls,CountH,CountV,HwallsCount2,VwallsCount2,0):- display_board(NBoard,NVWalls,NHWalls), 
player2Move(NBoard,NVWalls,NHWalls,NNBoard,NNVWalls,NNHWalls,HwallsCount2,VwallsCount2,CountH2,CountV2,Over),
game(NNBoard,NNVWalls,NNHWalls,CountH,CountV,CountH2,CountV2,Over).

% Player moves (separated because of writings and function calls)
% Player 1 moves
player1Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):-getInfo1Piece(Piece), getInfoDirection(y,Direction), move(y,Piece,Direction,Board,NewBoard,V,H,Over), player1Move2(NewBoard,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV,Over).
player1Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):-write('Invalid move from 1!!!'),nl,player1Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over).

player1Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):- getInfoSecond(Response),getInfoDirection(Response,NDirection),move(Response,Piece,NDirection,Board,NBoard,V,H,Over), player1Move3(Board,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV,Over).
player1Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):- write('Invalid move from player 1!!!'),nl,player1Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over).
player1Move2(Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV,Over).

player1Move3(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):-getWallInfo(Answer,HwallsCount,VwallsCount), setWalls(Answer,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV).
player1Move3(Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV,Over).



% Player 2 moves
player2Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):- getInfo2Piece(Piece), getInfoDirection(y,Direction), move(y,Piece,Direction,Board,NewBoard,V,H,Over), player2Move2(NewBoard,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV,Over).
player2Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over):-write('Invalid move from player 2!!!'),nl,player2Move(Board,V,H,NBoard,NV,NH,HwallsCount,VwallsCount,CountH,CountV,Over).

player2Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):- getInfoSecond(Response),getInfoDirection(Response,NDirection),move(Response,Piece,NDirection,Board,NBoard,V,H,Over), player2Move3(Board,V,H,NBoard,NV,NH,Over,HwallsCount,VwallsCount,CountH,CountV,Over).
player2Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):- write('Invalid move from player 2!!!'),nl,player2Move2(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over).
player2Move2(Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV,Over).

player2Move3(Board,V,H,NBoard,NV,NH,0,HwallsCount,VwallsCount,CountH,CountV,Over):-getWallInfo(Answer,HwallsCount,VwallsCount), setWalls(Answer,V,H,NV,NH,HwallsCount,VwallsCount,CountH,CountV).
player2Move3(Board,V,H,NBoard,NV,NH,1,HwallsCount,VwallsCount,CountH,CountV,Over).


% RECURSIVE PLAYER VS COMPUTER GAME

gamevscomputer(Board,VWalls,HWalls,Difficulty,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,1).
gamevscomputer(Board,VWalls,HWalls,Difficulty,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,0):- display_board(Board,VWalls,HWalls),
player1Move(Board,VWalls,HWalls,NBoard,NVWalls,NHWalls,HwallsCount1,VwallsCount1,CountH,CountV,Over),gamevscomputer2(NBoard,NVWalls,NHWalls,Difficulty,CountH,CountV,HwallsCount2,VwallsCount2,Over).
gamevscomputer2(NBoard,NVWalls,NHWalls,Difficulty,CountH,CountV,HwallsCount2,VwallsCount2,1).
gamevscomputer2(NBoard,NVWalls,NHWalls,Difficulty,CountH,CountV,HwallsCount2,VwallsCount2,0):- display_board(NBoard,NVWalls,NHWalls),
compMove(2,Difficulty,NBoard,NVWalls,NHWalls,NNBoard,NNVWalls,NNHWalls,HwallsCount2,VwallsCount2,CountH2,CountV2,Over), 
gamevscomputer(NNBoard,NNVWalls,NNHWalls,Difficulty,CountH,CountV,CountH2,CountV2,Over).


% RECURSIVE COMPUTER VS COMPUTER GAME

gameauto(Board,VWalls,HWalls,Difficulty,Difficulty2,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,1).
gameauto(Board,VWalls,HWalls,Difficulty,Difficulty2,HwallsCount1,VwallsCount1,HwallsCount2,VwallsCount2,0):- display_board(Board,VWalls,HWalls), nl, write('Press anything followed by a dot to continue.'), read(X), nl,
compMove(0,Difficulty,Board,VWalls,HWalls,NBoard,NVWalls,NHWalls,HwallsCount1,VwallsCount1,CountH,CountV,Over),gameauto2(NBoard,NVWalls,NHWalls,Difficulty,Difficulty2,CountH,CountV,HwallsCount2,VwallsCount2,Over).
gameauto2(NBoard,NVWalls,NHWalls,Difficulty,Difficulty2,CountH,CountV,HwallsCount2,VwallsCount2,1).
gameauto2(NBoard,NVWalls,NHWalls,Difficulty,Difficulty2,CountH,CountV,HwallsCount2,VwallsCount2,0):- display_board(NBoard,NVWalls,NHWalls),
compMove(2,Difficulty2,NBoard,NVWalls,NHWalls,NNBoard,NNVWalls,NNHWalls,HwallsCount2,VwallsCount2,CountH2,CountV2,Over),
gameauto(NNBoard,NNVWalls,NNHWalls,Difficulty,Difficulty2,CountH,CountV,CountH2,CountV2,Over).


move(y,Piece,Direction,Board,NBoard,V,H,Answer):-
trading(Piece,PieceN),getCell(Board,Row,Column,PieceN),checkDestination(Row,Column,Direction,Board,NewRow,NewColumn,V,H), checkBoard(NewRow,NewColumn,Direction,Board,NewNewRow,NewNewColumn,V,H),
setCell(Board,NewNewRow,NewNewColumn,PieceN,NewBoard),setCell(NewBoard,Row,Column,0,NewNewBoard), display_board(NewNewBoard,V,H),NBoard = NewNewBoard, checkGameOver(NBoard,Answer).
move(n,Piece,Direction,Board,NBoard,V,H,Answer):-NBoard = Board.
