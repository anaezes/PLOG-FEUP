


/************************************
**** FUNCTIONS OF COMPUTER INPUT ****
************************************/


getPieceLetter(Pieces, Letter) :- 	
	length(Pieces, NumPieces),
	%NumPieces is AuxNumPieces - 1,
	NumPieces \== 0, !,
	random(0, NumPieces, PosPiece),
	nth0(PosPiece, Pieces, Letter).

getPieceLetter(Pieces, Letter) :-
	nth0(0, Pieces, Letter).

getRotation(Rotation) :-
	random(0, 3, Rotation).

getValidPosition(Board, NumRow, NumCol) :-
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

getPosition([H|T], NumRow, NumCol) :-
	length([H|T], AuxNumRows),
	NumRows is AuxNumRows - 1,
	random(0, NumRows, NumRow),
	length(H, AuxNumCols),
	NumCols is AuxNumCols - 1,
	random(0, NumCols, NumCol).


/**
* Level one AI
**/
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	Level == 1, !,
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

/**
* Level two AI
**/
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
	getValidMoves(Board, ValidMoves),
	once(getSecondBestMove(Board, Pieces, ValidMoves, ColorPlayer, PossibleMoves, FinalPossibleMoves)),
	write(FinalPossibleMoves),nl,
	once(playSecondBestMove(FinalPossibleMoves, Pieces, Board, NewBoard, Letter, Rotation, NumRow, NumCol)),
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.
	/*write('O jogo continua....'),
	repeat,*/
	/*once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.*/




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
	once(getPositionsToRemovePiece(Board, PositionsToRemove)),
	write('PositionsToRemove: '), write(PositionsToRemove), nl,
	once(getColorPieces(Board, ColorPlayer, ListPiecesPlayer)),
	write('ListPiecesPlayer: '), write(ListPiecesPlayer), nl,
	once(inter(PositionsToRemove, ListPiecesPlayer, FinalListToRemove)),
	write('FinalListToRemove: '), write(FinalListToRemove), nl,
	once(getLetters(Board, FinalListToRemove, LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux)),
	write('LettersAvailable: '), write(LettersAvailableAux), nl,
	once(getValidMoves(Board, ValidMoves)),
	once(bestMoveVitory(Board, LettersAvailableAux, BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, DestRow, DestCol, Vitory, Aux)),
	Aux == 1, !,
	write(Letter), nl, 
	getCoordinates(Letter, LettersPositionsAux, SourceRow, SourceColumn).



% Level Two
% TODO - tirar a peça com menos peças a fazer match e colocar junto da que tem mais peças a fazer match ?
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestCol, ColorPlayer, Level):-
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(getValidPostionToRemove(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestCol)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestCol)).


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
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
	append([Letter], LettersAvailable , NewLettersAvailable),
	getLetters(Board, T, NewLettersPositions, LettersPositionsAux, NewLettersAvailable, LettersAvailableAux).
getLetters(Board, [H | T], LettersPositions, LettersPositionsAux, LettersAvailable, LettersAvailableAux) :-
	nth0(0, H, Row), 
	nth0(1, H, Col), 
	getPiece(Board, Row, Col, Piece),
	nth0(0, Piece, Letter),
	append([Letter], H, LetterPos),
	append(LettersPositions, [LetterPos], NewLettersPositions),
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