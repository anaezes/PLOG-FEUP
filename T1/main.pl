
:-include('utils.pl').

:- dynamic firstMove/1.

firstMove(1).

removePiecePlayed(ListAvailablePieces, PieceCode, NewListAvailablePieces):-
delete(ListAvailablePieces, PieceCode, NewListAvailablePieces).



/**
* Human vs Human
**/
game2Players(Board, PiecesWhite, PiecesBlack, Draw) :-
	clearScreen,
	ColorPlayer = 1,
	printInfoColor(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	askInput(Board, PiecesWhite, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	ColorPlayer == 1, !,
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	askInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	vertifyDraw(NewPiecesWhite, PiecesBlack, Draw),
	game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
	askInput(Board, PiecesBlack, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1,
	% adicionar condição de ganhar jogo
	vertifyDraw(PiecesWhite, NewPiecesBlack, Draw), 
	game2Players(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, Draw).


/* After Draw */
game2Players(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1)  :- game2Players(Board, ColorPlayer).
game2Players(Board, ColorPlayer) :-
	clearScreen,
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	askInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoard),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	game2Players(NewBoard, NewColorPlayer).






/**
* Human vs Computer
**/
gameHumanVsComputer(Board, Pieces, PiecesBlack, Draw) :-
	clearScreen,
	ColorPlayer = 1,
	printInfoType(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, Pieces]), sleep(1),
	askInput(Board, Pieces, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	removePiecePlayed(Pieces, Letter, NewListAvailablePieces),
	NewColorPlayer is ColorPlayer - 1,
	gameHumanVsComputer(NewBoard, NewListAvailablePieces, PiecesBlack, NewColorPlayer, Draw).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	ColorPlayer == 1, !,
	printInfoType(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	askInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	vertifyDraw(NewPiecesWhite, PiecesBlack, Draw),
	gameHumanVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	ColorPlayer == 0, !,
	printInfoType(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
	computerInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	prepareBoard(NewBoard), nl, sleep(2),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1,
	vertifyDraw(PiecesWhite, NewPiecesBlack, Draw),
	gameHumanVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, Draw).

/* After Draw */
gameHumanVsComputer(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1)  :- gameHumanVsComputer(Board, ColorPlayer).
gameHumanVsComputer(Board, ColorPlayer) :-
	clearScreen,
	ColorPlayer == 1, !,
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	askInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoard),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	gameHumanVsComputer(NewBoard, NewColorPlayer).

gameHumanVsComputer(Board, ColorPlayer) :-
	clearScreen,
	ColorPlayer == 0, !,
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoard),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	gameHumanVsComputer(NewBoard, NewColorPlayer).





/**
* Computer vs Computer
**/
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, Draw) :-
	clearScreen,
	ColorPlayer = 1,
	printInfoColorComputer(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	computerInput(Board, PiecesWhite, Letter, Rotation),
	addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	prepareBoard(NewBoard), nl, sleep(3),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, Draw).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	Draw == 0, 
	ColorPlayer == 1, !,
	printInfoColorComputer(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
	computerInput(Board, PiecesWhite, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	prepareBoard(NewBoard), nl, sleep(3),
	removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	vertifyDraw(NewPiecesWhite, PiecesBlack, NewDraw),
	gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer, NewDraw).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer, Draw) :-
	clearScreen,
	Draw == 0, 
	ColorPlayer == 0, !,
	printInfoColorComputer(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
	computerInput(Board, PiecesBlack, Letter, Rotation, NumRow, NumCol),
	addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard), sleep(1),
	prepareBoard(NewBoard), nl, sleep(3),
	removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
	NewColorPlayer is ColorPlayer + 1, !,
	% adicionar condição de ganhar jogo
	vertifyDraw(PiecesWhite, NewPiecesBlack, NewDraw), 
	gameComputerVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer, NewDraw).


/* After Draw */
gameComputerVsComputer(Board, _PiecesWhite, _PiecesBlack, ColorPlayer, 1)  :- 
	gameComputerVsComputer(Board, ColorPlayer).

gameComputerVsComputer(Board, ColorPlayer) :-
	write('draw!!!!!!!!!'),
	clearScreen,	
	printInfoColor(ColorPlayer), sleep(1),
	prepareBoard(Board), sleep(2),
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer),
	movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoard),
	NewColorPlayer is ColorPlayer - 1,
	% adicionar condição de ganhar jogo
	gameComputerVsComputer(NewBoard, NewColorPlayer).





/* Verify Draw */
vertifyDraw(PiecesWhite, PiecesBlack, NewDraw) :-
	length(PiecesBlack, NumPiecesBlack),
	length(PiecesWhite, NumPiecesWhite),
	NumPiecesWhite == 0,
	NumPiecesBlack == 0, !,
	NewDraw = 1.

vertifyDraw(_PiecesWhite, _PiecesBlack, NewDraw) :- 
	!, NewDraw = 0.





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
initGame(Option).


initGame(Option):-
Option == 1, !,
write('Option 1'), nl,
clearScreen,
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
game2Players(Board, PiecesWhite, PiecesBlack, 0),
ni_ju.

initGame(Option):-
Option == 2, !,
write('Option 2'), nl,
clearScreen,
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, 0),
ni_ju.

initGame(Option):-
Option == 3, !,
write('Option 3'), nl,
write('Not Available!!!!'), nl.

initGame(Option):-
Option == 4, !,
write('Option 4'), nl,
clearScreen,
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, 0),
ni_ju.

initGame(Option):-
Option == 5, 
write('Option 5'), nl,
write('Not Available!!!!'), nl.





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

testeMove :- board3(Board), prepareBoard(Board),
	movePiece(Board, 1, 4, 3, 1, 1, NewBoard), prepareBoard(NewBoard).