/**************************
**** FUNCTIONS OF INPUT ****
**************************/

askBoardPosition([Head | Tail], Letter, Rotation):-
	write('Row: '),
	get_char(Row), nl,
	length([Head | Tail], RowMax),
	atom_number(Row, NumRow),
	between(1, RowMax, NumRow),
	skip(10),
	!, write('Column: '), get_char(Column), nl,
	length(Head, ColumnMax),
	atom_number(Column, NumColumn),
	between(1, ColumnMax, NumColumn),!,
	write('All went well'). % Insert here the function to check if the move is valid
askBoardPosition(Board, Letter, Rotation):- askBoardPosition(Board, Letter, Rotation).


askRotation(Board, Letter):-
	write('Rotation (0 - 0 degrees, 1 - 90 degrees, 2 - 180 degrees, 3 - 270 degrees): '),
	get_char(Rotation), nl,
	skip(10),
	atom_number(Rotation, NumRotation),
	member(NumRotation, [0,1,2,3]),!,
	askBoardPosition(Board, Letter, Rotation).
askRotation(Board, Letter):-
	write('Wrong rotation number, please try again '), nl,
	askRotation(Board, Letter).

askNextPiece(Board, Pieces):-
	write('Next Piece: '),
	get_char(Letter), nl,
	member(Letter, Pieces),!,
	skip(10), % skips the newline
	askRotation(Board, Letter).
askNextPiece(Board, Pieces):-
	write('Wrong piece identifier, please try again '), nl,
	askNextPiece(Board, Pieces).

testeInput :- askNextPiece([[nil, nil, nil]],[a,b,c,d,h,s,t]).
