

/************************************
**** FUNCTIONS OF COMPUTER INPUT ****
************************************/
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




computerInput([_H|_T], Pieces, Letter, Rotation) :-
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)), nl,
	write('-> Computer played piece '), write(Letter), nl, nl.

computerInput([H|T], Pieces, Letter, Rotation, NumRow, NumCol) :-
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getPosition([H|T], NumRow, NumCol)),
	once(checkIfMoveIsValid([H|T], NumRow, NumCol)), nl,
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer):-
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getPosition(Board, DestRow, DestColumn)),
	once(checkIfMoveIsValid(Board, DestRow, DestColumn)),
	write('-> Computer removes piece from position ('),
	write(SourceRow), write(','), write(SourceColumn), write(')'), nl, nl, sleep(2),
	write('-> ... and puts it'), write(' in position ('),
	write(DestRow), write(','), write(DestColumn), write(')'), nl, nl.