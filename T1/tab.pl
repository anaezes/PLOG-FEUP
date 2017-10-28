:- use_module(library(lists)).
/*board([
		[nil, nil, nil],
		[nil, [a, 0, 1, 0], nil],
		[nil, nil, nil]
	  ]).*/

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

getCode(a,97).
getCode(b,98).
getCode(c,99).
getCode(d,100).
getCode(e,101).
getCode(f,102).
getCode(g,103).
getCode(h,104).
getCode(i,105).
getCode(j,106).
getCode(k,107).
getCode(l,108).
getCode(m,109).
getCode(n,110).
getCode(o,111).
getCode(p,112).
getCode(q,113).
getCode(r,114).
getCode(s,115).
getCode(t,116).

validSymbol(0, 255). % válida
validSymbol(1, 157). % inválida
validSymbol([Head | Tail], Valid):- validSymbol(Head, Valid).

getColorPlayer(1, 'WHITE').
getColorPlayer(0, 'BLACK').

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



/** PRINT AVAILABLE PIECES **/

printAvailablePiecesRow(PieceRow, [Head , []]).
printAvailablePiecesRow(PieceRow, [Head , [Head2 | Tail] ]):- 
	write(' |'),
	printPieceSymbols(PieceRow, Head2, Head, 1), 
	write('| '),
	printAvailablePiecesRow(PieceRow, [Head, Tail]).

printAvailablePiecesAux(3, _).
printAvailablePiecesAux(PieceRow, List):- 
	copyList(List, AuxList),
	printAvailablePiecesRow(PieceRow, List),
	NewPieceRow is PieceRow + 1, nl,
	printAvailablePiecesAux(NewPieceRow, AuxList).

% Clone a list 
copyList(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

prepareLegendsPieces([]).
prepareLegendsPieces([Head|Tail]):- 
	getCode(Head, Code),
	put_code(Code),
	write('      '),
	prepareLegendsPieces(Tail).

printInfo(Player):-
	getColorPlayer(Player, Color), nl,
	write(' **************************'), nl,
	write(' ******  '), write(Color), write(' TURN'), write('  ******'), nl, 
	write(' **************************'), nl, nl.

printAvailablePieces(PieceRow,  [Head , [Head2 | Tail]]):- 
	printInfo(Head),
	write('   '),
	copyList([Head2 | Tail], AuxTail),
	prepareLegendsPieces(AuxTail), nl,
	printSeparator(NumPieces), 
	printAvailablePiecesAux(PieceRow, [Head , [Head2 | Tail]]).






/**************************
**** FUNCTIONS TO MOVE ****
**************************/

%addPiece([], Row, Column, PieceCode, Color, Rotation, [PieceCode,Rotation,Color,0], NewColor).

addSpaceMatrix(Board, Length, NewBoard):-
	%write('LENGHT::::: '), write(Length), nl,
	append([Board], [[nil, nil, nil]], AuxNewBoard),
	append([[nil, nil, nil]], AuxNewBoard, NewBoard).


addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard, NewColor):-
	append([[PieceCode,Rotation,Color,0]], Board, AuxBoard),
	append([nil], AuxBoard, AuxTwoBoard),
	length(AuxTwoBoard,Length),
	addSpaceMatrix(AuxTwoBoard, Length, NewBoard).







/****************
**** TESTING ****
*****************/

teste1 :- 
	prepareBoard([
					[nil, nil, nil, nil, nil],
					[nil, nil, [a, 0, 1, 0], [b, 0, 0, 0], nil],
					[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
					[nil, nil, nil, nil, nil]
				]).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [0,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


%Test for print first move.
teste3 :- board(Board), 
	addPiece(Board, 1, 1, a, 0, 0, NewBoard, NewColor), 
	prepareBoard(NewBoard).
board([nil]).