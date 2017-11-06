

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

getPosition(Board, NumRow, NumCol) :-
	getValidMoves(Board, ValidMoves),
	length(ValidMoves, NumValidMoves),
	random(0, NumValidMoves, ValidMovePos),
	nth0(ValidMovePos, ValidMoves, ValidMoveChoosen),
	nth0(0, ValidMoveChoosen, NumRow),
	nth0(1, ValidMoveChoosen, NumCol).

computerInput(_Board, Pieces, Letter, Rotation) :-
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)), nl,
	write('-> Computer played piece '), write(Letter), nl, nl.


computerInput(Board, Pieces, Letter, Rotation, NumRow, NumCol) :-
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer):-
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).
/*
computerInputIA(Board, Pieces, Letter, Rotation, NumRow, NumCol) :-
	bestMoveVitory(Board, Pieces, BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory, AuxVitory),

computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer).*/


computerInput(Board, Pieces, Letter, Rotation, NumRow, NumCol, Level) :-
	Level == 1, !, 
	computerInput(Board, Pieces, Letter, Rotation, NumRow, NumCol).

computerInput(Board, Pieces, Letter, Rotation, NumRow, NumCol, Level) :-
	computerInputIA(Board, Pieces, Letter, Rotation, NumRow, NumCol).


computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	Level == 1, !,
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer).

computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	computerInputMoveIA(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer).