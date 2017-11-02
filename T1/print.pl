
/**************************
**** FUNCTIONS TO PRINT ****
**************************/


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
patternLetter(j, [[1,1,0],[0,0,0],[0,1,1]]).
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
validSymbol([Head | _], Valid):- validSymbol(Head, Valid).

getColorPlayer(1,'WHITE').
getColorPlayer(0,'BLACK').
getTypePlayer(1, ' HUMAN  ').
getTypePlayer(0, 'COMPUTER').

% Rotates piece
rotatePattern(0, OldPattern, OldPattern). 
rotatePattern(1, OldPattern, NewPattern):- % 90 degrees
	transpose(OldPattern, TempPattern),
	maplist(reverse, TempPattern, NewPattern).
rotatePattern(2, OldPattern, NewPattern):- % 180 degrees
	reverse(OldPattern, TempPattern),
	maplist(reverse, TempPattern, NewPattern).
rotatePattern(3, OldPattern, NewPattern):- % 270 degrees
	transpose(OldPattern, TempPattern),
	reverse(TempPattern, NewPattern).

% Get color
getPieceInfo([],_,_).
getPieceInfo([Head | Tail], Color, Valid):-
	Color = Head,
	validSymbol(Tail, Valid).

% Get pattern
getPiecePattern(PieceNum, Pattern, NewPattern):-
	nth0(PieceNum, Pattern, NewPattern).

getPiecePattern(PieceNum, Letter, Pattern):-
	patternLetter(Letter, TempPattern),
	nth0(PieceNum, TempPattern, Pattern).

%Prints the 
printEachSymbol([],_,_).
printEachSymbol([Head | Tail], Color, Valid):-
	getSymbol(Head, Color, Char),
	put_code(Char),
	printEachSymbol(Tail, Color, Valid).
printPieceSymbols(PieceNum, Pattern, Color, Valid):-
	getPiecePattern(PieceNum, Pattern, NewPattern),
	printEachSymbol(NewPattern, Color, Valid).

printPiece([], _, _).
printPiece(nil, _, _) :- 
	write('|   |').
printPiece([_Letter, _Rotation | Tail], Pattern, PieceNum):-
	getPieceInfo(Tail, Color, Valid),
	write('|'),
	printPieceSymbols(PieceNum, Pattern, Color, Valid),
	write('|').

getPiece(nil,nil).
getPiece([Letter, Rotation | _Tail], Piece):-
	patternLetter(Letter, Pattern),
	rotatePattern(Rotation, Pattern, Piece).

printRowPieces([],_, _):- nl.
printRowPieces([Head | Tail], Num, PieceNum):-
	getPiece(Head, Piece),
	printPiece(Head, Piece, PieceNum),
	printRowPieces(Tail, Num, PieceNum).

printRow(0,_,_,_).
printRow(2,PieceNum,Row,RowNumber):-
	NewPieceNum is PieceNum + 1,
	RowNumber < 10,
	write('  '), write(RowNumber), write(' '),
	printRowPieces(Row, 1, NewPieceNum),
	printRow(1, NewPieceNum,Row, RowNumber).
printRow(2,PieceNum,Row,RowNumber):-
	NewPieceNum is PieceNum + 1,
	write(' '), write(RowNumber), write(' '),
	printRowPieces(Row, 1, NewPieceNum),
	printRow(1, NewPieceNum,Row, RowNumber).
printRow(Num,PieceNum,Row, RowNumber):-
	NewNum is Num - 1,
	NewPieceNum is PieceNum + 1,
	write('    '),
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
	Count == 0,
	write(' | '), write(Count), write(' |'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).
printTopNumbers(Count, ColumnsNum):-
	write('| '), write(Count), write(' |'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).

printSeparator(0):- write('--').
printSeparator(ColumnsNum):-
	write('-----'),
	NewColumnsNum is ColumnsNum - 1,
	printSeparator(NewColumnsNum).


