
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
<<<<<<< Updated upstream
	random(0, NumPieces, PosPiece),
	nth0(PosPiece, Pieces, Letter).


/**
* Get a random rotation for a piece.
**/
=======
	%NumPieces is AuxNumPieces - 1,
	NumPieces \== 0, !,
	random(0, NumPieces, PosPiece),
	nth0(PosPiece, Pieces, Letter).

getPieceLetter(Pieces, Letter) :-
	nth0(0, Pieces, Letter).

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	getValidMoves(Board, ValidMoves),
	once(bestMoveVitory(Board, Pieces, BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, NumRow, NumCol, Vitory, Aux)),
	write('Aux:' ), write(Aux), nl,
	Aux == 1, !,
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl,
	write('Entrou opção que vai ganhar').

%para alterar -> encontrar a melhor jogada possivel.
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :- 
	write('O jogo continua....'),
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.




/*TODO : Encontrar a melhor jogada:
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	write('computerInput 2 '),nl,
	computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 1).*/


% Level One
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	Level == 1, !,
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(getValidPostionToRemove(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).


% Level Two
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestCol, ColorPlayer, Level):-
	getPositionsToRemovePiece(Board, PositionsToRemove),
	%write('PositionsToRemove: '), write(PositionsToRemove), nl,
	getColorPieces(Board, ColorPlayer, ListPiecesPlayer),
	%write('ListPiecesPlayer: '), write(ListPiecesPlayer), nl,
	inter(PositionsToRemove, ListPiecesPlayer, FinalListToRemove),
	%write('FinalListToRemove: '), write(FinalListToRemove), nl,
	getLetters(Board, FinalListToRemove, LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux),
	%write('LettersAvailable: '), write(LettersAvailableAux), nl,
	getValidMoves(Board, ValidMoves),
	once(bestMoveVitory(Board, LettersAvailableAux, BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, DestRow, DestCol, Vitory, Aux)),
	Aux == 1, !,
	%write(Letter), nl, 
	getCoordinates(Letter, LettersPositionsAux, SourceRow, SourceColumn).



% Level Two
% TODO - tirar a peça com menos peças a fazer match e colocar junto da que tem mais peças a fazer match ?
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	repeat, 
	once(getValidPostionToRemove(Board, SourceRow, SourceColumn)),
	%computar a melhor letra a retirar que dê para ganhar 
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).


getCoordinates(_, [], _, _).
getCoordinates(Letter, [H | T], SourceRow, SourceColumn) :-
	nth0(0, H, LetterAux),
	LetterAux == Letter,
	nth0(1, H, SourceRow),
	nth0(2, H, SourceColumn).
getCoordinates(Letter, [H | T], SourceRow, SourceColumn) :-
	getCoordinates(Letter, T, SourceRow, SourceColumn).


getLetters(_Board, [], LettersPositions, LettersPositions, LettersAvailable, LettersAvailable).
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux) :-
	length(LettersAvailable, Aux),
	aux \== 0, !,
>>>>>>> Stashed changes
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
	append([Letter], LettersAvailable , NewLettersAvailable),
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, NewLettersAvailable, LettersAvailableAux).
<<<<<<< Updated upstream
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, _LettersAvailable, LettersAvailableAux) :-
=======
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux) :-
>>>>>>> Stashed changes
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
<<<<<<< Updated upstream
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, [Letter], LettersAvailableAux).
=======
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, [Letter], LettersAvailableAux).


getColorPieces(Board, ColorPlayer, ListPiecesPlayer) :-
	setof([X,Y], checkColorPiece(Board, X, Y, ColorPlayer), ListPiecesPlayer).

getPositionsToRemovePiece(Board, PositionsToRemove) :-
	setof([X,Y], getValidPostionToRemove(Board, X, Y), PositionsToRemove).

getPiece(Board, Row, Col, Piece) :-
	nth0(Row, Board, RowBoard),
	nth0(Col, RowBoard, Piece).


%intercepção de duas listas
inter([], _, []).
inter([H1|T1], L2, [H1|Res]) :-
    member(H1, L2),
    inter(T1, L2, Res).
inter([_|T1], L2, Res) :-
    inter(T1, L2, Res).








testeMove :- 
	board(Board), 
	computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, 1, 2),
	write('SourceRow'), write(SourceRow),nl, 
	write('SourceColumn'), write(SourceColumn),nl, 
	write('Rotation'), write(Rotation),nl, 
	write('DestRow'), write(DestRow),nl, 
	write('DestColumn'), write(DestColumn),nl.

positions([[1,4],[2,2],[2,5],[4,1]]).

teste9 :- board(Board), positions(Positions),
			getLetters(Board, Positions, LettersPositions, LettersAvailable),
			write(LettersPositions), nl, write(LettersAvailable), nl.
>>>>>>> Stashed changes
