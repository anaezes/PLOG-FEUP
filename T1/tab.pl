:- use_module(library(lists)).
board([
		[nil, nil, nil],
		[nil, [a, 0, 1, 0], nil],
		[nil, nil, nil]
	  ]).

% Patterns
patternLetter(a, [[1,1,1],[0,0,1],[0,0,0]]).
patternLetter(b, [[1,1,1],[0,0,0],[0,0,1]]).
patternLetter(c, [[1,1,1],[0,0,0],[0,1,0]]).
patternLetter(d, [[1,1,1],[0,0,0],[1,0,0]]).
patternLetter(e, [[1,1,1],[1,0,0],[0,0,0]]).
patternLetter(f, [[1,1,0],[0,0,1],[0,0,1]]).
patternLetter(g, [[1,1,0],[0,0,1],[0,1,0]]).
patternLetter(h, [[1,1,0],[0,0,1],[1,0,0]]).
patternLetter(i, [[1,1,0],[1,0,1],[0,0,0]]).
patternLetter(j, [[1,1,0],[0,0,0],[1,1,1]]).
patternLetter(k, [[1,1,0],[0,0,0],[1,0,1]]).
patternLetter(l, [[1,1,0],[1,0,0],[0,0,1]]).
patternLetter(m, [[1,1,0],[0,0,0],[1,1,0]]).
patternLetter(n, [[1,1,0],[1,0,0],[0,1,0]]).
patternLetter(o, [[1,0,0],[0,0,1],[1,0,1]]).
patternLetter(p, [[1,0,0],[1,0,1],[0,0,1]]).
patternLetter(q, [[1,0,0],[0,0,1],[1,1,0]]).
patternLetter(r, [[1,0,0],[1,0,1],[0,1,0]]).
patternLetter(s, [[0,1,0],[1,0,1],[0,1,0]]).
patternLetter(t, [[1,0,1],[0,0,0],[1,0,1]]).

getSymbol(0, 0, 219). % peça preta sem quadrado
getSymbol(0, 1, 176). % peça preta com quadrado
getSymbol(1, 0, 176). % peça branca sem quadrado
getSymbol(1, 1, 219). % peça branca com quadrado

validSymbol(0, 255). % válida
validSymbol(1, 157). % inválida
validSymbol([Head | Tail], Valid):- validSymbol(Head, Valid).

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

%Prints the 
printEachSymbol([],_,_).
printEachSymbol([Head | Tail], Color, Valid):-
	getSymbol(Head, Color, Char),
	put_code(Char),
	%write(Char),
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