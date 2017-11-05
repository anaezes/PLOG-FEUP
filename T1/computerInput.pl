

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
	once(validMove([H|T], NumRow, NumCol)), nl,
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer):-
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getPosition(Board, DestRow, DestColumn)),
	once(validMove(Board, DestRow, DestColumn)),
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).