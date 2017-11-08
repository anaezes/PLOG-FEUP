

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
	write('O jogo continua....'),
	repeat,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)), %random positions
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.




/*vai ser para alterar - Encontrar a melhor jogada:

computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, Level) :-
	write('computerInput 2 '),nl,
	computerInput(Board, Pieces, ColorPlayer, Letter, Rotation, NumRow, NumCol, 1).*/


% Level One
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	Level == 1, !,
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).


% Level Two
%para alterar -> tirar a peça com menos peças a fazer match e colocar junto da que tem mais peças a fazer match ?
computerInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer, Level):-
	repeat, 
	once(getPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, DestRow, DestColumn)), %random positions
	once(printInformation(SourceRow, SourceColumn, DestRow, DestColumn)).