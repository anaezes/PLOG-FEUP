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
					[nil, nil, [a, 3, 0, 0], [b, 1, 0, 0], nil],
					[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
					[nil, nil, nil, nil, nil]
				]).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [0,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


%Test for print first move.
teste3 :- board(Board), addPiece(Board, 1, 1, a, 0, 3, NewBoard, NewColor), prepareBoard(NewBoard).
board([nil]).

%test add multiples nils in a row
teste4 :- addNilSpaces( 5, nil, List).


