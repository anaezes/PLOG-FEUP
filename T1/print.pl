
/**
* Get Rotation
**/
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


/**
* Get color
**/
getPieceInfo([],_,_).
getPieceInfo([Head | Tail], Color, Valid):-
	Color = Head,
	validSymbol(Tail, Valid).


/**
* Get pattern
**/
getPiecePattern(PieceNum, Pattern, NewPattern):-
	nth0(PieceNum, Pattern, NewPattern).
getPiecePattern(PieceNum, Letter, Pattern):-
	patternLetter(Letter, TempPattern),
	nth0(PieceNum, TempPattern, Pattern).


/**
* Get the symbols of pattern
**/
printEachSymbol([],_,_,_,_).
printEachSymbol([_Head | Tail], 1, 1, Color, Valid):-
	put_char(Valid),
	printEachSymbol(Tail, 2, 1, Color, Valid).
printEachSymbol([Head | Tail], Col, PieceNum, Color, Valid):-
	getSymbol(Head, Color, Char),
	put_code(Char),
	NewCol is Col + 1,
	printEachSymbol(Tail, NewCol, PieceNum, Color, Valid).
printEachSymbol([],_,_).
printEachSymbol([Head | Tail], Color, Valid):-
	getSymbol(Head, Color, Char),
	put_code(Char),
	printEachSymbol(Tail, Color, Valid).


/**
* Print piece symbols
**/
printPieceSymbols(PieceNum, Pattern, Color, Valid):-
	getPiecePattern(PieceNum, Pattern, NewPattern),
	printEachSymbol(NewPattern, 0, PieceNum, Color, Valid).
printPieceSymbols(PieceNum, Pattern, Color, Valid):-
 	getPiecePattern(PieceNum, Pattern, NewPattern),
 	getPiecePattern(PieceNum, Pattern, NewPattern),
	printEachSymbol(NewPattern, Color, Valid).


/**
* Main function for print Pieces
**/
printPiece([], _, _).
printPiece(nil, _, _) :-
	write('|   |').
printPiece([_Letter, _Rotation | Tail], Pattern, PieceNum):-
	getPieceInfo(Tail, Color, Valid),
	write('|'),
	printPieceSymbols(PieceNum, Pattern, Color, Valid),
	write('|').


/**
* Get a piece after apply the rotation
**/
getPiece(nil,nil).
getPiece([Letter, Rotation | _Tail], Piece):-
	patternLetter(Letter, Pattern),
	rotatePattern(Rotation, Pattern, Piece).


/**
* Get one-piece row pattern
**/
printRowPieces([],_, _):- nl.
printRowPieces([Head | Tail], Num, PieceNum):-
	getPiece(Head, Piece),
	printPiece(Head, Piece, PieceNum),
	printRowPieces(Tail, Num, PieceNum).


/**
* Print each row of Board
**/
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


/**
* Calls the function to print each row
**/
printBoard([], _).
printBoard([Head | Tail], RowCount) :-
	length(Head, ColumnsNum),
	write('   '), printSeparator(ColumnsNum), nl,
	printRow(3,-1,Head, RowCount),
	NewRowCount is RowCount + 1,
	write('   '),printSeparator(ColumnsNum), nl,
	printBoard(Tail, NewRowCount).


/**
* Board numbers and separators
**/
printTopNumbers(_, 0).
printTopNumbers(Count, ColumnsNum):-
	Count == 0,
	write(' | '), write(Count), write(' |'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).
printTopNumbers(Count, ColumnsNum):-
	Count =< 9,
	write('| '), write(Count), write(' |'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).
printTopNumbers(Count, ColumnsNum):-
	write('| '), write(Count), write('|'),
	NewCount is Count + 1,
	NewColumnsNum is ColumnsNum - 1,
	printTopNumbers(NewCount, NewColumnsNum).


/**
* Print the horizontal separator of board
**/
printSeparator(0):- write('--').
printSeparator(ColumnsNum):-
	write('-----'),
	NewColumnsNum is ColumnsNum - 1,
	printSeparator(NewColumnsNum).


/**
* Main funtion of print board
**/
printBoardMain([Head | Tail]):-
	nl,length(Head, ColumnsNum),
	write('   '),printTopNumbers(0,ColumnsNum), nl,
	printBoard([Head | Tail], 0), nl.


/**
* Prints row's of available pieces
**/
printAvailablePiecesRow(_, [_ , []]).
printAvailablePiecesRow(PieceRow, [Head , [Head2 | Tail] ]):-
	write(' |'),
	Valid = '0',
	printPieceSymbols(PieceRow, Head2, Head, Valid),
	write('| '),
	printAvailablePiecesRow(PieceRow, [Head, Tail]).


