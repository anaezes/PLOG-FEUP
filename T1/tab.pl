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

getSymbol(0, 0, 178). % peça preta sem quadrado
getSymbol(1, 0, 254). % peça preta com quadrado
getSymbol(0, 1, 176). % peça branca sem quadrado
getSymbol(1, 1, 254). % peça branca com quadrado

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

printRow(0,_,_,_).
printRow(2,PieceNum,Row,RowNumber):-
	NewPieceNum is PieceNum + 1,
	write(' '), write(RowNumber), write(' '),
	printRowPieces(Row, 1, NewPieceNum),
	printRow(1, NewPieceNum,Row, RowNumber).
printRow(Num,PieceNum,Row, RowNumber):-
	NewNum is Num - 1,
	NewPieceNum is PieceNum + 1,
	write('   '),
	printRowPieces(Row, NewNum, NewPieceNum),
	printRow(NewNum, NewPieceNum,Row,RowNumber).

% Calls the function to print each row
printBoard([], _).
printBoard([Head | Tail], RowCount) :-
	length(Head, ColumnsNum),
	write('   '), printSeparator(ColumnsNum), nl,
	printRow(3,-1,Head, RowCount),
	NewRowCount is RowCount + 1,
	write('   '),printSeparator(ColumnsNum), nl,
	printBoard(Tail, NewRowCount).

% Board numbers and separators
printTopNumbers(_, 0). 
printTopNumbers(Count, ColumnsNum):-
	write('| '), write(Count), write(' |'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).

printSeparator(0).
printSeparator(ColumnsNum):-
	write('-----'),
	NewColumnsNum is ColumnsNum - 1,
	printSeparator(NewColumnsNum).


prepareBoard([Head | Tail]):-
	nl,length(Head, ColumnsNum),
	write('   '),printTopNumbers(0,ColumnsNum), nl,
	printBoard([Head | Tail], 0).

printAvailablePiecesRow(PieceRow, [Head , []]).
printAvailablePiecesRow(PieceRow, [Head , [Head2 | Tail] ]):- 
	write('|'),
	printPieceSymbols(PieceRow, Head2, Head, 1), 
	write('|'),
	printAvailablePiecesRow(PieceRow, [Head, Tail]).

printAvailablePiecesAux(3, _).
printAvailablePiecesAux(PieceRow, List):- 
	copyList(List, AuxList),
	printAvailablePiecesRow(PieceRow, List),
	NewPieceRow is PieceRow + 1, nl,
	printAvailablePiecesAux(NewPieceRow, AuxList).

copyList(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

prepareLegendsPieces(117).
prepareLegendsPieces(NumLeter):- 
	put_code(NumLeter),
	write('    '),
	NewNumLeter is NumLeter + 1,
	prepareLegendsPieces(NewNumLeter).

printAvailablePieces(PieceRow, List):- 
	write('  '),
	prepareLegendsPieces(97), nl,
	%length(List,NumPieces), nl,
	printSeparator(NumPieces), 
	printAvailablePiecesAux(PieceRow, List).

teste1 :- 
	prepareBoard([
					[nil, nil, nil, nil, nil],
					[nil, nil, [a, 0, 1, 0], [b, 0, 0, 0], nil],
					[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
					[nil, nil, nil, nil, nil]
				]).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [1,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


