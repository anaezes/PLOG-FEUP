

bestMoveVitory(_, [], _, _, _, _, _, _, _,_, _ ) :- write('SAIU CASO BASE bestMove'), nl.
bestMoveVitory(Board, [H|T], BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory, AuxVitory) :- 
	AuxVitory \== 1, 
	bestValidMove(Board, H, ValidMoves, BeforeCords, ColorPlayer, Rotation, Row, Col, Vitory, AuxVitory),
	bestMoveVitory(Board, T, H, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory, AuxVitory).

bestMoveVitory(Board, [H|T], BeforeLetter, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory, AuxVitory) :-
	AuxVitory == 1, !,
	Letter = BeforeLetter.


bestValidMove(_, _, [], _, _, _, _, _, Vitory, AuxVitory).
bestValidMove(Board, Letter, [H|T], BeforeCords, ColorPlayer, Rotation, Row, Col, Vitory, AuxVitory) :-
	AuxVitory \== 1, !,
	nth0(0, H, X), nth0(1, H, Y),
	bestRotation(Board, Letter, X, Y, ColorPlayer, 0, Rotation, 0, AuxVitory),
	bestValidMove(Board, Letter, T, H, ColorPlayer, Rotation, Row, Col, NewVitory, AuxVitory).

bestValidMove(Board, _, _, BeforeCords, _, Rotation, Row, Col, Vitory, AuxVitory) :-
AuxVitory == 1, !,
	nth0(0, BeforeCords, X), Row = X,
	nth0(1, BeforeCords, Y), Col = Y.

bestRotation(_, _, _, _, _, 4, _, _, _). % Not vitory
bestRotation(Board, Letter, Row, Col, ColorPlayer, AuxRot, Rotation, Vitory, Aux) :- 
	Vitory \== 1, !,
	addPiece(Board, Row, Col, Letter, ColorPlayer, AuxRot, NewBoard),
	checkGameEnd(NewBoard, NewBoard, _InvalidPieces, _FinalInvalidPieces, 0, NewVitory),
	NewAuxRot is AuxRot + 1,
	bestRotation(Board, Letter, Row, Col, ColorPlayer, NewAuxRot, Rotation, NewVitory, Aux).

bestRotation(Board, Letter, Row, Col, ColorPlayer, AuxRot, Rotation, Vitory, Aux) :- 
	Aux is Vitory,
	Rotation is AuxRot - 1.


/*    FIND THE MOVE WITH THE BEST PONTUATION */
checkAroundScore([], _Valid, _ColorPlayer, _Board, _PieceRow, _Row, _Col, Count, LastFinalCount):- LastFinalCount is Count.
checkAroundScore([Head | Tail], Valid, ColorPlayer, Board, PieceRow, Row, Col, Count, LastFinalCount):-
	checkRow(Head, ColorPlayer, Valid, Board, PieceRow, 0, Row, Col, Count, FinalCount),
	NewPieceRow is PieceRow + 1,
	NewCountPiecesAround is FinalCount,
	checkAroundScore(Tail, Valid, ColorPlayer, Board, NewPieceRow, Row, Col, NewCountPiecesAround, LastFinalCount).

getPositionScore(_Board, [], _Position, _Rotation, _ColorPlayer, PositionMoves, AllPositionMoves):-
	copyList(PositionMoves, AllPositionMoves).
getPositionScore(Board, [Head | Tail], 4, Position, ColorPlayer, PositionMoves, AllPositionMoves):-
	getPositionScore(Board, Tail, 0, Position, ColorPlayer, PositionMoves, AllPositionMoves).
getPositionScore(Board, [Head | Tail], Rotation, Position, ColorPlayer, PositionMoves, AllPositionMoves):-
	getPiece([Head, Rotation, ColorPlayer, 0], Pattern),
	nth0(0, Position, Row),
	nth0(1, Position, Col),
	checkAroundScore(Pattern, Valid, ColorPlayer, Board, 0, Row, Col, 0, LastFinalCount),
	LastFinalCount \== 0, Valid \== 1, !,
	append(PositionMoves, [[LastFinalCount, Row, Col, [Head, Rotation, ColorPlayer, 0]]], NewPositionMoves),
	NewRotation is Rotation + 1,
	getPositionScore(Board, [Head | Tail], NewRotation, Position, ColorPlayer, NewPositionMoves, AllPositionMoves).
getPositionScore(Board, [Head | Tail], Rotation, Position, ColorPlayer, PositionMoves, AllPositionMoves):-
	NewRotation is Rotation + 1,
	getPositionScore(Board, [Head | Tail], NewRotation, Position, ColorPlayer, PositionMoves, AllPositionMoves).

getSecondBestMove(_Board, _AvailablePieces, [], _ColorPlayer, PossibleMoves, FinalPossibleMoves):- 
	sort(PossibleMoves, FinalPossibleMoves).
getSecondBestMove(Board, AvailablePieces, [Head | Tail], ColorPlayer, PossibleMoves, FinalPossibleMoves):-
	getPositionScore(Board, AvailablePieces, 0, Head, ColorPlayer, NewPositionMoves, AllPositionMoves),
	append(PossibleMoves, AllPositionMoves, NewPossibleMoves),
	getSecondBestMove(Board, AvailablePieces, Tail, ColorPlayer, NewPossibleMoves, FinalPossibleMoves). 

playSecondBestMove(PossibleMoves, Pieces, Board, NewBoard, Letter, Rotation, NumRow, NumCol):-
	length(PossibleMoves, ListSize),
	ListSize == 0,!,
	once(getPieceLetter(Pieces, Letter)),
	once(getRotation(Rotation)),
	once(getValidPosition(Board, NumRow, NumCol)).
playSecondBestMove(PossibleMoves, Pieces, Board, NewBoard, Letter, Rotation, NumRow, NumCol):-
	last(PossibleMoves, BestMove),
	nth0(1, BestMove, NumRow),
	nth0(2, BestMove, NumCol),
	nth0(3, BestMove, [Letter, Rotation, _Color, _Valid]).

pieces2([a,b,c,d,e]).
teste20:-
	board(Board),
	pieces2(PiecesWhite),
	getValidMoves(Board, ValidMoves),
	getSecondBestMove(Board, PiecesWhite, ValidMoves, 1, PossibleMoves, FinalPossibleMoves),
	write(FinalPossibleMoves),nl,
	printBoardMain(Board),
	playSecondBestMove(FinalPossibleMoves, PiecesWhite, Board, NewBoard, Letter, Rotation, NumRow, NumCol),
	printBoardMain(NewBoard).


pieces([p,q]).

testeIA:- 
	board(Board),
	pieces(PiecesWhite),
	getValidMoves(Board, ValidMoves),
	bestMoveVitory(Board, PiecesWhite, BeforeLetter, ValidMoves, 1, Letter, Rotation, Row, Col, Vitory, AuxVitory),
	write('AuxVitory:' ), write(AuxVitory), nl,
	write('Letter:' ), write(Letter), nl,
	write('Rotation:' ), write(Rotation), nl,
	write('Row:' ), write(Row), nl,
	write('Col:' ), write(Col), nl.