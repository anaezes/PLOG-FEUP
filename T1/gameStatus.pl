
/**
* Verify Draw.
**/
vertifyDraw(PiecesWhite, PiecesBlack, NewDraw) :-
	length(PiecesBlack, NumPiecesBlack),
	length(PiecesWhite, NumPiecesWhite),
	NumPiecesWhite == 0,
	NumPiecesBlack == 0, !,
	NewDraw = 1.
vertifyDraw(_PiecesWhite, _PiecesBlack, NewDraw) :- 
	!, NewDraw = 0.
	

/**
* Check Color of Piece.
**/
checkColorPiece(Piece, Color, Count, NewCount, _Valid):-
	nth0(2, Piece, ColorCell),
	ColorCell == Color, !,
	NewCount is Count + 1.
checkColorPiece(_Piece, _Color, Count, NewCount, Valid):- 
	NewCount is Count, 
	Valid is 1.


/**
* Each case of each row of the pattern of piece.
**/
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


/**
* Goes throught the piece pattern and checks each row of it.
**/
checkAroundPiece([], _, _, _, _, _, _, CountPiecesAround, GameEnd):- CountPiecesAround == 4, !, GameEnd is 1.
checkAroundPiece([], _, _, _, _, _, _, _, _).
checkAroundPiece([Head | Tail], Color, Valid, Board, PieceRow, Row, Col, CountPiecesAround, GameEnd):-
	checkRow(Head, Color, Valid, Board, PieceRow, 0, Row, Col, CountPiecesAround, FinalCount),
	NewPieceRow is PieceRow + 1,
	NewCountPiecesAround is FinalCount,
	checkAroundPiece(Tail, Color, Valid, Board, NewPieceRow, Row, Col, NewCountPiecesAround, GameEnd).


/**
* Gets the pattern of the piece and checks if it is valid.
**/
checkPieceStatus([Letter, Rotation, Color, Valid], Board, _InvalidPiece, Row, Col, GameEnd):-
	Valid \== 1,
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	checkAroundPiece(Pattern, Color, _NewValid, Board, 0, Row, Col, 0, NewGameEnd),
	NewGameEnd == 1,!,
	GameEnd is 1.
checkPieceStatus([Letter, Rotation, Color, Valid], Board, InvalidPiece, Row, Col, _GameEnd):-
	Valid \== 1,
	getPiece([Letter, Rotation, Color, Valid], Pattern),
	checkAroundPiece(Pattern, Color, NewValid, Board, 0, Row, Col, 0, _NewGameEnd),
	NewValid == 1,!,
	append(_, [Row, Col], InvalidPiece).
checkPieceStatus([_, _, _, _], _, _, _, _, _).


/**
* Appends the new Invalid Pieces to the others.
**/
aggregateInvalidPieces(OldInvalidPieces, NewInvalidPieces, AllInvalidPieces):-
	is_list(OldInvalidPieces),
	is_list(NewInvalidPieces),!,
	append(OldInvalidPieces, NewInvalidPieces, AllInvalidPieces).
aggregateInvalidPieces(OldInvalidPieces, _NewInvalidPieces, AllInvalidPieces):-
	is_list(OldInvalidPieces),!,
	copyList(OldInvalidPieces, AllInvalidPieces).
aggregateInvalidPieces(_OldInvalidPieces, NewInvalidPieces, AllInvalidPieces):-
	is_list(NewInvalidPieces),!,
	copyList(NewInvalidPieces, AllInvalidPieces).
aggregateInvalidPieces(_OldInvalidPieces, _NewInvalidPieces, _AllInvalidPieces).


/**
* Goes through the row of the board and finds a Piece.
**/
findPiece([], _, InvalidPieces, NewInvalidPieces, _, _, _):-
	copyList(InvalidPieces, NewInvalidPieces).
findPiece([_ | _], _, _, _, _, _, GameEnd):- GameEnd == 1, !.
findPiece([Head | Tail], Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd):-
	Head == nil,!,
	NewCol is Col + 1,
	findPiece(Tail, Board, InvalidPieces, NewInvalidPieces, Row, NewCol, GameEnd).
findPiece([Head | Tail], Board, InvalidPieces, NewInvalidPieces, Row, Col, GameEnd):-
	Head \== nil,!,
	%write(Head),nl,
	checkPieceStatus(Head, Board, NewInvalidPiece, Row, Col, GameEnd),
	NewCol is Col + 1,
	aggregateInvalidPieces(InvalidPieces, NewInvalidPiece, RowInvalidPieces),
	findPiece(Tail, Board, RowInvalidPieces, NewInvalidPieces, Row, NewCol, GameEnd).


/**
* Goes through the rows of the board.
**/
checkGameEnd(Board, NewInvalidPieces, GameEnd):- 
	checkGameEnd(Board, Board, _InvalidPieces, NewInvalidPieces, 0, GameEnd).
checkGameEnd([],_,InvalidPieces, FinalInvalidPieces,_,_):- 
	copyList(InvalidPieces, FinalInvalidPieces).
	%write('Game continues!'),nl.
checkGameEnd([_ | _],_,_,_,_,GameEnd):- 
	GameEnd == 1, !.
	%write('The Game has ended!'),nl.
checkGameEnd([Head | Tail], Board, InvalidPieces, FinalInvalidPieces, Row, GameEnd):-
	findPiece(Head, Board, _RowInvalidPieces, ResultInvalidPieces, Row, 0, GameEnd),
	NewRow is Row + 1,
	aggregateInvalidPieces(InvalidPieces, ResultInvalidPieces, NewInvalidPieces),
	%write('checkGameEnd: '), write(NewInvalidPieces),nl,
	checkGameEnd(Tail, Board, NewInvalidPieces, FinalInvalidPieces, NewRow, GameEnd).


/**
* Goes through the invalid pieces and updates the board.
**/
updateBoardAux([], Board, NewBoard):-
	copyList(Board, NewBoard).
	%write('Board Updated'),nl.
updateBoardAux([Row, Col | Tail], Board, NewBoard):-
	nth0(Row, Board, BoardRow),
	nth0(Col, BoardRow, [Letter, Rotation, Color, _Valid]),
	replace(Board,Row,Col,[Letter,Rotation,Color,1], TempBoard),
	updateBoardAux(Tail, TempBoard, NewBoard).
% Verifies if there are Invalid Pieces
updateBoard(InvalidPieces, Board, NewBoard):-
	is_list(InvalidPieces),!,
	updateBoardAux(InvalidPieces, Board, NewBoard).
updateBoard(_InvalidPieces, Board, NewBoard):-
	copyList(Board, NewBoard).