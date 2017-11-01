:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(system)).

:-include('print.pl').
:-include('input.pl').
%:-include('checkGameStatus.pl').

:- dynamic firstMove/1.

firstMove(1).


/**************************
**** FUNCTIONS TO MOVE ****
**************************/


%give a list of values
addNilSpaces(0, _, []).
addNilSpaces(Length, Value, [Value|NewList]):- 
NewLength is Length-1,
NewLength @>= 0,
addNilSpaces(NewLength, Value, NewList).

%insert new piece at specific position
insertAt(Piece,Column,Board,NewBoard) :-
same_length([Piece|Board],NewBoard),
append(Before,BoardAux,Board),
length(Before,Column),
append(Before,[Piece|BoardAux],NewBoard).

%replace one element on matrix
replace( L , X , Y , Z , R ) :-
append(RowPfx,[Row|RowSfx],L),     % decompose the list-of-lists into a prefix, a list and a suffix
length(RowPfx,X) ,                 % check the prefix length: do we have the desired list?
append(ColPfx,[_|ColSfx],Row) ,    % decompose that row into a prefix, a column and a suffix
length(ColPfx,Y) ,                 % check the prefix length: do we have the desired column?
append(ColPfx,[Z|ColSfx],RowNew) , % if so, replace the column with its new value
append(RowPfx,[RowNew|RowSfx],R).  % and assemble the transformed list-of-lists

addSpaceMatrix(Board, Length, NewBoard):-
addNilSpaces(Length, nil, AuxList1),
append([Board], [AuxList1], AuxNewBoard),
addNilSpaces(Length, nil, AuxList2),
append([AuxList2], AuxNewBoard, NewBoard).



/**
* Add a piece to the board
**/

%first move
addPiece(Board, PieceCode, Color, Rotation, NewBoard, NewColor):-
append([[PieceCode,Rotation,Color,0]], Board, AuxBoard),
append([nil], AuxBoard, AuxTwoBoard),
length(AuxTwoBoard,Length),
addSpaceMatrix(AuxTwoBoard, Length, NewBoard).

addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard, NewColor):-
%verificar position se é válida (se esta vazia, ou se  está ao de uma peça já colocada)
replace(Board,Row,Column,[PieceCode,Rotation,Color,0], AuxBoard),
verifyExpandBoard(Row, Column, AuxBoard, NewBoard).




/**
* Checks if you need to expand the board
**/

%(0,0)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Column == 0, Row == 0, !,
addRowUp(Board, AuxBoard),
length(AuxBoard,Height),
addColNilsLeft(AuxBoard, Height, NewBoard). 

