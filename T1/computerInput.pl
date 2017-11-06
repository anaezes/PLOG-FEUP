

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




/**
* Level one AI
**/
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	Level == 1, !,
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

/**
* Level two AI
**/
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 2) :-
	getValidMoves(Board, ValidMoves),
	once(bestMoveVitory(Board, Pieces, BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, NumRow, NumCol, Vitory, Aux)),
	write('Aux:' ), write(Aux), nl,
	Aux == 1, !,
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl,
	write('Entrou opção que vai ganhar').

computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 2) :- 
	write('O jogo continua....'),
	computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 1).


/*vai ser para alterar - Encontrar a melhor jogada
computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	write('computerInput 2 '),nl,
	computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 1).*/


computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
%	Level == 1, !,
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).
