/*updatePiece(Board, [Letter, Rotation, Color, Valid], Row, Column, Valid, NewBoard):-
	replace(Board,Row,Column,[Letter,Rotation,Color,Valid], NewBoard).
	%write(NewBoard), nl.
*/
/*
checkValidAndUpdate(Row, Col, [Letter, Rotation, Color, Valid], NewValid, Board, NewBoard):-
	NewValid == 1,!,
	replace(Board,Row,Col,[Letter,Rotation,Color,NewValid], NewBoard).
checkValidAndUpdate(Row, Col, [Letter, Rotation, Color, Valid], NewValid, Board, NewBoard).*/
checkColorPiece(Piece, Color, Count, NewCount, _Valid):-
	nth0(2, Piece, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1.
checkColorPiece(_Piece, _Color, Count, NewCount, Valid):- 
	NewCount is Count, 
	Valid is 1.

% Each case of each row of the pattern of piece
%row 0, col 0
checkRow([Head | Tail], Color, Valid, Board, 0, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	BeforeCol is Col - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(BeforeCol, BeforeRow, DiagonalCell),
	DiagonalCell \== nil,!,
	checkColorPiece(DiagonalCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 0, 1, Row, Col, NewCount, FinalCount).
checkRow([_Head | Tail], Color, Valid, Board, 0, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 0, 1, Row, Col, Count, FinalCount).

%row 0, col 1
checkRow([Head | Tail], Color, Valid, Board, 0, 1, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(Col, BeforeRow, AboveCell),
	AboveCell \== nil,!,
	checkColorPiece(AboveCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 0, 2, Row, Col, NewCount, FinalCount).
checkRow([_Head | Tail], Color, Valid, Board, 0, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 0, 2, Row, Col, Count, FinalCount).

%row 0, col 2
checkRow([Head | Tail], Color, Valid, Board, 0, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeRowNum is Row - 1,
	AfterCol is Col + 1,
	nth0(BeforeRowNum, Board, BeforeRow),
	nth0(AfterCol, BeforeRow, DiagonalCell),
	DiagonalCell \== nil,!,
	checkColorPiece(DiagonalCell, Color, Count, NewCount, Valid),
	checkRow(Tail, _, Valid, _, _, _, _, _, NewCount, FinalCount).
checkRow([_Head | Tail], _Color, Valid, _Board, 0, 2, _Row, _Col, Count, FinalCount):-
	checkRow(Tail, _, Valid, _, _, _, _, _, Count, FinalCount).

%row 1, col 0
checkRow([Head | Tail], Color, Valid, Board, 1, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	BeforeCol is Col - 1,
	nth0(Row, Board, SameRow),
	nth0(BeforeCol, SameRow, BeforeCell),
	BeforeCell \== nil,!,
	checkColorPiece(BeforeCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 1, 1, Row, Col, NewCount, FinalCount).
checkRow([_Head | Tail], Color, Valid, Board, 1, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 1, 1, Row, Col, Count, FinalCount).

%row 1, col 1
checkRow([_Head | Tail], Color, Valid, Board, 1, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 1, 2, Row, Col, Count, FinalCount).

%row 1, col 2
checkRow([Head | Tail], Color, Valid, Board, 1, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterCol is Col + 1,
	nth0(Row, Board, SameRow),
	nth0(AfterCol, SameRow, AfterCell),
	AfterCell \== nil,!,
	checkColorPiece(AfterCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 1, 2, Row, Col, NewCount, FinalCount). % Alterar para nada
checkRow([_Head | Tail], Color, Valid, Board, 1, 2 , Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 1, 2, Row, Col, Count, FinalCount).

%row 2, col 0
checkRow([Head | Tail], Color, Valid, Board, 2, 0, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	BeforeCol is Col - 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(BeforeCol, AfterRow, DiagonalCell),
	DiagonalCell \== nil,!,
	checkColorPiece(DiagonalCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 2, 1, Row, Col, NewCount, FinalCount).
checkRow([_Head | Tail], Color, Valid, Board, 2, 0, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 2, 1, Row, Col, Count, FinalCount).

%row 2, col 1
checkRow([Head | Tail], Color, Valid, Board, 2, 1, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(Col, AfterRow, UnderCell),
	UnderCell \== nil,!,
	checkColorPiece(UnderCell, Color, Count, NewCount, Valid),
	checkRow(Tail, Color, Valid, Board, 2, 2, Row, Col, NewCount, FinalCount).
checkRow([_Head | Tail], Color, Valid, Board, 2, 1, Row, Col, Count, FinalCount):-
	checkRow(Tail, Color, Valid, Board, 2, 2, Row, Col, Count, FinalCount).

%row 2, col 2
checkRow([Head | Tail], Color, Valid, Board, 2, 2, Row, Col, Count, FinalCount):-
	Head == 1,
	AfterRowNum is Row + 1,
	AfterCol is Col + 1,
	nth0(AfterRowNum, Board, AfterRow),
	nth0(AfterCol, AfterRow, DiagonalCell),
	DiagonalCell \== nil,!,
	checkColorPiece(DiagonalCell, Color, Count, NewCount, Valid),
	checkRow(Tail, _, Valid, _, _, _, _, _, NewCount, FinalCount).
checkRow([_Head | Tail], _Color, Valid, _Board, 2, 2, _Row, _Col, Count, FinalCount):-
	checkRow(Tail, _, Valid, _, _, _, _, _, Count, FinalCount).

checkRow([], _, _Valid, _, _, _, _, _, Count, FinalCount):- FinalCount is Count.

% Goes throught the piece pattern and checks each row of it
checkAroundPiece([], _, _, _, _, _, _, 4, GameEnd):- GameEnd is 1.
checkAroundPiece([], _, _, _, _, _, _, _, _).
checkAroundPiece([Head | Tail], Color, Valid, Board, PieceRow, Row, Col, CountPiecesAround, GameEnd):-
	checkRow(Head, Color, Valid, Board, PieceRow, 0, Row, Col, CountPiecesAround, FinalCount),
	NewPieceRow is PieceRow + 1,
	NewCountPiecesAround is FinalCount,
	checkAroundPiece(Tail, Color, Valid, Board, NewPieceRow, Row, Col, NewCountPiecesAround, GameEnd).

addPieceToChangeBoard(Row, Col, InvalidPieces, NewInvalidPieces):-
	append(InvalidPieces, [Row , Col], NewInvalidPieces),
	write('New InvalidPieces: '), write(NewInvalidPieces),nl.
addPieceToChangeBoard(_, _, _InvalidPieces, _NewInvalidPieces).

% Gets the pattern of the piece and checks if it is valid
checkPieceStatus([Letter, Rotation, Color, Valid], Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd):-
	Valid \== 1,
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	checkAroundPiece(Pattern, Color, NewValid, Board, 0, Row, Col, 0, GameEnd),
	NewValid == 1,!,
	addPieceToChangeBoard(Row, Col, InvalidPieces, NewInvalidPieces),
	write('InvalidPieces: '), write(NewInvalidPieces), nl.
	%checkValidAndUpdate(Row, Col, [Letter, Rotation, Color, Valid], NewValid, Board, NewBoard).
checkPieceStatus([_, _, _, _], _, InvalidPieces, NewInvalidPieces, _, _, _):-
	copyList(InvalidPieces, NewInvalidPieces).

% Goes through the row of the board and finds a Piece
findPiece([], _, _, _, _, _, _).
findPiece([_ | _], _, _, _, _, _, GameEnd):- GameEnd == 1, !.
findPiece([Head | Tail], Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd):-
	Head == nil,!,
	write('Find Piece1: '), write(InvalidPieces),nl,
	NewCol is Col + 1,
	findPiece(Tail, Board, InvalidPieces, NewInvalidPieces, Row, NewCol, GameEnd).
findPiece([Head | Tail], Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd):-
	Head \== nil,!,
	write('Find Piece2: '), write(InvalidPieces),nl,
	write(Head),nl,
	checkPieceStatus(Head, Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd),
	NewCol is Col + 1,
	findPiece(Tail, Board, NewInvalidPieces, _NewNewInvalidPieces, Row, NewCol, GameEnd).

% Goes through the invalid pieces and updates the board
updateBoard([], Board, _NewBoard):-write(Board),nl.
updateBoard([Row, Col | Tail], Board, NewBoard):-
	nth0(Row, Board, BoardRow),
	nth0(Col, BoardRow, [Letter, Rotation, Color, _Valid]),
	replace(Board,Row,Col,[Letter,Rotation,Color,1], NewBoard),
	updateBoard(Tail, NewBoard, NewBoard).

% Goes through the rows of the board
checkGameEnd([],Board,NewBoard,InvalidPieces,_,_):- 
	updateBoard(InvalidPieces, Board, NewBoard),
	write('Game continues!'),nl.
checkGameEnd([_ | _],_,_,_,_,GameEnd):- 
	GameEnd == 1, !, 
	write('The Game has ended!'),nl.
checkGameEnd([Head | Tail], Board, NewBoard, InvalidPieces, Row, GameEnd):-
	findPiece(Head, Board, InvalidPieces, NewInvalidPieces, Row, 0, GameEnd),
	NewRow is Row + 1,
	checkGameEnd(Tail, Board, NewBoard, NewInvalidPieces, NewRow, GameEnd).

board([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, [s, 0, 0, 0], nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 0], [p, 0, 0, 0], nil],
	[nil, nil, nil, [o, 0, 1, 0], nil, nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]). %[j, 0, 1, 0]

teste8:- board(Board), checkGameEnd(Board, Board, NewBoard, _InvalidPieces, 0, _GameEnd), write(NewBoard),nl, printBoardMain(Board).
