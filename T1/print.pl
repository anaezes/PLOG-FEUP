
printColumnId :- write('| A | B | C |'), nl.

printInitialSeparator:-write('-------------'), nl.

rowIdentifiers([' 1 ', ' 2 ', ' 3 ']).

printMiddleSeparator :- write('|').

printCell(Char) :- write(Char).

printBoardLine([]) :- write('|'), nl.

printBoardLine([H|T]) :- printMiddleSeparator, getSymbol(H, Char), printCell(Char), printBoardLine(T).


printBoardAux([]) :- nl.
printBoardAux([H|T]) :- printBoardLine(H), printBoardAux(T).

getSymbol(emptyCell, '   ').
getSymbol(white, ' W ').
getSymbol(black, ' B ').

printBoard(X):-printColumnId, printInitialSeparator, printBoardAux(X).

teste:-printBoard([
	[emptyCell, emptyCell, emptyCell],
	[emptyCell, white, emptyCell],
	[emptyCell, emptyCell, emptyCell]
	]).

/*
rowIdentifiers([' 1 ', ' 2 ', ' 3 ']).

getSymbol(emptyCell, ' ').
getSymbol(white, 'W').
getSymbol(black, 'B').

printColumnId :- write('| A | B | C |'), nl.

printInitialSeparator:-write('_____________'), nl.

printMiddleSeparator :- write('|   |   |   |'), nl.

printFinalSeparator :-  write('|___|___|___|'), nl.

printCell(Char) :- write('|'), write(Char), write(' ').

printBoardLine([]) :- write('|'), nl, printFinalSeparator.
printBoardLine([H|T]) :- getSymbol(H, Char), printCell(Char), printBoardLine(T).

printBoardAux([]) :- nl.
printBoardAux([H|T],[RowId,RowTail]) :- printMiddleSeparator,write(RowId),
 printBoardLine(H), printBoardAux(T,RowTail).

printBoard(board):-printColumnId, printInitialSeparator, rowIdentifiers(RowId),
	 printBoardAux(board,RowId).

teste:-printBoard([
	[emptyCell, emptyCell, emptyCell],
	[emptyCell, white, emptyCell],
	[emptyCell, emptyCell, emptyCell]
	]).*/