prepareBoard([Head | Tail]):-
	nl,length(Head, ColumnsNum),
	write('   '),printTopNumbers(0,ColumnsNum), nl,
	printBoard([Head | Tail], 0), nl.



/** PRINT AVAILABLE PIECES **/

printAvailablePiecesRow(_, [_ , []]).
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

prepareLegendsPieces([]).
prepareLegendsPieces([Head|Tail]):- 
	getCode(Head, Code),
	put_code(Code),
	write('      '),
	prepareLegendsPieces(Tail).

printInfoColor(Player):-
	getColorPlayer(Player, Color), nl,
	printSpace(50),write('**************************'), nl,
	printSpace(50),write('******  '), write(Color), write(' TURN'), write('  ******'), nl, 
	printSpace(50),write('**************************'), nl, nl.

printInfoType(Player):-
	getTypePlayer(Player, Color), nl,
	printSpace(50), write('*****************************'), nl,
	printSpace(50),write('******  '), write(Color), write(' TURN'), write('  ******'), nl, 
	printSpace(50),write('*****************************'), nl, nl.

printInfoColorComputer(Player):-
	getColorPlayer(Player, Color), nl,
	printSpace(50), write('***********************************'), nl,
	printSpace(50), write('******  '), write('COMPUTER '), write(Color), write(' TURN'), write('  ******'), nl, 
	printSpace(50),write('***********************************'), nl, nl.


 
printInfoDraw :-
	printSpace(50), write('***********************************'), nl,
	printSpace(50), write('******  '), write('DRAW! Try Again...'), nl, write('  ******'), nl, 
	printSpace(50),write('***********************************'), nl, nl, sleep(2).

printAvailablePieces(PieceRow,  [Head , [Head2 | Tail]]):- 
	write('  Available pieces: '), nl, nl,
	write('   '),
	copyList([Head2 | Tail], AuxTail),
	prepareLegendsPieces(AuxTail), nl,
	printAvailablePiecesAux(PieceRow, [Head , [Head2 | Tail]]).

printSpace(0).
printSpace(Value):-
	write(' '),
	NewValue is Value - 1,
	printSpace(NewValue).


printMenuScreen :- nl, nl,
	printSpace(40), write('          ********************************************************************'),nl,
	printSpace(40), write('          * ---------------------------------------------------------------- *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                ||\\\\   ||  ||       ||  ||  ||                | *'),nl,
	printSpace(40), write('          * |                || \\\\  ||  ||       ||  ||  ||                | *'),nl,
	printSpace(40), write('          * |                ||  \\\\ ||  || ==    ||  ||  ||                | *'),nl,
	printSpace(40), write('          * |                ||   \\\\||  ||    |__||  ||__||                | *'),nl,
	printSpace(40), write('          * |                ||    \\||  ||    \\__ /  |____|                | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                      **** WELCOME ! ****                     | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                        Human vs Human:                       | *'),nl,
	printSpace(40), write('          * |                         1.  Level I                          | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                        Human vs Computer:                    | *'),nl,
	printSpace(40), write('          * |                         2.  Level I                          | *'),nl,
	printSpace(40), write('          * |                         3.  Level II                         | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                     Computer vs Computer:                    | *'),nl,
	printSpace(40), write('          * |                         4.  Level I                          | *'),nl,
	printSpace(40), write('          * |                         5.  Level II                         | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * |                     Ana Santos up200700742                   | *'),nl,
	printSpace(40), write('          * |                  Margarida Silva up201505505                 | *'),nl,
	printSpace(40), write('          * |                                                              | *'),nl,
	printSpace(40), write('          * ---------------------------------------------------------------- *'),nl,
	printSpace(40), write('          ********************************************************************'),nl.


removePiecePlayed(ListAvailablePieces, PieceCode, NewListAvailablePieces) :- delete(ListAvailablePieces, PieceCode, NewListAvailablePieces).