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

getPiecePattern(Letter, Pattern):-
	patternLetter(Letter, Pattern).

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

printPiece([]).
printPiece(nil) :- 
	/*write('|    |'),nl % 4 spaces
	write('|    |'),nl,		*/		% error with the nl...doesn't make rows
	write('|    |').
printPiece([Letter, Rotation | Tail]):-
	/*getPiecePattern(Letter, Pattern),
	% getPieceRotation(Rotation, Pattern, NewPattern),
	getSymbols(Tail, Color, Valid),*/
	write('|  a |').


printRowPieces([]):- nl.
printRowPieces([Head | Tail]):-
	printPiece(Head),
	printRowPieces(Tail).
printRow(0,Row).
printRow(Num,Row):-
	NewNum is Num - 1,
	printRowPieces(Row),
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