/*updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, NewValid, NewBoard):-
	replace(Board,Row,Column,[Letter,Rotation,Color,NewValid], NewBoard).
	%write(NewBoard), nl.
*/

% Each case of each row of the pattern of piece
%row 0, col 0
checkRow([Head | Tail], Color, Board, 0, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	BeforeCol is Col - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(BeforeCol, BeforeRow, DiagonalCell),
	DiagonalCell \== nil,
	nth0(2, DiagonalCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 0, 1, Row, Col, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 0, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 0, 1, Row, Col, Count, FinalCount).

%row 0, col 1
checkRow([Head | Tail], Color, Board, 0, 1, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	nth0(BeforeRow, Board, BeforeRowNum),
	nth0(Col, BeforeRow, AboveCell),
	AboveCell \== nil,
	nth0(2, AboveCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 0, 2, Row, Col, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 0, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 0, 2, Row, Col, Count, FinalCount).

%row 0, col 2
checkRow([Head | Tail], Color, Board, 0, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	AfterCol is Col + 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(AfterCol, BeforeRow, DiagonalCell),
	DiagonalCell \== nil,
	nth0(2, DiagonalCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, _, _, _, _, _, _, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 0, 2, Row, Col, Count, FinalCount):-
	checkRow(Tail, _, _, _, _, _, _, Count, FinalCount).

%row 1, col 0
checkRow([Head | Tail], Color, Board, 1, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeCol is Col - 1,
	nth0(Row, Board, SameRow),
	nth0(BeforeCol, SameRow, BeforeCell),
	BeforeCell \== nil,
	nth0(2, BeforeCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 1, 1, Row, Col, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 1, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 1, 1, Row, Col, Count, FinalCount).

%row 1, col 1
checkRow([Head | Tail], Color, Board, 1, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 1, 2, Row, Col, Count, FinalCount).

%row 1, col 2
checkRow([Head | Tail], Color, Board, 1, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterCol is Col + 1,
	nth0(Row, Board, SameRow),
	nth0(AfterCol, SameRow, AfterCell),
	AfterCell \== nil,
	nth0(2, AfterCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 1, 2, Row, Col, NewCount, FinalCount). % Alterar para nada
checkRow([Head | Tail], Color, Board, 1, 2 , Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 1, 2, Row, Col, Count, FinalCount).

%row 2, col 0
checkRow([Head | Tail], Color, Board, 2, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	BeforeCol is Col - 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(BeforeCol, AfterRow, DiagonalCell),
	DiagonalCell \== nil,
	nth0(2, DiagonalCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 2, 1, Row, Col, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 2, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 2, 1, Row, Col, Count, FinalCount).

%row 2, col 1
checkRow([Head | Tail], Color, Board, 2, 1, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(Col, AfterRow, UnderCell),
	UnderCell \== nil,
	nth0(2, UnderCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, Color, Board, 2, 2, Row, Col, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 2, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Board, 2, 2, Row, Col, Count, FinalCount).

%row 2, col 2
checkRow([Head | Tail], Color, Board, 2, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	AfterCol is Col + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(AfterCol, AfterRow, DiagonalCell),
	DiagonalCell \== nil,
	nth0(2, DiagonalCell, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1,
	checkRow(Tail, _, _, _, _, _, _, NewCount, FinalCount).
checkRow([Head | Tail], Color, Board, 2, 2, Row, Col, Count, FinalCount):-
	checkRow(Tail, _, _, _, _, _, _, Count, FinalCount).

checkRow([], _, _, _, _, _, _, Count, FinalCount):- write('COUNT: '), write(Count), nl,FinalCount is Count.


% Goes throught the piece pattern and checks each row of it
checkAroundPiece([], _, _, _, _, _, 4, GameEnd):-
	write('Here'),nl, GameEnd is 1.
checkAroundPiece([], _, _, _, _, _, _, _).
checkAroundPiece([Head | Tail], Color, Board, PieceRow, Row, Col, CountPiecesAround, GameEnd):-
	checkRow(Head, Color, Board, PieceRow, 0, Row, Col, CountPiecesAround, FinalCount),
	NewPieceRow is PieceRow + 1,
	NewCountPiecesAround is FinalCount,
	write('NewCountPieces: '), write(NewCountPiecesAround),nl,
	checkAroundPiece(Tail, Color, Board, NewPieceRow, Row, Col, NewCountPiecesAround, GameEnd).

% Gets the pattern of the piece and checks if it is valid
checkPieceStatus([Letter, Rotation, Color, Valid], Board, Row, Col, GameEnd):-
	Valid \== 1,!,
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	checkAroundPiece(Pattern, Color, Board, 0, Row, Col, 0, GameEnd).
checkPieceStatus([_, _, _, _], _, _, _, _).

% Goes through the row of the board and finds a Piece
findPiece([], _, _, _, _).
findPiece([_ | _], _, _, _, GameEnd):- GameEnd == 1, !.
findPiece([Head | Tail], Board, Row, Col, GameEnd):-
	Head == nil,!,
	NewCol is Col + 1,
	findPiece(Tail, Board, Row, NewCol, GameEnd).
findPiece([Head | Tail], Board, Row, Col, GameEnd):-
	Head \== nil,!,
	write(Head),nl,
	checkPieceStatus(Head, Board, Row, Col, GameEnd),
	NewCol is Col + 1,
	findPiece(Tail, Board, Row, NewCol, GameEnd).

% Goes through the rows of the board
checkGameEnd([],_,_,_):- write('Game continues!'),nl.
checkGameEnd([_ | _],_,_,GameEnd):- GameEnd == 1, !, write('The Game has ended!'),nl.
checkGameEnd([Head | Tail], Board, Row, GameEnd):-
	findPiece(Head, Board, Row, 0, GameEnd),
	NewRow is Row + 1,
	checkGameEnd(Tail, Board, NewRow, GameEnd).

board([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, [j, 0, 1, 0], nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 0], [p, 0, 0, 0], nil],
	[nil, nil, nil, [o, 0, 1, 0], nil, nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]).

teste8:- board(Board), checkGameEnd(Board, Board, 0, GameEnd), prepareBoard(Board).
