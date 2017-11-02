

/************************************
**** FUNCTIONS OF COMPUTER INPUT ****
************************************/



computerMove([_H|_T], Pieces, Letter, Rotation) :-
repeat,
once(getPieceLetter(Pieces, Letter)),
once(getRotation(Rotation)), nl,
write('-> Computer played piece '), write(Letter), nl, nl.

computerMove([H|T], Pieces, Letter, Rotation, NumRow, NumCol) :-
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