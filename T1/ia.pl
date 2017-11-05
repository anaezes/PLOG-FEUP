

bestMoveVitory(_, [], _, _, _, _, _, _).
bestMoveVitory(_, _, _, _, _, _, _, 1).
bestMoveVitory(Board, [H|T], ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory) :- 
	bestValidMove(Board, H, ValidMoves, ColorPlayer, Rotation, Row, Col, Vitory),
	write('bestMoveVitory' ), nl,
	Vitory \== 1, 
	bestMoveVitory(Board, T, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory).
bestMoveVitory(Board, [H|T], ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory) :- 
	bestValidMove(Board, H, ValidMoves, ColorPlayer, Rotation, Row, Col, Vitory),
	Vitory == 1, 
	Letter = H,
bestMoveVitory(Board, T, ValidMoves, ColorPlayer, Letter, Rotation, Row, Col, Vitory).



bestValidMove(_, _, nil, _, _, _, _, _).
bestValidMove(_, _, _, _, _, _, _, 1).
bestValidMove(Board, Letter, [H|T], ColorPlayer, Rotation, Row, Col, Vitory) :-
	write('bestValidMove' ), nl,
	nth0(0, H, X), nth0(1, H, Y),
	bestRotation(Board, Letter, X, Y, ColorPlayer, 0, Rotation, Vitory),
	Vitory \== 1, 
	bestValidMove(Board, Letter, T, ColorPlayer, Rotation, Row, Col, Vitory).
bestValidMove(Board, Letter, [H|T], ColorPlayer, Rotation, Row, Col, Vitory) :-
	nth0(0, H, X), nth0(1, H, Y),
	bestRotation(Board, Letter, X, Y, ColorPlayer, 0, Rotation, Vitory),
	Vitory == 1, 
	write(X), write(Y), 
	Row = X, Col = Y,
	bestValidMove(Board, Letter, T, ColorPlayer, Rotation, Row, Col, Vitory).




bestRotation(_, _, _, _, _, 4, _, _). % Not vitory
bestRotation(Board, Letter, Row, Col, ColorPlayer, AuxRot, Rotation, Vitory) :- 
write('bestRotation' ), nl,
	addPiece(Board, Row, Col, Letter, ColorPlayer, AuxRot, NewBoard),
	printBoardMain(NewBoard),
	checkGameEnd(Board, Board, InvalidPieces, FinalInvalidPieces, 0, Vitory),
	write(Vitory), nl, 
	NewVitory \== 1, !,
	NewAuxRot is AuxRot + 1,
	bestRotation(Board, Letter, Row, Col, ColorPlayer, NewAuxRot, Rotation, NewVitory).

%vitory	
bestRotation(Board, Letter, Row, Col, ColorPlayer, AuxRot, Rotation, Vitory) :- 
	Rotation = AuxRot.



getValidMoves(Board, ValidMoves) :-
	setof([X,Y], validMove(Board, X, Y), ValidMoves).



piecesWhite([a,c,d,e,f,g,h,j,k,l,m,n,q,r,s,t]).
validMoves([[0,4],[1,1],[1,3],[1,5],[2,0],[2,2],[2,3],[2,5],[3,0],[3,6],[4,1],[4,2],[4,4],[4,5],[5,3]]).

board5([
	[nil, nil, nil, nil, nil, nil, nil],
	[nil, nil, nil, nil, [s, 0, 0, 0], nil, nil],
	[nil, nil, nil, nil, [j, 0, 0, 0], nil, nil],
	[nil, [i, 0, 1, 0], [p, 0, 1, 0], [b, 0, 1, 1], [t, 0, 0, 0], [p, 0, 0, 0], nil],
[nil, nil, nil, [o, 0, 1, 0], nil, nil, nil],
	[nil, nil, nil, nil, nil, nil, nil]	
	]).


testeIA:- 
	board(Board),
	piecesWhite(PiecesWhite),
	getValidMoves(Board, ValidMoves),
	bestMoveVitory(Board, PiecesWhite, ValidMoves, 1, Letter, Rotation, Row, Col, Vitory),
	write('Vitory:' ), write(Vitory), nl,
	write('Letter:' ), write(Letter), nl,
	write('Rotation:' ), write(Rotation), nl,
	write('Row:' ), write(Row), nl,
	write('Col:' ), write(Col), nl.

testeRotation :- 
	board5(Board),
	bestRotation(Board, j, 2, 1, 1, 0, Rotation, Vitory), 
	write('Vitory:' ), write(Vitory), nl,
	write('Rotation:' ), write(Rotation), nl.

testeBestValidMove :- 
	board5(Board),
	write(Board),
	printBoardMain(CurrBoard),
	validMoves(ValidMoves),
	write(ValidMoves), nl, 
	bestValidMove(Board, j, ValidMoves, 1, Rotation, Row, Col, 0),
	write('Vitory:' ), write(Vitory), nl,
	write('Rotation:' ), write(Rotation), nl,
	write('Row:' ), write(Row), nl,
	write('Col:' ), write(Col), nl.        