/**
* Separates each piece per line
**/
printAvailablePiecesAux(3, _).
printAvailablePiecesAux(PieceRow, List):-
	copyList(List, AuxList),
	printAvailablePiecesRow(PieceRow, List),
	NewPieceRow is PieceRow + 1, nl,
	printAvailablePiecesAux(NewPieceRow, AuxList).


/**
* Prints de legends of the available pieces
**/
prepareLegendsPieces([]).
prepareLegendsPieces([Head|Tail]):-
	getCode(Head, Code),
	put_code(Code),
	write('      '),
	prepareLegendsPieces(Tail).


/**
* Main function to print available pieces
**/
printAvailablePieces(PieceRow,  [Head , [Head2 | Tail]]):-
	write('  Available pieces: '), nl, nl,
	write('   '),
	copyList([Head2 | Tail], AuxTail),
	prepareLegendsPieces(AuxTail), nl,
	printAvailablePiecesAux(PieceRow, [Head , [Head2 | Tail]]).


/**
* Print the black pieces turn
**/
printInfoColor(Player):-
	Player == 0, !,
	printSpace(5),write('    _                ___           '), nl,
	printSpace(5),write('   |_) |  _.  _ |     |     ._ ._  '), nl,
	printSpace(5),write('   |_) | (_| (_ |<    | |_| |  | | '), nl, nl, nl.


/**
* Print the white pieces turn
**/
printInfoColor(_Player):-
		printSpace(5),write('                          ___           '), nl,
		printSpace(5),write('   \\    /  |_  o _|_  _    |     ._ ._  '), nl,
		printSpace(5),write('    \\/\\/   | | |  |_ (/_   | |_| |  | | '), nl, nl, nl.


/**
* Informs that the players have draw and that the playing conditions have changed
**/
printInfoDraw :- nl,
	printSpace(5), write(' _              |    ___                                         _    _                                                                                   | '), nl,
	printSpace(5), write('/ \\|_    __  _  |     | |_  _  \\/    __ _ __     _    _|_    _ _|_   |_) o  _  _  _  _                _|_ o __  _    _|_ _    __  _     _    _|_|_  _ __  | '), nl,
	printSpace(5), write('\\_/| |   | |(_) o     | | |(/_ /     | (_|| |   (_)|_| |_   (_) |    |   | (/_(_ (/__>     o  o  o     |_ | |||(/_    |_(_)   |||(_)\\_/(/_    |_| |(/_||| o '), nl, nl, sleep(4).


/**
* Informs that someone has won
**/
printInfoWinGame(Player):- nl,
	Player == 0, !,
	printSpace(5), write('  _                                                 '), nl,
	printSpace(5), write(' |_)  |   _.   _  |     \\    /  o  ._    _  |  |  | '), nl,
	printSpace(5), write(' |_)  |  (_|  (_  |<     \\/\\/   |  | |  _>  o  o  o '), nl, nl, sleep(4).

printInfoWinGame(_Player):- nl,
	printSpace(5), write(' \\    /  |_   o  _|_   _     \\    /  o  ._    _  |  |  | '), nl,
	printSpace(5), write('  \\/\\/   | |  |   |_  (/_     \\/\\/   |  | |  _>  o  o  o '), nl, nl, sleep(4).

printInfoWinGame2(Type):- nl,
	Type == 'COMPUTER', !,
	printSpace(5), write('  _                                                                    '), nl,
	printSpace(5), write(' /    _   ._ _   ._        _|_   _   ._    \\    /  o  ._    _  |  |  | '), nl,
	printSpace(5), write(' \\_  (_)  | | |  |_)  |_|   |_  (/_  |      \\/\\/   |  | |  _>  o  o  o '), nl,
	printSpace(5), write('                 |                                                     '), nl, nl, sleep(4).

printInfoWinGame2(_Type):- nl,
	printSpace(5), write(' |_|       ._ _    _.  ._     \\    /  o  ._    _  |  |  | '), nl,
	printSpace(5), write(' | |  |_|  | | |  (_|  | |     \\/\\/   |  | |  _>  o  o  o '), nl, nl, sleep(4).


/**
* Prints information about changes to the board status
**/
printInformation(Letter) :-
	write('-> Computer played piece '), write(Letter), nl, nl.

printInformation(NumRow, NumCol, Letter) :-
	write('-> Computer played piece '), write(Letter), write(' in ('),
	write(NumRow), write(','), write(NumCol), write(')'), nl, nl.

printInformation(SourceRow, SourceColumn, DestRow, DestColumn) :-
	write('-> Computer removes piece from position ('),
	write(SourceRow), write(','), write(SourceColumn), write(')'), sleep(2),
	write('... and puts it'), write(' in position ('),
	write(DestRow), write(','), write(DestColumn), write(')'), nl, nl,  sleep(2).


