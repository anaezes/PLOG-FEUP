:- use_module(library(lists)).
:- use_module(library(clpfd)).


:-include('print.pl').


/**************************
**** FUNCTIONS TO MOVE ****
**************************/

addNilSpaces(0, _, []).
addNilSpaces(Length, Value, [Value|NewList]):- 
NewLength is Length-1,
NewLength @>= 0,
addNilSpaces(NewLength, Value, NewList).


addSpaceMatrix(Board, Length, NewBoard):-
addNilSpaces(Length, nil, AuxList1),
append([Board], [AuxList1], AuxNewBoard),
addNilSpaces(Length, nil, AuxList2),
append([AuxList2], AuxNewBoard, NewBoard).

%first move
addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard, NewColor):-
append([[PieceCode,Rotation,Color,0]], Board, AuxBoard),
append([nil], AuxBoard, AuxTwoBoard),
length(AuxTwoBoard,Length),
addSpaceMatrix(AuxTwoBoard, Length, NewBoard),
prepareBoard(NewBoard).

%insert new piece at specific position
insertAt(Piece,Column,Board,NewBoard) :-
   same_length([Piece|Board],NewBoard),
   append(Before,BoardAux,Board),
   length(Before,Column),
   append(Before,[Piece|BoardAux],NewBoard).

%Replace Row 
list_nth0_item_replaced([_|Xs], 0, E, [E|Xs]).
list_nth0_item_replaced([X|Xs], N, E, [X|Ys]) :-
	N > 0,
   N0 is N-1,
   write('N: '),  write(N), nl,
   write('N0: '),  write(N0), nl,
   list_nth0_item_replaced(Xs, N0, E, Ys).


addNil(_, _, 1, _).

addNil(Board, LengthRow, LineLength, NewBoard):-
	nl, nl, write('!!!!addNil ENTROU !!!!!'), nl,
	write('LineLength: '), write(LineLength), nl,
	write('LengthRow: '), write(LengthRow), nl,
	nth1(LineLength, Board, RowBoard),
	length(RowBoard, CurrLengthRow),

	once(verifyCondition(Board, LengthRow, LineLength, NewLineLength, NewBoard, RowBoard, CurrLengthRow)),

	write('LineLength: '), write(LineLength), nl,
	write('LengthRow: '), write(LengthRow), nl,
	addNil(NewBoard, LengthRow, NewLineLength, NewBoard).

verifyCondition(Board, LengthRow, LineLength, NewLineLength, NewBoard, RowBoard, CurrLengthRow) :- 
	write('entrou condição diferentes'), nl,
	CurrLengthRow \== LengthRow, !,
	write('passou condição diferentes'), nl,
	insertAt(nil, 0, RowBoard, NewRowBoard),
	write('NOVA LINHA: '), write(NewRowBoard), nl,
	NewLineLength is LineLength-1,
	write('NewLineLength: '), write(NewLineLength), nl,
	%replacement(Board, NewLineLength, NewRowBoard, NewBoard),
	list_nth0_item_replaced(Board, NewLineLength, NewRowBoard, NewBoard),
	write('NOVA BOARD: '), write(NewBoard), nl.

verifyCondition(Board, LengthRow, LineLength, NewLineLength, NewBoard, RowBoard, CurrLengthRow) :-
	write('entrou condição iguais'), nl,
	CurrLengthRow == LengthRow, !,
	write('passou condição iguais'), nl,
	NewLineLength is LineLength-1.



addPieceTest(Board, Row, Column, PieceCode, Color, Rotation, BoardFinal, NewColor):-
	nth1(Row, Board, RowBoard),
	insertAt([PieceCode,Rotation,Color,0], Column, RowBoard, NewRowBoard),
	AuxNewRow is Row-1,
	write('NOVA LINHA: '), write(NewRowBoard), nl,
	list_nth0_item_replaced(Board, AuxNewRow, NewRowBoard, NewBoard),
	write('APOS SUBST LINHA: '), write(NewBoard), nl,
	length(NewRowBoard, LengthRow),
	length(Board, LineLength),
	write('LengthRow '), write(LengthRow), nl,
	write('LineLength '), write(LineLength), nl,
	addNil(NewBoard, LengthRow, LineLength, BoardFinal),
	write(BoardFinal), nl,
	prepareBoard(BoardFinal).


/****************
**** TESTING ****
*****************/


teste1 :- 
prepareBoard([
	[nil, nil, nil, nil, nil],
	[nil, nil, [a, 3, 0, 0], [b, 1, 0, 0], nil],
	[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
	[nil, nil, nil, nil, nil]
	]).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [0,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


%Test for print first move.
teste3 :- board1(Board), addPiece(Board, 1, 1, a, 0, 3, NewBoard, NewColor).


%test add multiples nils in a row
teste4 :- addNilSpaces( 5, nil, List).

%Test for print first move.
teste5 :- board2(Board), addPieceTest(Board, 2, 1, b, 1, 3, NewBoard, NewColor).


board1([nil]).
board2([
	[nil, nil, nil],
	[nil, [a, 3, 0, 0], nil],
	[nil, nil, nil]
	]).


