updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, NewValid, NewBoard):-
	replace(Board,Row,Column,[Letter,Rotation,Color,NewValid], NewBoard).
	%write(NewBoard), nl.

% Verifies the color of the piece to it's side and updates the Valid and the Count
checkNextSidePiece(_, _, nil, Count, NewCount):-
	NewCount is Count, NewValid is 0,!.
checkNextSidePiece(PieceColor, NewValid, [Letter, Rotation, Color, Valid], Count, NewCount):-
	PieceColor == Color,!, %write('LOLZ'),nl,
	NewCount is Count + 1, NewValid is 0.
checkNextSidePiece(PieceColor, NewValid, [Letter, Rotation, Color, Valid], Count, NewCount):-
	NewCount is Count, NewValid is 1. %write('FACK'),nl.

% If the piece is invalid, no need to check
checkRow([], _, _, _, _, _, _, _,):- write('END '),nl.
% third row of the piece
checkRow([Head | Tail], Color, Valid, 2, 0, Board, Row, Column):-
	write('Check Row 2 0'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	BeforeColumnNum is Column - 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(BeforeColumnNum, AfterRow, CellDiagonal),
	%checkNextSidePiece(Color, Valid, CellDiagonal, Count, NewCount),
	checkRow(Tail, Color, Valid, 2, 1, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 2, 0, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 2, 1, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 2, 1, Board, Row, Column):-
	write('Check Row 2 1'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(Column, AfterRow, CellUnder),
	%checkNextSidePiece(Color, Valid, CellUnder, Count, NewCount),
	checkRow(Tail, Color, Valid, 2, 2, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 2, 1, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 2, 2, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 2, 2, Board, Row, Column):-
	write('Check Row 2 2'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterRowNum is Row + 1,
	AfterColumnNum is Column + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(AfterColumnNum, AfterRow, CellDiagonal),
	%checkNextSidePiece(Color, Valid, CellDiagonal, Count, NewCount),
	checkRow([], _, _, _, _, _, _, _).
checkRow([Head | Tail], Color, Valid, 2, 2, Board, Row, Column):-
	checkRow([], Color, Valid, 2, 2, Board, Row, Column).

% second row of the piece
checkRow([Head | Tail], Color, Valid, 1, 0, Board, Row, Column):-
	write('Check Row 1 0'),write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeColumnNum is Column - 1,
	nth0(Row, Board, SameRow),
	nth0(BeforeColumnNum, SameRow, CellBefore),
	%checkNextSidePiece(Color, Valid, CellBefore, Count, NewCount),
	checkRow(Tail, Color, Valid, 1, 1, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 1, 0, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 1, 1, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 1, 1, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 1, 2, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 1, 2, Board, Row, Column):-
	write('Check Row 1 2'),write(' - '), write(Head),nl,
	Head == 1,!,
	AfterColumnNum is Column + 1,
	nth0(Row, Board, SameRow),
	nth0(AfterColumnNum, SameRow, CellAfter),
	%checkNextSidePiece(Color, Valid, CellAfter, Count, NewCount),
	checkRow([], Color, Valid, 1, 2, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 1, 2, Board, Row, Column):-
	checkRow([], Color, Valid, 1, 2, Board, Row, Column).

% first row of the piece
checkRow([Head | Tail], Color, Valid, 0, 0, Board, Row, Column):-
	write('Check Row 0 0'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	BeforeColumnNum is Column - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(BeforeColumnNum, BeforeRow, CellDiagonal),
	%checkNextSidePiece(Color, Valid, CellDiagonal, Count, NewCount),
	checkRow(Tail, Color, Valid, 0, 1, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 0, 0, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 0, 1, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 0, 1, Board, Row, Column):-
	write('Check Row 0 1'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(Column, BeforeRow, CellAbove),
	%checkNextSidePiece(Color, Valid, CellAbove, Count, NewCount),
	checkRow(Tail, Color, Valid, 0, 2, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 0, 1, Board, Row, Column):-
	checkRow(Tail, Color, Valid, 0, 2, Board, Row, Column).

checkRow([Head | Tail], Color, Valid, 0, 2, Board, Row, Column):-
	write('Check Row 0 2'), write(' - '), write(Head),nl,
	Head == 1,!,
	BeforeRowNum is Row - 1,
	AfterColumnNum is Column + 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(AfterColumnNum, BeforeRow, CellDiagonal),
	%checkNextSidePiece(Color, Valid, CellDiagonal, Count, NewCount),
	checkRow([], Color, Valid, 0, 2, Board, Row, Column).
checkRow([Head | Tail], Color, Valid, 0, 2, Board, Row, Column,):-
	checkRow([], Color, Valid, 0, 2, Board, Row, Column).


checkAroundPiece([], _, _, 3, _, _, _, _, _).
checkAroundPiece(_, _, _, _, _, _, _, _, 1).
checkAroundPiece([Head | Tail], Color, NewValid, PieceRow, Board, Row, Column, GameEnd):-
	CountPiecesAround == 4,!,
	GameEnd is 1.
checkAroundPiece([Head | Tail], Color, NewValid, PieceRow, Board, Row, Column, GameEnd):-
	checkRow(Head, Color, NewValid, PieceRow, 0, Board, Row, Column),
	NewPieceRow is PieceRow + 1,
	checkAroundPiece(Tail, Color, NewValid, NewPieceRow, Board, Row, Column, GameEnd).

checkPieceStatus([_, _, _, _], _, _, _, _, 1).
checkPieceStatus([Letter, Rotation, Color, Valid], Board, NewBoard, Row, Column, GameEnd):-
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	Valid \== 1,!,
	checkAroundPiece(Pattern, Color, NewValid, 0, Board, Row, Column, 0, GameEnd),
	updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, NewValid, NewBoard).

findPiece([], _, _, _, _, _).
findPiece([_ | _], _, _, _, _, 1):-write('IT IS DONE!!!'),nl.
% it isn't a piece, goes to next row
findPiece([Head | Tail], Board, NewBoard, Row, Column, GameEnd):-
	Head == nil,!,
	NewColumn is Column + 1,
	findPiece(Tail, Board, NewBoard, Row, NewColumn, GameEnd).
% finds a piece and analises around it
findPiece([Head | Tail], Board, NewBoard, Row, Column, GameEnd):-
	Head \== nil,
	checkPieceStatus(Head, Board, NewBoard, Row, Column, GameEnd),
	NewColumn is Column + 1,
	findPiece(Tail, Board, NewBoard, Row, NewColumn, GameEnd).

checkGameEnd([], _, _, _, _):- write('Game has not ended!'). % continue next player
checkGameEnd([_ | _], _, _, _, 1):- write('Game is done!'). % end game
checkGameEnd([Head | Tail], Board, NewBoard, Row, GameEnd):-
	findPiece(Head, Board, NewBoard, Row, 0, GameEnd),
	NewRow is Row + 1,
	checkGameEnd(Tail, NewBoard, NewNewBoard, NewRow, GameEnd).


board([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, [j, 0, 1, 0], nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 0], [p, 0, 0, 0], nil],
	[nil, nil, nil, nil, [o, 0, 1, 0], nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]).

teste8:- board(Board), checkGameEnd(Board, Board, NewBoard, 0, 0), prepareBoard(NewBoard).
