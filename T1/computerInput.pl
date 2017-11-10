
/**
* Level one/two AI - first move.
**/
computerInput(_Board, Pieces, Letter, Rotation) :-
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)), nl,
	printInformation(Letter).


/**
* Level one AI - random add piece.
**/
computerInput(Board, Pieces, _AdversaryPieces, _ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	Level == 1, !,
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)), %random positions
	printInformation(NumRow, NumCol, Letter).

/**
* Level two AI - find the piece that guarantees victory.
**/
computerInput(Board, Pieces, _AdversaryPieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, _Level) :-
	getValidMoves(Board, ValidMoves),
	once(bestMoveVitory(Board, Pieces, _BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, NumRow, NumCol, Vitory)),
	Vitory == 1, !,
	printInformation(NumRow, NumCol, Letter).

/**
* Level two AI - block opponent
**/
computerInput(Board, Pieces, AdversaryPieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, _Level) :-
	getValidMoves(Board, ValidMoves),
	AdversaryColorPlayer is mod((ColorPlayer + 1), 2),
	once(bestMoveVitory(Board, AdversaryPieces, _BeforeLetter, ValidMoves, AdversaryColorPlayer, _AuxLetter, Rotation, NumRow, NumCol, Vitory)),
	Vitory == 1, !,
	getPieceLetter(Pieces, Letter), 
	printInformation(NumRow, NumCol, Letter).

/**
* Level two AI - find the best possible move.
**/
computerInput(Board, Pieces, _AdversaryPieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, _Level) :- 
	getValidMoves(Board, ValidMoves),
	once(getSecondBestMove(Board, Pieces, ValidMoves, ColorPlayer, _PossibleMoves, FinalPossibleMoves)),
	%write(FinalPossibleMoves),nl,
	once(playSecondBestMove(FinalPossibleMoves, Pieces, Board, Letter, Rotation, NumRow, NumCol)),
	printInformation(NumRow, NumCol, Letter).


/**
* Level one AI - move parts randomly.
**/
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	Level == 1, !,
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(getValidPostionToRemove(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).


/**
* Level two AI - Find on the board the piece that guarantees victory and moves it to the right place.
**/
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestCol, ColorPlayer, _Level):-
	once(getPositionsToRemovePiece(Board, PositionsToRemove)),
	once(getColorPieces(Board, ColorPlayer, ListPiecesPlayer)),
	once(inter(PositionsToRemove, ListPiecesPlayer, FinalListToRemove)),
	once(getLetters(Board, FinalListToRemove, _LettersPositions, LettersPositionsAux, _LettersAvailable, LettersAvailableAux)),
	once(getValidMoves(Board, ValidMoves)),
	once(bestMoveVitory(Board, LettersAvailableAux, _BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, DestRow, DestCol, Vitory)),
	Vitory == 1, !,
	getCoordinates(Letter, LettersPositionsAux, SourceRow, SourceColumn),
	once(printInformation(SourceRow, SourceColumn, DestRow, DestCol)).


/**
* Level two AI - block opponent
**/
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestCol, ColorPlayer, _Level):-
	once(getPositionsToRemovePiece(Board, PositionsToRemove)),
	AdversaryColorPlayer is mod((ColorPlayer + 1), 2),
	once(getColorPieces(Board, AdversaryColorPlayer, ListPiecesAdvPlayer)),
	once(inter(PositionsToRemove, ListPiecesAdvPlayer, FinalListToRemoveAdv)),
	once(getLetters(Board, FinalListToRemoveAdv, _LettersPositions, _LettersPositionsAux2, _LettersAvailable, LettersAvailableAux2)),
	once(getValidMoves(Board, ValidMoves)),
	once(bestMoveVitory(Board, LettersAvailableAux2, _BeforeLetter, ValidMoves, AdversaryColorPlayer, _AuxLetter, Rotation, DestRow, DestCol, Vitory)),
	Vitory == 1, !,
	once(getColorPieces(Board, ColorPlayer, ListPiecesPlayer)),
	once(inter(PositionsToRemove, ListPiecesPlayer, FinalListToRemove)),
	once(getLetters(Board, FinalListToRemove, _LettersPositions, LettersPositionsAux, _LettersAvailable, LettersAvailableAux)),
	getPieceLetter(LettersAvailableAux, Letter), 
	getCoordinates(Letter, LettersPositionsAux, SourceRow, SourceColumn),
	once(printInformation(SourceRow, SourceColumn, DestRow, DestCol)).