%(length, width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, Row == Height, !,
addRowDown([H | T], AuxBoard),
length(AuxBoard, NewHeight),
addColNilsRight(AuxBoard, NewHeight, NewBoard). 

%(0,width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, Row == 0, !,
addRowUp([H | T], AuxBoard),
length(AuxBoard,Height),
addColNilsRight(AuxBoard, Height, NewBoard). 

% Case (length, 0)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
Row == Height, Column == 0, !,
addRowDown([H | T], AuxBoard),
length(AuxBoard,NewHeight),
addColNilsLeft(AuxBoard, NewHeight, NewBoard). 

% Case (0,-)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Column == 0, !,
length(Board,Height),
addColNilsLeft(Board, Height, NewBoard). 

% Case (-,0)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Row == 0, !,
addRowUp(Board, NewBoard).	

% Case (length, -)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
Row == Height, !,
addRowDown([H | T], NewBoard).

% Case (-, width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, !,
length(Board,Height),
addColNilsRight([H | T], Height, NewBoard). 

% Default case
verifyExpandBoard(Row, Column, Board, Board).



%add col of nils to left
addColNilsLeft([], 0, []).
addColNilsLeft([H1 | T1], Height, [H2 | T2]) :-
append([nil], H1, H2),
NewHeight is Height - 1,
addColNilsLeft(T1, NewHeight, T2).

%add col of nils to right
addColNilsRight([], 0, []).
addColNilsRight([H1 | T1], Width, [H2 | T2]) :-
length(H1, Pos),
insertAt(nil, Pos, H1, H2),
NewWidth is Width - 1,
addColNilsRight(T1, NewWidth, T2).

%add row of nils to up
addRowUp([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([AuxList], [H1 | T1], NewBoard).

%add row of nils to down
addRowDown([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([H1 | T1], [AuxList], NewBoard).


removePiecePlayed(ListAvailablePieces, PieceCode, NewListAvailablePieces):-
delete(ListAvailablePieces, PieceCode, NewListAvailablePieces).


/**
* Human vs Human
**/
game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
firstMove(X), X == 1,!,
printInfoColor(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
askInput(Board, PiecesWhite, Letter, ColorPlayer, Rotation),
addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard, NewColor),
removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
NewColorPlayer is ColorPlayer - 1,
retract(firstMove(X)),
game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
ColorPlayer == 1, !,
printInfoColor(ColorPlayer), sleep(1),
prepareBoard(Board), sleep(2),
printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
askInput(Board, PiecesWhite, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor),
removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
NewColorPlayer is ColorPlayer - 1,
% adicionar condição de ganhar jogo
game2Players(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer).

game2Players(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
printInfoColor(ColorPlayer), sleep(1),
prepareBoard(Board), sleep(2),
printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
askInput(Board, PiecesBlack, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor),
removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
NewColorPlayer is ColorPlayer + 1,
% adicionar condição de ganhar jogo
game2Players(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer).




/**
* Human vs Computer
**/
gameHumanVsComputer(Board, Pieces, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
firstMove(X), X == 1,!,
printInfoType(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, Pieces]), sleep(1),
askInput(Board, Pieces, Letter, ColorPlayer, Rotation),
addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
removePiecePlayed(Pieces, Letter, NewListAvailablePieces),
NewColorPlayer is ColorPlayer - 1,
retract(firstMove(X)),
gameHumanVsComputer(NewBoard, NewListAvailablePieces, PiecesBlack, NewColorPlayer).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
ColorPlayer == 1, !,
printInfoType(ColorPlayer), sleep(1),
prepareBoard(Board), sleep(2),
printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
askInput(Board, PiecesWhite, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
NewColorPlayer is ColorPlayer - 1,
% adicionar condição de ganhar jogo
gameHumanVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer).

gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
ColorPlayer == 0, !,
printInfoType(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
computerMove(Board, PiecesWhite, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
prepareBoard(NewBoard), nl, sleep(2),
removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
NewColorPlayer is ColorPlayer + 1,
gameHumanVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer).


computerMove([H|T], Pieces, Letter, ColorPlayer, Rotation) :-
repeat,
once(getPieceLetter(Pieces, Letter)),
once(getRotation(Rotation)), nl,
write('-> Computer played piece '), write(Letter), nl, nl.

computerMove([H|T], Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol) :-
repeat,
once(getPieceLetter(Pieces, Letter)),
once(getRotation(Rotation)),
once(getPosition([H|T], NumRow, NumCol)),
once(checkIfMoveIsValid([H|T], NumRow, NumCol)), nl,
write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

getPieceLetter(Pieces, Letter) :- 	
length(Pieces, AuxNumPieces),
NumPieces is AuxNumPieces - 1,
random(0, NumPieces, PosPiece),
nth0(PosPiece, Pieces, Letter).

getRotation(Rotation) :-
random(0, 3, Rotation).

getPosition([H|T], NumRow, NumCol) :-
length([H|T], AuxNumRows),
NumRows is AuxNumRows - 1,
random(0, NumRows, NumRow),
length(H, AuxNumCols),
NumCols is AuxNumCols - 1,
random(0, NumCols, NumCol).


/**
* Computer vs Computer
**/
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
firstMove(X), X == 1,!,
printInfoColorComputer(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
computerMove(Board, PiecesWhite, Letter, ColorPlayer, Rotation),
addPiece(Board, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
prepareBoard(NewBoard), nl, sleep(3),
removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
NewColorPlayer is ColorPlayer - 1,
retract(firstMove(X)),
gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
ColorPlayer == 1, !,
printInfoColorComputer(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, PiecesWhite]), sleep(1),
computerMove(Board, PiecesWhite, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
prepareBoard(NewBoard), nl, sleep(3),
removePiecePlayed(PiecesWhite, Letter, NewPiecesWhite),
NewColorPlayer is ColorPlayer - 1,
% adicionar condição de ganhar jogo
gameComputerVsComputer(NewBoard, NewPiecesWhite, PiecesBlack, NewColorPlayer).

gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, ColorPlayer) :-
write('\33\[2J'),
ColorPlayer == 0, !,
printInfoColorComputer(ColorPlayer), sleep(1),
printAvailablePieces(0, [ColorPlayer, PiecesBlack]), sleep(1),
computerMove(Board, PiecesBlack, Letter, ColorPlayer, Rotation, NumRow, NumCol),
addPiece(Board, NumRow, NumCol, Letter, ColorPlayer, Rotation, NewBoard, NewColor), sleep(1),
prepareBoard(NewBoard), nl, sleep(3),
removePiecePlayed(PiecesBlack, Letter, NewPiecesBlack),
NewColorPlayer is ColorPlayer + 1,
gameComputerVsComputer(NewBoard, PiecesWhite, NewPiecesBlack, NewColorPlayer).



vertifyDraw(PiecesWhite, PiecesBlack, Draw) :-
length(PiecesBlack, NumPiecesBlack),
length(PiecesWhite, NumPiecesWhite),
NumPiecesWhite == 0,
NumPiecesBlack == 0, !,
Draw = 1.



/****************
**** TESTING ****
*****************/

teste1 :- 
prepareBoard([
	[nil, nil, nil, nil, nil],
	[nil, nil, [a, 3, 0, 0], [b, 1, 0, 0], nil],
	[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
	[nil, nil, nil, nil, nil]
	]).

teste_replace:-
board2(Board),
prepareBoard(Board),
prepareBoard(NewBoard2).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [0,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


%Test for print first move.
teste3 :- board1(Board), addPiece(Board, 1, 1, a, 0, 3, NewBoard, NewColor),
addPiece(NewBoard, 2, 1, a, 0, 3, NewBoard2, NewColor), prepareBoard(NewBoard2).


%test add multiples nils in a row
teste4 :- addNilSpaces( 5, nil, List).

%Test for print first move.
teste5 :- board2(Board), addPiece(Board, 2, 0, b, 1, 3, NewBoard, NewColor), prepareBoard(NewBoard).

teste7 :- board2(Board), addColNilsRight(Board, 3, NewBoard), write(NewBoard). %prepareBoard(NewBoard).


board1([nil]).
board2([
	[nil, nil, nil],
	[nil, [a, 3, 0, 0], nil],
	[nil, nil, nil ]
	]).

piecesWhite([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]).
piecesBlack([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]).
options([1, 2, 3]).



/***************************
******** MAIN GAME *********
***************************/

ni_ju :- 
write('\33\[2J'),
printMenuScreen(X),
options(Options),
askMenuInput(Options, Option),
initGame(Option).


initGame(Option):-
Option == 1, !,
write('Option 1'), nl,
write('\33\[2J'),
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
game2Players(Board, PiecesWhite, PiecesBlack, 1).

initGame(Option):-
Option == 2, !,
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
gameHumanVsComputer(Board, PiecesWhite, PiecesBlack, 1).

initGame(Option):-
write('\33\[2J'),
board1(Board),
piecesBlack(PiecesBlack),
piecesWhite(PiecesWhite),
gameComputerVsComputer(Board, PiecesWhite, PiecesBlack, 1).