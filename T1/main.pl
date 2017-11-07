
:-include('utils.pl').




/**
* Human vs Human
**/
game2Players(Board, PiecesWhite, PiecesBlack, Draw, GameEnd) :-
	clearScreen,
	ColorPlayer = 1,
	printInfoColor(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	askInput(Board, PiecesWhite, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw, GameEnd).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, ColorPlayer == 1, !,
	printInfoGame1(Board, ColorPlayer, PiecesWhite),
	askInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(NewPiecesWhite, PiecesBlack, NewDraw),
	game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, NewDraw, NewGameEnd).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, 
	printInfoGame1(Board, ColorPlayer, PiecesBlack),
	askInput(Board, PiecesBlack, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(PiecesWhite, NewPiecesBlack, NewDraw), 
	game2Players(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, NewDraw, NewGameEnd).


/* After Draw */
game2Players(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1, GameEnd)  :- 
	game2Players(Board, ColorPlayer, GameEnd).

game2Players(Board, ColorPlayer, GameEnd) :-
	clearScreen, GameEnd \== 1,
	printInfoGame2(Board, ColorPlayer),
	askInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoardAux),
	NewColorPlayer is mod((ColorPlayer + 1), 2),
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	game2Players(NewBoard, NewColorPlayer, NewGameEnd).

/* End Game */
game2Players(_Board, ColorPlayer, 1)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getColorPlayer(WinColorPlayer, Color),
	printInfoWinGame(Color).

game2Players(_Board, _PiecesWhite, _PiecesBlack, ColorPlayer, _Draw, 1)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getColorPlayer(WinColorPlayer, Color),
	printInfoWinGame(Color).





/**
* Human vs Computer Level I
**/
gameHumanVsComputer(Board, Pieces, PiecesBlack, Draw, GameEnd, Level) :-
	clearScreen,
	Draw == 0, ColorPlayer = 1,
	printInfoType(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, Pieces]), sleep(1),
	askInput(Board, Pieces, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	removePiecePlayed(Pieces, Letter, NewListAvailablePieces),
	NewColorPlayer is ColorPlayer - 1,
	gameHumanVsComputer(NewBoard, NewListAvailablePieces, PiecesBlack, NewColorPlayer, Draw, GameEnd, Level).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, ColorPlayer == 1, !,
	printInfoGame1(Board, ColorPlayer, PiecesWhite),
	askInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux), sleep(1),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(NewPiecesWhite, PiecesBlack, NewDraw),
	gameHumanVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, NewDraw, NewGameEnd, Level).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, ColorPlayer == 0, !,
	printInfoGame1(Board, ColorPlayer, PiecesBlack),
	computerInput(Board, PiecesWhite, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux), sleep(1),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(PiecesWhite, NewPiecesBlack, NewDraw),
	gameHumanVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, NewDraw, NewGameEnd, Level).

/* After Draw */
gameHumanVsComputer(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1, GameEnd, Level)  :- 
	gameHumanVsComputer(Board, ColorPlayer, GameEnd, Level).
gameHumanVsComputer(Board, ColorPlayer, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, ColorPlayer == 1, !,
	printInfoGame2(Board, ColorPlayer),
	askInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoardAux),
	NewColorPlayer is ColorPlayer - 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	gameHumanVsComputer(NewBoard, NewColorPlayer, NewGameEnd,Level).

gameHumanVsComputer(Board, ColorPlayer, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, ColorPlayer == 0, !,
	printInfoGame2(Board, ColorPlayer),
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoardAux),
	NewColorPlayer is ColorPlayer + 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	gameHumanVsComputer(NewBoard, NewColorPlayer, GameEnd, NewGameEnd, Level).


/* End Game */
gameHumanVsComputer(_Board, _PiecesWhite, _PiecesBlack, ColorPlayer, _Draw, 1, Level)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getTypePlayer(WinColorPlayer, Type),
	printInfoWinGameType(Type).

gameHumanVsComputer(_Board, ColorPlayer, 1, Level)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getTypePlayer(WinColorPlayer, Type),
	printInfoWinGameType(Type).



/**
* Computer vs Computer Level
**/
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, Draw, GameEnd, Level) :-
	clearScreen,
	ColorPlayer = 1,
	printInfoColorComputer(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	computerInput(Board, PiecesWhite, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	printBoardMain(NewBoard), nl, sleep(3),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw, GameEnd, Level).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, ColorPlayer == 1, !,
	printInfoGame1(Board, ColorPlayer, PiecesWhite),
	computerInput(Board, PiecesWhite, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux), sleep(1),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(NewPiecesWhite, PiecesBlack, NewDraw),
	gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, NewDraw, NewGameEnd, Level).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, Draw == 0, ColorPlayer == 0, !,
	printInfoGame1(Board, ColorPlayer, PiecesBlack),
	computerInput(Board, PiecesBlack, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoardAux), sleep(1),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1, !,
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	vertifyDraw(PiecesWhite, NewPiecesBlack, NewDraw), 
	gameComputerVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, NewDraw, NewGameEnd, Level).


