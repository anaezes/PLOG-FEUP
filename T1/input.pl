/**************************
**** FUNCTIONS OF INPUT ****
**************************/

checkIfMoveIsValid(Board, Letter, Rotation, ColorPlayer, NumRow, NumColumn):-
	nth1(NumRow, Board, RowChosen),
	nth1(NumColumn, RowChosen, CellChosen),
	CellChosen == nil, % cell is free
	BeforeNumRow is NumRow - 1,

	% Check if there is a piece in the row before
	nth1(BeforeNumRow, Board, RowBefore),
	nth1(NumColumn, RowBefore, CellBefore),
	CellBefore \== nil,
	write('Valid Move!'),nl
	% add function to make move
	.
checkIfMoveIsValid(Board, Letter, Rotation, ColorPlayer, NumRow, NumColumn):-
	%Check if there is a piece in the row after
	AfterNumRow is NumRow + 1,
	nth1(AfterNumRow, Board, RowAfter),
	nth1(NumColumn, RowAfter, CellAfter),
	CellAfter \== nil,
	write('Valid Move!'),nl
	% add function to make move
	.
checkIfMoveIsValid(Board, Letter, Rotation, ColorPlayer, NumRow, NumColumn):-
	%Check if there is a piece in the column before
	BeforeNumColumn is NumColumn - 1,
	nth1(NumRow, Board, Row),
	nth1(BeforeNumColumn, Row, CellBefore),
	CellBefore \== nil,
	write('Valid Move!'),nl
	% add function to make move
	.
checkIfMoveIsValid(Board, Letter, Rotation, ColorPlayer, NumRow, NumColumn):-
	%Check if there is a piece in the column after
	AfterNumColumn is NumColumn + 1,
	nth1(NumRow, Board, Row),
	nth1(AfterNumColumn, Row, CellAfter),
	CellAfter \== nil,
	write('Valid Move!'),nl
	% add function to make move
	.
	
checkIfMoveIsValid(Board, Letter, Rotation, ColorPlayer, NumRow, NumColumn):-
	write('Invalid move, please choose another'), nl,
	pieces(Pieces),
	askNextPiece(Board, Pieces, ColorPlayer).

between(Min, Max, Num):-
	Num >= Min,
	Num =< Max.

askBoardPosition([Head | Tail], Letter, Rotation, ColorPlayer):-
	write('Row: '),
	read(Row), nl,
	length([Head | Tail], RowMax),
	between(1, RowMax, Row),
	!, write('Column: '), read(Column), nl,
	length(Head, ColumnMax),
	between(1, ColumnMax, Column),!,
	checkIfMoveIsValid([Head | Tail], Letter, Rotation, ColorPlayer, Row, Column).
askBoardPosition(Board, Letter, Rotation):- askBoardPosition(Board, Letter, Rotation, ColorPlayer).


askRotation(Board, Letter, ColorPlayer):-
	write('Rotation (0 - 0 degrees, 1 - 90 degrees, 2 - 180 degrees, 3 - 270 degrees): '),
	read(Rotation), nl,
	member(Rotation, [0,1,2,3]),!,
	write('HERE'),
	askBoardPosition(Board, Letter, Rotation, ColorPlayer).
askRotation(Board, Letter):-
	write('Wrong rotation number, please try again '), nl,
	askRotation(Board, Letter, ColorPlayer).

askNextPiece(Board, Pieces, ColorPlayer):-
	write('Next Piece: '),
	read(Letter), nl,
	member(Letter, Pieces),!,
	askRotation(Board, Letter, ColorPlayer).
askNextPiece(Board, Pieces):-
	write('Wrong piece identifier, please try again '), nl,
	askNextPiece(Board, Pieces, ColorPlayer).

testeInput :- pieces(Pieces), askNextPiece([[nil, nil, nil],[nil,[a,1,0,0],nil],[nil,nil,nil]],Pieces, 0).

pieces([a,b,c,d,h,s,t]).