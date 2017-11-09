
/*****************************************
**** FUNCTIONS TO ADD AND MOVE PIECES ****
*****************************************/


/**
* Give a list of values.
**/
addNilSpaces(0, _, []).
addNilSpaces(Length, Value, [Value|NewList]):- 
NewLength is Length-1,
NewLength @>= 0,
addNilSpaces(NewLength, Value, NewList).


/**
* Insert new piece at specific position.
**/
insertAt(Piece,Column,Board,NewBoard) :-
same_length([Piece|Board],NewBoard),
append(Before,BoardAux,Board),
length(Before,Column),
append(Before,[Piece|BoardAux],NewBoard).


/**
* Replace one element on matrix.
**/
replace( L , X , Y , Z , R ) :-
append(RowPfx,[Row|RowSfx],L),     
length(RowPfx,X) ,                
append(ColPfx,[_|ColSfx],Row) ,   
length(ColPfx,Y) ,                 
append(ColPfx,[Z|ColSfx],RowNew) , 
append(RowPfx,[RowNew|RowSfx],R).  


/**
* Expands the board after the first move.
**/
addSpaceMatrix(Board, Length, NewBoard):-
addNilSpaces(Length, nil, AuxList1),
append([Board], [AuxList1], AuxNewBoard),
addNilSpaces(Length, nil, AuxList2),
append([AuxList2], AuxNewBoard, NewBoard).


/**
* First move.
**/
addPiece(Board, PieceCode, Color, Rotation, NewBoard):-
append([[PieceCode,Rotation,Color,0]], Board, AuxBoard),
append([nil], AuxBoard, AuxTwoBoard),
length(AuxTwoBoard,Length),
addSpaceMatrix(AuxTwoBoard, Length, NewBoard).


/**
* Following movements.
**/
addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard):-
replace(Board,Row,Column,[PieceCode,Rotation,Color,0], AuxBoard),
verifyExpandBoard(Row, Column, AuxBoard, NewBoard).


/**
* Move piece.
**/
movePiece(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, NewBoard):-
nth0(SourceRow, Board, RowBoard),
nth0(SourceColumn, RowBoard, Piece),
nth0(0, Piece, PieceCode),
nth0(2, Piece, Color),
replace(Board, SourceRow, SourceColumn, nil, NewBoardAux),
replace(NewBoardAux, DestRow, DestColumn, [PieceCode, Rotation, Color, 0], NewBoardAux2),
verifyExpandBoard(DestRow, DestColumn, NewBoardAux2, NewBoard).


/**
* Remove a piece of available pieces after playing.
**/
removePiecePlayed(ListAvailablePieces, PieceCode, NewListAvailablePieces):-
	delete(ListAvailablePieces, PieceCode, NewListAvailablePieces).


/**
* Checks if you need to expand the board
**/
% Case (0,-)
verifyExpandBoard(_Row, Column, Board, NewBoard) :- 
Column == 0, !,
length(Board,Height),
addColNilsLeft(Board, Height, NewBoard). 

% Case (-,0)
verifyExpandBoard(Row, _Column, Board, NewBoard) :- 
Row == 0, !,
addRowUp(Board, NewBoard).	

% Case (length, -)
verifyExpandBoard(Row, _Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
Row == Height, !,
addRowDown([H | T], NewBoard).

% Case (-, width)
verifyExpandBoard(_Row, Column, [H | T], NewBoard) :- 
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, !,
length([H | T],Height),
addColNilsRight([H | T], Height, NewBoard). 

% Default case
verifyExpandBoard(_Row, _Column, _Board, _Board).


/**
* Add col of nils to left of board.
**/
addColNilsLeft([], 0, []).
addColNilsLeft([H1 | T1], Height, [H2 | T2]) :-
append([nil], H1, H2),
NewHeight is Height - 1,
addColNilsLeft(T1, NewHeight, T2).


/**
* Add col of nils to right of board.
**/
addColNilsRight([], 0, []).
addColNilsRight([H1 | T1], Width, [H2 | T2]) :-
length(H1, Pos),
insertAt(nil, Pos, H1, H2),
NewWidth is Width - 1,
addColNilsRight(T1, NewWidth, T2).


/**
* Add row of nils to up of board.
**/
addRowUp([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([AuxList], [H1 | T1], NewBoard).


/**
* Add row of nils to down of board.
**/
addRowDown([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([H1 | T1], [AuxList], NewBoard).


/**
* Get all valid moves.
**/
getValidMoves(Board, ValidMoves) :-
	setof([X,Y], validMove(Board, X, Y), ValidMoves).


/**
* Check moves - ensures that the position is free and next to another piece.
**/
% Check if there is a piece in the row before.
validMove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, 
	
	BeforeNumRow is NumRow - 1,
	nth0(BeforeNumRow, Board, RowBefore),
	nth0(NumCol, RowBefore, CellBefore),
	CellBefore \== nil.

% Check if there is a piece in the row after.
validMove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, 

	AfterNumRow is NumRow + 1,
	nth0(AfterNumRow, Board, RowAfter),
	nth0(NumCol, RowAfter, CellAfter),
	CellAfter \== nil.

% Check if there is a piece in the column before.
validMove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, 

	BeforeNumColumn is NumCol - 1,
	nth0(NumRow, Board, Row),
	nth0(BeforeNumColumn, Row, CellBefore),
	CellBefore \== nil.

% Check if there is a piece in the column after.
validMove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, 
	
	AfterNumColumn is NumCol + 1,
	nth0(NumRow, Board, Row),
	nth0(AfterNumColumn, Row, CellAfter),
	CellAfter \== nil.


/**
* Remove a piece - ensures that the position is occupied and has a free seat next to it.
**/
% Check if there isn't  a piece in the row before.
getValidPostionToRemove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen \== nil, % cell is not free
	
	BeforeNumRow is NumRow - 1,
	nth0(BeforeNumRow, Board, RowBefore),
	nth0(NumCol, RowBefore, CellBefore),
	CellBefore == nil.

% Check if there isn't  a piece in the row after.
getValidPostionToRemove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen \== nil, % cell is free

	AfterNumRow is NumRow + 1,
	nth0(AfterNumRow, Board, RowAfter),
	nth0(NumCol, RowAfter, CellAfter),
	CellAfter == nil.

% Check if there isn't  a piece in the column before.
getValidPostionToRemove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen \== nil, % cell is free

	BeforeNumColumn is NumCol - 1,
	nth0(NumRow, Board, Row),
	nth0(BeforeNumColumn, Row, CellBefore),
	CellBefore == nil.

% Check if there isn't a piece in the column after.
getValidPostionToRemove(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen \== nil, % cell is free
	
	AfterNumColumn is NumCol + 1,
	nth0(NumRow, Board, Row),
	nth0(AfterNumColumn, Row, CellAfter),
	CellAfter == nil.


/**
* Check if a piece of a certain position belongs to the player.
**/
checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer) :-
	nth0(SourceRow, Board, RowBoard),
	nth0(SourceColumn, RowBoard, Piece),
	nth0(2, Piece, ColorPiece),
	ColorPiece == ColorPlayer.