/**
* Auxiliary function that prints a certain number of spaces
**/
printSpace(0).
printSpace(Value):-
	write(' '),
	NewValue is Value - 1,
	printSpace(NewValue).


/**
* Prints the color of the player, the board and available pieces at each game cycle
**/
printInfoGame(Board, ColorPlayer, Pieces) :-
	printInfoColor(ColorPlayer), sleep(1),
	printAvailablePieces(0, [ColorPlayer, Pieces]), sleep(1),
	printBoardMain(Board), nl, sleep(3).

% After draw
printInfoGame(Board, ColorPlayer) :-
	printInfoColor(ColorPlayer), sleep(1),
	printBoardMain(Board), nl, sleep(3).


/**
* Prints the game menu
**/
printMenuScreen :- nl, nl,
<<<<<<< Updated upstream
	printSpace(20), write('********************************************************************'),nl,
	printSpace(20), write('*  ______________________________________________________________  *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |         .__   __.  __                  __   __    __         | *'),nl,
	printSpace(20), write('* |         |  \\ |  | |  |                |  | |  |  |  |        | *'),nl,
	printSpace(20), write('* |         |   \\|  | |  |  ______        |  | |  |  |  |        | *'),nl,
	printSpace(20), write('* |         |  . `  | |  | |______| .--.  |  | |  |  |  |        | *'),nl,
	printSpace(20), write('* |         |  |\\   | |  |          |  `--\'  | |  \`--\'  |        | *'),nl,
	printSpace(20), write('* |         |__| \\__| |__|           \\______/   \\______/         | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                      **** WELCOME ! ****                     | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                      Human vs Human:                         | *'),nl,
	printSpace(20), write('* |                         1.  Level I                          | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                      Human vs Computer:                      | *'),nl,
	printSpace(20), write('* |                         2.  Level I                          | *'),nl,
	printSpace(20), write('* |                         3.  Level II                         | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                   Computer vs Computer:                      | *'),nl,
	printSpace(20), write('* |                         4.  Level I                          | *'),nl,
	printSpace(20), write('* |                         5.  Level II                         | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                         6.  Exit                             | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                                                              | *'),nl,
	printSpace(20), write('* |                    Ana Santos up200700742                    | *'),nl,
	printSpace(20), write('* |                 Margarida Silva up201505505                  | *'),nl,
	printSpace(20), write('* |______________________________________________________________| *'),nl,
	printSpace(20), write('*                                                                  *'),nl,
	printSpace(20), write('********************************************************************'),nl.


/**
* Prints the game loading animation
**/
printLoad :-
	clearScreen,
	printSpace(10), write('[                                                  ]   0 % '), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[=====                                             ]  10 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[==========                                        ]  20 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[===============                                   ]  30 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[====================                              ]  40 %'), nl, nl,sleep(0.2), clearScreen,
	printSpace(10), write('[=========================                         ]  50 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[==============================                    ]  60 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[===================================               ]  70 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[========================================          ]  80 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[=============================================     ]  90 %'), nl, nl, sleep(0.2), clearScreen,
	printSpace(10), write('[==================================================] 100 %'), nl, nl, sleep(0.5).
=======
	printSpace(20), write('          ********************************************************************'),nl,
	printSpace(20), write('          *  ______________________________________________________________  *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |         .__   __.  __                  __   __    __         | *'),nl,
	printSpace(20), write('          * |         |  \\ |  | |  |                |  | |  |  |  |        | *'),nl,
	printSpace(20), write('          * |         |   \\|  | |  |  ______        |  | |  |  |  |        | *'),nl,
	printSpace(20), write('          * |         |  . `  | |  | |______| .--.  |  | |  |  |  |        | *'),nl,
	printSpace(20), write('          * |         |  |\\   | |  |          |  `--\'  | |  \`--\'  |        | *'),nl,
	printSpace(20), write('          * |         |__| \\__| |__|           \\______/   \\______/         | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                      **** WELCOME ! ****                     | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                        Human vs Human:                       | *'),nl,
	printSpace(20), write('          * |                         1.  Level I                          | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                        Human vs Computer:                    | *'),nl,
	printSpace(20), write('          * |                         2.  Level I                          | *'),nl,
	printSpace(20), write('          * |                         3.  Level II                         | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                     Computer vs Computer:                    | *'),nl,
	printSpace(20), write('          * |                         4.  Level I                          | *'),nl,
	printSpace(20), write('          * |                         5.  Level II                         | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                                                              | *'),nl,
	printSpace(20), write('          * |                     Ana Santos up200700742                   | *'),nl,
	printSpace(20), write('          * |                  Margarida Silva up201505505                 | *'),nl,
	printSpace(20), write('          * |______________________________________________________________| *'),nl,
	printSpace(20), write('          *                                                                  *'),nl,
	printSpace(20), write('          ********************************************************************'),nl.
>>>>>>> Stashed changes
