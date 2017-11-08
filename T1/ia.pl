

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


/*
testeRotation :- 
	board5(Board),
	bestRotation(Board, j, 2, 1, 1, 0, Rotation, Vitory, Aux), 
	write('Aux:' ), write(Aux), nl,
	write('Rotation:' ), write(Rotation), nl.

testeBestValidMove :- 
	board5(Board),
	write(Board),
	getValidMoves(Board, ValidMoves),
	write(ValidMoves), nl, 
	bestValidMove(Board, j, ValidMoves, BeforeCords, 1, Rotation, Row, Col, Vitory, Aux),
	write('Rotation:' ), write(Rotation), nl,
	write('Row:' ), write(Row), nl,
	write('Col:' ), write(Col), nl.       */

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