/* After Draw */
gameComputerVsComputer(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1, GameEnd, Level)  :- 
	gameComputerVsComputer(Board, ColorPlayer, GameEnd, Level).

gameComputerVsComputer(Board, ColorPlayer, GameEnd, Level) :-
	clearScreen,
	GameEnd \== 1, 	
	printInfoGame2(Board, ColorPlayer),
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoardAux),
	NewColorPlayer is mod((ColorPlayer + 1), 2),
	checkGameEnd(NewBoardAux, NewInvalidPieces, NewGameEnd),
	updateBoard(NewInvalidPieces, NewBoardAux, NewBoard),
	printBoardMain(NewBoard), nl, sleep(3),
	gameComputerVsComputer(NewBoard, NewColorPlayer,  NewGameEnd, Level).


/* End Game*/
gameComputerVsComputer(_Board, _PiecesWhite, _PiecesBlack, ColorPlayer, _Draw, 1, Level)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getColorPlayer(WinColorPlayer, Color),
	printInfoWinGame(Color).

gameComputerVsComputer(_Board, ColorPlayer, 1, Level)  :- 
	WinColorPlayer is mod((ColorPlayer + 1), 2),
	getColorPlayer(WinColorPlayer, Color),
	printInfoWinGame(Color).


/* Verify Draw */
vertifyDraw(PiecesWhite, PiecesBlack, NewDraw) :-
	length(PiecesBlack, NumPiecesBlack),
	length(PiecesWhite, NumPiecesWhite),
	NumPiecesWhite == 0,
	NumPiecesBlack == 0, !,
	NewDraw = 1.

vertifyDraw(_PiecesWhite, _PiecesBlack, NewDraw) :- 
	!, NewDraw = 0.


removePiecePlayed(ListAvailablePieces, PieceCode, NewListAvailablePieces):-
delete(ListAvailablePieces, PieceCode, NewListAvailablePieces).

printInfoGame1(Board, ColorPlayer, Pieces) :- 
	printInfoColorComputer(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, Pieces]), sleep(1),
	printBoardMain(Board), nl, sleep(3).

printInfoGame2(Board, ColorPlayer) :- 
	printInfoColorComputer(ColorPlayer), sleep(1).
	%printBoardMain(Board), nl, sleep(3).



/***************************
******** MAIN GAME *********
***************************/

board1([nil]).
piecesWhite([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]).
piecesBlack([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]).

options([1, 2, 3, 4, 5]).

ni_ju :- 
clearScreen,
printMenuScreen,
options(Options),
askMenuInput(Options, Option),
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
initGame(Option, Board, PiecesWhite, PiecesBlack).


initGame(Option, Board, PiecesWhite, PiecesBlack):-
Option == 1, !,
write('Option 1'), nl,
clearScreen,

game2Players(Board, PiecesWhite, PiecesBlack, 0, 0),
ni_ju.

initGame(Option, Board, PiecesWhite, PiecesBlack):-
Option == 2, !,
write('Option 2'), nl,
clearScreen,
gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, 0, 0, 1),
ni_ju.

initGame(Option, Board, PiecesWhite, PiecesBlack):-
Option == 3, !,
write('Option 3'), nl,
clearScreen,
gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, 0, 0, 2),
ni_ju.

initGame(Option, Board, PiecesWhite, PiecesBlack):-
Option == 4, !,
write('Option 4'), nl,
clearScreen,
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, 0, 0, 1),
ni_ju.

initGame(Option, Board, PiecesWhite, PiecesBlack):-
Option == 5, !,
write('Option 5'), nl,
clearScreen,
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, 0, 0, 2),
ni_ju.





/****************
**** TESTING ****
*****************/

board2([
	[nil, nil, nil],
	[nil, [a, 3, 0, 0], nil],
	[nil, nil, nil ]
	]).

board3([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, [j, 0, 1, 0], nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 0], [p, 0, 0, 0], nil],
	[nil, nil, nil, nil, [o, 0, 1, 0], nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]).

board4([
	[nil, nil, nil],
	[nil, [a, 3, 0, 0], nil],
	[nil, nil, nil ]
	]).

testeMove :- board3(Board), printBoardMain(Board),
	movePiece(Board, 1, 4, 3, 1, 1, NewBoard), printBoardMain(NewBoard).

testeCheck(X,Y) :- board3(Board), validMove(Board, X, Y).