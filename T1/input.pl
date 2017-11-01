/**************************
**** FUNCTIONS OF INPUT ****
**************************/

checkIfMoveIsValid(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, % cell is free
	
	% Check if there is a piece in the row before
	BeforeNumRow is NumRow - 1,
	nth0(BeforeNumRow, Board, RowBefore),
	nth0(NumCol, RowBefore, CellBefore),
	CellBefore \== nil,
	write('passou 1 : valida'), nl.



checkIfMoveIsValid(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, % cell is free

	%Check if there is a piece in the row after
	AfterNumRow is NumRow + 1,
	nth0(AfterNumRow, Board, RowAfter),
	nth0(NumCol, RowAfter, CellAfter),
	CellAfter \== nil,
	write('passou 2 : valida'), nl.



checkIfMoveIsValid(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, % cell is free

	%Check if there is a piece in the column before
	BeforeNumColumn is NumCol - 1,
	nth0(NumRow, Board, Row),
	nth0(BeforeNumColumn, Row, CellBefore),
	CellBefore \== nil,
	write('passou 3 : valida'), nl.


checkIfMoveIsValid(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, % cell is free
	
	%Check if there is a piece in the column after
	AfterNumColumn is NumCol + 1,
	nth0(NumRow, Board, Row),
	nth0(AfterNumColumn, Row, CellAfter),
	CellAfter \== nil,
	write('passou 4 : valida'), nl.


	

betweeMinMax(Min, Max, Num):-
	Num >= Min,
	Num =< Max.

askBoardPosition(Board, Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol):-
	firstMove(X), X == 1.
askBoardPosition([Head | Tail], NumRow, NumCol):-
	write('Row: '),
	once(read(NumRow)), 
	length([Head | Tail], RowMax),
	NRowMax is RowMax - 1,
	betweeMinMax(0, NRowMax, NumRow), !,
	write('Column: '), once(read(NumCol)), nl,
	length(Head, ColumnMax),
	NColumnMax is ColumnMax - 1,
	betweeMinMax(0, NColumnMax, NumCol).


askRotation(Rotation):-
	write('Rotation (0 - 0 degrees, 1 - 90 degrees, 2 - 180 degrees, 3 - 270 degrees): '),
	once(read(Rotation)), !,
	member(Rotation, [0,1,2,3]).


askNextPiece(Pieces, Letter):-
	nl, write('Next Piece: '),
	once(read(Letter)),
	member(Letter, Pieces).


askInput(Board, Pieces, Letter, ColorPlayer, Rotation):-
	repeat,
	once(askNextPiece(Pieces, Letter)),
	once(askRotation(Rotation)).


askInput(Board, Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol):-
	repeat,
	once(askNextPiece(Pieces, Letter)),
	once(askRotation(Rotation)),
	once(askBoardPosition(Board, NumRow, NumCol)),
	once(checkIfMoveIsValid(Board, NumRow, NumCol)).

askMenuInput(Options, Option):-
	nl, write('Choose option: '),
	read(Option),
	member(Option, Options).