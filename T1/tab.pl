board([
		[nil, nil, nil],
		[nil, [a, 0, 1, 0], nil],
		[nil, nil, nil]
	  ]).

% one of many
patternLetter(a, [[1,0,1],[0,0,0],[1,0,1]]).
% ....
colorSymbol(0, 'B'). % branca
colorSymbol(1, 'P'). % preta
validSymbol(0, ''). % válida
validSymbol(1, 'I'). % inválida

getPiecePatternRow(Count, PieceNum, [Head | Tail], Pattern) :- 
	Count == PieceNum.
getPiecePatternRow(Count, PieceNum, [Head | Tail], Pattern):-
	NewCount is Count + 1,
	getPiecePatternRow(NewCount, PieceNum, Tail, Head).
getPiecePattern(Count, PieceNum, Letter, Pattern):-
	patternLetter(Letter, TempPattern),
	getPiecePatternRow(-1, PieceNum, TempPattern, Pattern).

% funções que vao rodar a matriz
/*rotatePattern(0, OldPattern, NewPattern). % acabar
rotatePattern(1, OldPattern, NewPattern).
rotatePattern(2, OldPattern, NewPattern).
rotatePattern(3, OldPattern, NewPattern).*/
getPieceRotation([Head | _], OldPattern, NewPattern):-
	rotatePattern(Head, OldPattern, NewPattern).

getSymbols([Head | Tail], Color, Valid):-
	colorSymbol(Head, Color),
	validSymbol(Tail, Valid).

printEachSymbol([]).
printEachSymbol([Head | Tail]):-
	write(Head),
	printEachSymbol(Tail).
printPieceSymbols(PieceNum, Letter):-
	getPiecePattern(0, PieceNum, Letter, Pattern),
	printEachSymbol(Pattern).

printPiece([], PieceNum).
printPiece(nil, PieceNum) :- 
	write('|    |').
printPiece([Letter, Rotation | Tail], PieceNum):-
	/*% getPieceRotation(Rotation, Pattern, NewPattern),
	getSymbols(Tail, Color, Valid),*/
	write('|'),
	printPieceSymbols(PieceNum, Letter),
	write('|').


printRowPieces([],Num,PieceNum):- nl.
printRowPieces([Head | Tail], Num, PieceNum):-
	printPiece(Head, PieceNum),
	printRowPieces(Tail, Num, PieceNum).
printRow(0,Row).
printRow(Num,Row):-
	NewNum is Num - 1,
	PieceNum is 0,
	printRowPieces(Row, NewNum, PieceNum),
	printRow(NewNum, Row).

printBoard([]).
printBoard([Head | Tail]) :-
	write('------------------'),nl,
	printRow(3,Head),
	write('------------------'),nl,
	printBoard(Tail).

teste :- printBoard([
						[nil, nil, nil],
						[nil, [a, 0, 1, 0], nil],
						[nil, nil, nil]
					]).