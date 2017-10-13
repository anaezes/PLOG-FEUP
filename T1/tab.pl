board([
		[nil, nil, nil],
		[nil, [a, 0, 1, 0], nil],
		[nil, nil, nil]
	  ]).
:- use_module(library(lists)).

% one of many
patternLetter(a, [[1,1,0],[0,0,0],[1,0,1]]).
patternLetter(b, [[0,0,0],[0,0,1],[1,1,1]]).
% ....
getSymbol(0, 0, 'P'). % peça preta sem quadrado
getSymbol(0, 1, 'B'). % peça preta com quadrado
getSymbol(1, 0, 'B'). % peça branca sem quadrado
getSymbol(1, 1, 'P'). % peça branca com quadrado
validSymbol(0, 'V'). % válida
validSymbol(1, 'I'). % inválida
validSymbol([Head | Tail], Valid):- validSymbol(Head, Valid).

/*
getPiecePatternRow(Count, PieceNum, [Head | Tail], Pattern) :- 
	Count == PieceNum.
getPiecePatternRow(Count, PieceNum, [Head | Tail], Pattern):-
	NewCount is Count + 1,
	getPiecePatternRow(NewCount, PieceNum, Tail, Head).
getPiecePattern(Count, PieceNum, Letter, Pattern):-
	patternLetter(Letter, TempPattern),
	getPiecePatternRow(-1, PieceNum, TempPattern, Pattern).
*/


% funções que vao rodar a matriz
/*rotatePattern(0, OldPattern, NewPattern). % acabar
rotatePattern(1, OldPattern, NewPattern).
rotatePattern(2, OldPattern, NewPattern).
rotatePattern(3, OldPattern, NewPattern).*/

% Get rotation
getPieceRotation([Head | _], OldPattern, NewPattern):-
	rotatePattern(Head, OldPattern, NewPattern).

% Get color
getPieceInfo([],_,_).
getPieceInfo([Head | Tail], Color, Valid):-
	Color = Head,
	validSymbol(Tail, Valid).

% Get pattern
getPiecePattern(PieceNum, Letter, Pattern):-
	patternLetter(Letter, TempPattern),
	nth0(PieceNum, TempPattern, Pattern).

printEachSymbol([],_,_).
printEachSymbol([Head | Tail], Color, Valid):-
	getSymbol(Head, Color, Char),
	write(Char),
	printEachSymbol(Tail, Color, Valid).
printPieceSymbols(PieceNum, Letter, Color, Valid):-
	getPiecePattern(PieceNum, Letter, Pattern),
	printEachSymbol(Pattern, Color, Valid).

printPiece([], PieceNum).
printPiece(nil, PieceNum) :- 
	write('|   |').
printPiece([Letter, Rotation | Tail], PieceNum):-
	% getPieceRotation(Rotation, Pattern, NewPattern),
	getPieceInfo(Tail, Color, Valid),
	write('|'),
	printPieceSymbols(PieceNum, Letter, Color, Valid),
	write('|').


printRowPieces([],Num,PieceNum):- nl.
printRowPieces([Head | Tail], Num, PieceNum):-
	printPiece(Head, PieceNum),
	printRowPieces(Tail, Num, PieceNum).
printRow(0,PieceNum,Row).
printRow(Num,PieceNum,Row):-
	NewNum is Num - 1,
	NewPieceNum is PieceNum + 1,
	printRowPieces(Row, NewNum, NewPieceNum),
	printRow(NewNum, NewPieceNum,Row).

printBoard([]).
printBoard([Head | Tail]) :-
	write('---------------'),nl,
	printRow(3,-1,Head),
	write('---------------'),nl,
	printBoard(Tail).

teste :- printBoard([
						[nil, nil, nil, nil],
						[nil, [a, 0, 1, 0], [a, 0, 0, 0], nil],
						[nil, nil, nil, nil]
					]).