/**
* Level two AI - find the best possible move.
**/
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestCol, ColorPlayer, _Level):-
	once(getPositionsToRemovePiece(Board, PositionsToRemove)),
	once(getColorPieces(Board, ColorPlayer, ListPiecesPlayer)),
	once(inter(PositionsToRemove, ListPiecesPlayer, FinalListToRemove)),
	once(getLetters(Board, FinalListToRemove, _LettersPositions, LettersPositionsAux, _LettersAvailable, LettersAvailableAux)),
	getValidMoves(Board, ValidMoves),
	once(getSecondBestMove(Board, LettersAvailableAux, ValidMoves, ColorPlayer, _PossibleMoves, FinalPossibleMoves)),
	once(playSecondBestMove(FinalPossibleMoves, LettersAvailableAux, Board, Letter, Rotation, DestRow, DestCol)),
	getCoordinates(Letter, LettersPositionsAux, SourceRow, SourceColumn),
	once(printInformation(SourceRow, SourceColumn, DestRow, DestCol)).


/**
* Get a random piece from a list of available pieces.
**/
getPieceLetter(Pieces, Letter) :- 	
	length(Pieces, NumPieces),
	random(0, NumPieces, PosPiece),
	nth0(PosPiece, Pieces, Letter).


/**
* Get a random rotation for a piece.
**/
getRotation(Rotation) :-
	random(0, 3, Rotation).


/**
* Get a random coordinates from valid moves for add next piece.
**/
getValidPosition(Board, NumRow, NumCol) :-
	getValidMoves(Board, ValidMoves),
	length(ValidMoves, NumValidMoves),
	random(0, NumValidMoves, ValidMovePos),
	nth0(ValidMovePos, ValidMoves, ValidMoveChoosen),
	nth0(0, ValidMoveChoosen, NumRow),
	nth0(1, ValidMoveChoosen, NumCol).


/**
* Get a random coordinates for remove a piece.
**/
getPosition([H|T], NumRow, NumCol) :-
	length([H|T], AuxNumRows),
	NumRows is AuxNumRows - 1,
	random(0, NumRows, NumRow),
	length(H, AuxNumCols),
	NumCols is AuxNumCols - 1,
	random(0, NumCols, NumCol).


/**
* Get all the pieces in play of a given player. 
**/
getColorPieces(Board, ColorPlayer, ListPiecesPlayer) :-
	setof([X,Y], checkColorPiece(Board, X, Y, ColorPlayer), ListPiecesPlayer).


/**
* Get the piece of a particular position.
**/
getPiece(Board, Row, Col, Piece) :-
	nth0(Row, Board, RowBoard),
	nth0(Col, RowBoard, Piece).


/**
* Get coordinates of Piece from a list of pieces.
**/
getCoordinates(_, [], _, _).
getCoordinates(Letter, [H | _T], SourceRow, SourceColumn) :-
	nth0(0, H, LetterAux),
	LetterAux == Letter, !,
	nth0(1, H, SourceRow),
	nth0(2, H, SourceColumn).
getCoordinates(Letter, [_H | T], SourceRow, SourceColumn) :-
	getCoordinates(Letter, T, SourceRow, SourceColumn).


/**
* Get letters and coordinates of available pieces to move.
**/
getLetters(_Board, [], LettersPositions, LettersPositions, LettersAvailable, LettersAvailable).
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux) :-
	length(LettersAvailable, Aux),
	Aux \== 0, !,
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
	append([Letter], LettersAvailable , NewLettersAvailable),
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, NewLettersAvailable, LettersAvailableAux).
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, _LettersAvailable, LettersAvailableAux) :-
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, [Letter], LettersAvailableAux).