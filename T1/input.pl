/**************************
**** FUNCTIONS OF INPUT ****
**************************/

checkIfMoveIsValid(Board, NumRow, NumCol):-
	nth0(NumRow, Board, RowChosen),
	nth0(NumCol, RowChosen, CellChosen),
	CellChosen == nil, % cell is free
	BeforeNumRow is NumRow - 1,

	% Check if there is a piece in the row before
	nth0(BeforeNumRow, Board, RowBefore),
	nth0(NumCol, RowBefore, CellBefore),
	CellBefore \== nil,
	nl, write(CellAfter),nl,
	write('Valid Move!'),nl.
checkIfMoveIsValid(Board, NumRow, NumCol):-
	%Check if there is a piece in the row after
	AfterNumRow is NumRow + 1,
	nth0(AfterNumRow, Board, RowAfter),
	nth0(NumCol, RowAfter, CellAfter),
	CellAfter \== nil,
	nl, write(CellAfter),nl,
	write('Valid Move!'),nl.
checkIfMoveIsValid(Board, NumRow, NumCol):-
	%Check if there is a piece in the column before
	BeforeNumColumn is NumCol - 1,
	nth0(NumRow, Board, Row),
	nth0(BeforeNumColumn, Row, CellBefore),
	CellBefore \== nil,
	nl, write(CellAfter),nl,
	write('Valid Move!'),nl.
checkIfMoveIsValid(Board, NumRow, NumCol):-
	%Check if there is a piece in the column after
	AfterNumColumn is NumCol + 1,
	nth0(NumRow, Board, Row),
	nth0(AfterNumColumn, Row, CellAfter),
	CellAfter \== nil,
	nl, write(CellAfter),nl,
	write('Valid Move!'),nl.
/*	
checkIfMoveIsValid(Board, NumRow, NumCol):-
	write('Invalid move, please choose another'), nl,*/
	

between(Min, Max, Num):-
	Num >= Min,
	Num =< Max.

askBoardPosition(Board, Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol):-
	firstMove(X), X == 1, !.
askBoardPosition([Head | Tail], NumRow, NumCol):-
	write('Row: '),
	once(read(NumRow)), nl,
	length([Head | Tail], RowMax),
	NRowMax is RowMax - 1,
	between(0, NRowMax, NumRow),
	!, write('Column: '), once(read(NumCol)), nl,
	length(Head, ColumnMax),
	NColumnMax is ColumnMax - 1,
	between(0, NColumnMax, NumCol).
	%write('AAAAAAAAAASSSSSSSSSSKKKKKKKKKK'),nl, write(NumRow), nl, write(NumCol),
askBoardPosition(Board, NumRow, NumCol):- 
	askBoardPosition(Board, NewNumRow, NewNumCol).


askRotation(Rotation):-
	write('Rotation (0 - 0 degrees, 1 - 90 degrees, 2 - 180 degrees, 3 - 270 degrees): '),
	once(read(Rotation)), nl,
	member(Rotation, [0,1,2,3]).
askRotation(Rotation):-
	askRotation(NewRotation).

askNextPiece(Pieces, Letter):-
	write('Next Piece: '),
	once(read(Letter)), nl,
	member(Letter, Pieces).
askNextPiece(Pieces, Letter):-
	askNextPiece(Pieces, NewLetter).

askInput(Board, Pieces, Letter, ColorPlayer, Rotation):-
	askNextPiece(Pieces, Letter),
	askRotation(Rotation),!.
askInput(Board, Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol):-
	askNextPiece(Pieces, Letter),
	askRotation(Rotation),
	askBoardPosition(Board, NumRow, NumCol),
	checkIfMoveIsValid(Board, NumRow, NumCol),!.
askInput(Board, Pieces, Letter, ColorPlayer, Rotation, NumRow, NumCol):-
	askInput(Board, Pieces, NewLetter, ColorPlayer, NewRotation, NewNumRow, NewNumCol).


testeInput :- pieces(Pieces), askNextPiece([[nil, nil, nil],[nil,[a,1,0,0],nil],[nil,nil,nil]],Pieces, 0).

pieces([a,b,c,d,h,s,t]).