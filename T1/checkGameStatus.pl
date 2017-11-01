updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, NewValid, NewBoard):-
	replace(Board,Row,Column,[Letter,Rotation,Color,NewValid], NewBoard).
	%write(NewBoard), nl.

% Verifies the color of the piece to it's side and updates the Valid and the Count
checkNextSidePiece(_, _, nil, IsNext):-
	IsNext is 0, NewValid is 0.
checkNextSidePiece(PieceColor, NewValid, [Letter, Rotation, Color, Valid], IsNext):-
	PieceColor == Color, !, write('LOLZ'),nl,
	IsNext is 1, NewValid is 0.
checkNextSidePiece(PieceColor, NewValid, [Letter, Rotation, Color, Valid], IsNext):-
	write('AQUI!'),IsNext is 0, NewValid is 1, write('FACK'),nl.

% If the piece is invalid, no need to check
checkRow([_| _], _, 1, _, _, _, _, _, _).
% third row of the piece
checkRow([Head | Tail], Color, Valid, 2, 0, Board, Row, Column, Count):-
	write('Check Row 2 0'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	BeforeColumnNum is Column - 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(BeforeColumnNum, AfterRow, CellDiagonal),
	checkNextSidePiece(Color, Valid, CellDiagonal, IsNext),
	NewCount is Count + IsNext,
	checkRow(Tail, Color, Valid, 2, 1, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 2, 0, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 2, 1, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 2, 1, Board, Row, Column, Count):-
	write('Check Row 2 1'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(Column, AfterRow, CellUnder),
	checkNextSidePiece(Color, Valid, CellUnder, IsNext),
	write('VALID: '), write(Valid),nl,
	NewCount is Count + IsNext,
	checkRow(Tail, Color, Valid, 2, 2, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 2, 1, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 2, 2, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 2, 2, Board, Row, Column, Count):-
	write('Check Row 2 2'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	AfterColumnNum is Column + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(AfterColumnNum, AfterRow, CellDiagonal),
	checkNextSidePiece(Color, Valid, CellDiagonal, IsNext),
	NewCount is Count + IsNext,
	checkRow([], Color, Valid, 2, 2, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 2, 2, Board, Row, Column, Count):-
	checkRow([], Color, Valid, 2, 2, Board, Row, Column, Count).

% second row of the piece
checkRow([Head | Tail], Color, Valid, 1, 0, Board, Row, Column, Count):-
	write('Check Row 1 0'),write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeColumnNum is Column - 1,
	nth0(Row, Board, SameRow),
	nth0(BeforeColumnNum, SameRow, CellBefore),
	checkNextSidePiece(Color, Valid, CellBefore, IsNext),
	NewCount is Count + IsNext,
	checkRow(Tail, Color, Valid, 1, 1, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 1, 0, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 1, 1, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 1, 1, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 1, 2, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 1, 2, Board, Row, Column, Count):-
	write('Check Row 1 2'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterColumnNum is Column + 1,
	nth0(Row, Board, SameRow),
	nth0(AfterColumnNum, SameRow, CellAfter),
	checkNextSidePiece(Color, Valid, CellAfter, IsNext),
	NewCount is Count + IsNext,
	checkRow([], Color, Valid, 1, 2, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 1, 2, Board, Row, Column, Count):-
	checkRow([], Color, Valid, 1, 2, Board, Row, Column, Count).

% first row of the piece
checkRow([Head | Tail], Color, Valid, 0, 0, Board, Row, Column, Count):-
	write('Check Row 0 0'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	BeforeColumnNum is Column - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(BeforeColumnNum, BeforeRow, CellDiagonal),
	checkNextSidePiece(Color, Valid, CellDiagonal, IsNext),
	NewCount is Count + IsNext,
	checkRow(Tail, Color, Valid, 0, 1, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 0, 0, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 0, 1, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 0, 1, Board, Row, Column, Count):-
	write('Check Row 0 1'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(Column, BeforeRow, CellAbove),
	checkNextSidePiece(Color, Valid, CellAbove, IsNext),
	NewCount is Count + IsNext,
	checkRow(Tail, Color, Valid, 0, 2, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 0, 1, Board, Row, Column, Count):-
	checkRow(Tail, Color, Valid, 0, 2, Board, Row, Column, Count).

checkRow([Head | Tail], Color, Valid, 0, 2, Board, Row, Column, Count):-
	write('Check Row 0 2'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	AfterColumnNum is Column + 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(AfterColumnNum, BeforeRow, CellDiagonal),
	checkNextSidePiece(Color, Valid, CellDiagonal, IsNext),
	NewCount is Count + IsNext,
	checkRow([], Color, Valid, 0, 2, Board, Row, Column, NewCount).
checkRow([Head | Tail], Color, Valid, 0, 2, Board, Row, Column, Count):-
	checkRow([], Color, Valid, 0, 2, Board, Row, Column, Count).

checkRow([], _, _, _, _, _, _, _, _):-write('LEL'),nl.


checkAroundPiece([], _, _, 3, _, _, _, _).
checkAroundPiece([Head | Tail], Color, NewValid, PieceRow, Board, Row, Column, CountPiecesAround):-
	Count is 0,
	checkRow(Head, Color, NewValid, PieceRow, 0, Board, Row, Column, Count),
	NewCountPiecesAround is CountPiecesAround + Count,
	NewPieceRow is PieceRow + 1,
	checkAroundPiece(Tail, Color, NewValid, NewPieceRow, Board, Row, Column, NewCountPiecesAround).

checkPieceStatus([Letter, Rotation, Color, Valid], Board, NewBoard, Row, Column, CountPiecesAround, GameEnd):-
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	checkAroundPiece(Pattern, Color, NewValid, 0, Board, Row, Column, CountPiecesAround),
	write('Check Piece Status: '), write(NewValid),nl,
	updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, NewValid, NewBoard),
	CountPiecesAround == 4,!,
	GameEnd is 1.


findPiece([], _, _, _, _, _).
findPiece([_ | _], _, _, _, _, 1).
findPiece([Head | Tail], Board, NewBoard, Row, Column, GameEnd):-
	Head == nil,!,
	NewColumn is Column + 1,
	findPiece(Tail, Board, NewBoard, Row, NewColumn, GameEnd).
findPiece([Head | Tail], Board, NewBoard, Row, Column, GameEnd):-
	Head \== nil,
	checkPieceStatus(Head, Board, NewBoard, Row, Column, 0, GameEnd),
	NewColumn is Column + 1,
	findPiece(Tail, Board, NewBoard, Row, NewColumn, GameEnd).

checkGameEnd([], _, _, _):- write('Game has not ended!'). % continue next player
checkGameEnd([_ | _], Board, Row, 1):- write('Game is donne!'). % end game
checkGameEnd([Head | Tail], Board, NewBoard, Row, GameEnd):-
	%write('CheckGameEnd: '), write(Head), nl,
	findPiece(Head, Board, NewBoard, Row, 0, GameEnd),
	NewRow is Row + 1,
	%write(NewBoard),nl,nl,
	checkGameEnd(Tail, Board, NewNewBoard, NewRow, GameEnd).


board([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, [j, 0, 1, 0], nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 1], [p, 0, 0, 0], nil],
	[nil, nil, nil, nil, [o, 0, 1, 0], nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]).

teste8:- board(Board), /*prepareBoard(Board), */checkGameEnd(Board, Board, NewBoard, 0, 0), prepareBoard(NewBoard).
