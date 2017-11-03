

/*********************************
**** FUNCTIONS OF HUMAN INPUT ****
*********************************/
	

betweeMinMax(Min, Max, Num):-
	Num >= Min,
	Num =< Max.

askBoardPosition([Head | Tail], NumRow, NumCol):-
	write('  Row: '),
	once(read(NumRow)), 
	length([Head | Tail], RowMax),
	NRowMax is RowMax - 1,
	betweeMinMax(0, NRowMax, NumRow), !,
	write('  Column: '), once(read(NumCol)), nl,
	length(Head, ColumnMax),
	NColumnMax is ColumnMax - 1,
	betweeMinMax(0, NColumnMax, NumCol).


askRotation(Rotation):-
	write('  Rotation (0 - 0 degrees, 1 - 90 degrees, 2 - 180 degrees, 3 - 270 degrees): '),
	once(read(Rotation)), !,
	member(Rotation, [0,1,2,3]).


askNextPiece(Pieces, Letter):-
	nl, write('  Next Piece: '),
	once(read(Letter)),
	member(Letter, Pieces).


askInput(_Board, Pieces, Letter, Rotation):-
	repeat,
	once(askNextPiece(Pieces, Letter)),
	once(askRotation(Rotation)).

askInput(Board, Pieces, Letter, Rotation, NumRow, NumCol):-
	repeat,
	once(askNextPiece(Pieces, Letter)),
	once(askRotation(Rotation)),
	once(askBoardPosition(Board, NumRow, NumCol)),
	once(checkIfMoveIsValid(Board, NumRow, NumCol)).

askMenuInput(Options, Option):-
	nl, printSpace(10), write('Choose option: '),
	read(Option),
	member(Option, Options).


askInputMove(Board, SourceRow, SourceColumn, Rotation, DestRow, DestColumn, ColorPlayer):-
	repeat,
	write('  Select piece to move: '), nl, 
	once(askBoardPosition(Board, SourceRow, SourceColumn)),
	once(checkIfRemovePieceIsValid(Board, SourceRow, SourceColumn)),
	once(checkColorPiece(Board, SourceRow, SourceColumn, ColorPlayer)),
	once(askRotation(Rotation)),
	write('  Select destination: '), nl, 
	once(askBoardPosition(Board, DestRow, DestColumn)),
	once(checkIfMoveIsValid(Board, DestRow, DestColumn)).
