:-use_module(library(clpfd)).
:-use_module(library(lists)).

:-include('puzzles.pl').

printPuzzle([], [], _, _).
printPuzzle([H|T], [H2|T2], N, 	Count) :-
	Count > N, !, nl,
	printPuzzle([H|T], [H2|T2], N, 	1).

printPuzzle([H|T], [H2|T2], N, Count) :-
	H2 \== nil,
	write(H2), write('|'),
	NewCount is Count + 1,
	printPuzzle(T, T2, N, NewCount).

printPuzzle([H|T], [H2|T2], N, Count) :-
	write(H), write('|'),
	NewCount is Count + 1,
	printPuzzle(T, T2, N, NewCount).

paintWay(List, Num, Pos):-
	length(List, L),
	Rest is L - Num,
	global_cardinality(List, [1-Num, 0-Rest]),
	element(Pos, List, 0).

% pos-1   | Number  | pos+1
% pos-n-1 | pos+n   | pos+n+1
getSubListFirstRow([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Pos > 1, Pos < N, !,
	Pos1 is Pos - 1,
	nth1(Pos1, PuzzleF, H1),
	nth1(Pos, PuzzleF, H2), %pos number (2)
	Pos2 is Pos + 1,
	nth1(Pos2, PuzzleF, H3), 
	Pos3 is Pos + N,
	nth1(Pos3, PuzzleF, H4),
	Pos4 is Pos3 - 1,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos3 + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 2).

% pos-n  | pos-n+1 
% Number | pos+1  
% pos + n| pos + N + 1 
getSubListFirstCol([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux is mod(Pos, N),
	Aux == 1, !,
	Pos1 is Pos - N,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N + 1,
	nth1(Pos2, PuzzleF, H2),
	nth1(Pos, PuzzleF, H3), %pos number
	Pos3 is Pos + 1,
	nth1(Pos3, PuzzleF, H4),
	Pos4 is Pos + N,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos4 + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 3).

% pos-n -1  | pos-n
% pos-1     | Number  
% pos + n+1 | pos + N  
getSubListLastCol([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux is mod(Pos, N),
	Aux == 0, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2),
	Pos3 is Pos - 1,
	nth1(Pos3, PuzzleF, H3),
	nth1(Pos, PuzzleF, H4), % pos number(4)
	Pos4 is Pos + N + 1,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos4 + N,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 4).

% pos-n-1 | pos-n   | pos-n+1
% pos-1   | Number  | pos+1
getSubListLastRow([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux1 is (N*N-N+1), Aux2 is (N*N),
	Pos > Aux1, Pos < Aux2, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2), 
	Pos3 is Pos - N + 1,
	nth1(Pos3, PuzzleF, H3),
	Pos4 is Pos - 1,
	nth1(Pos4, PuzzleF, H4),
	nth1(Pos, PuzzleF, H5), %pos number (5)
	Pos5 is Pos + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 5).



% number | pos+1 
% pos+N  | pos+N+1
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	Pos == 1, !,
	nth1(Pos, PuzzleF, H1), %pos number (1)
	Pos1 is Pos + 1,
	nth1(Pos1, PuzzleF, H2),
	Pos2 is Pos + N,
	nth1(Pos2, PuzzleF, H3),
	Pos3 is Pos2 + 1,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 1).

% pos-1 | number 
% pos+N-1  | pos+N
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	Pos == N, !,
	Pos1 is Pos - 1,
	nth1(Pos1, PuzzleF, H1),
	nth1(Pos, PuzzleF, H2), %pos number (2)
	Pos2 is Pos + N - 1,
	nth1(Pos2, PuzzleF, H3),
	Pos3 is Pos + N,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 2).


% pos-n | pos-n+1 
% number  | pos+1
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	AuxN is (N * N) - N + 1,
	Pos == AuxN, !,
	Pos1 is Pos - N,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N + 1,
	nth1(Pos2, PuzzleF, H2),
	nth1(Pos, PuzzleF, H3), %pos number (3)
	Pos3 is Pos + 1,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 3).


% pos-n-1| pos-n
% pos-1  | number
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	AuxN is N * N,
	Pos == AuxN, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2),
	Pos3 is Pos - 1,
	nth1(Pos3, PuzzleF, H3),
	nth1(Pos, PuzzleF, H4), %pos number (4)
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 4).


getSubList(Pos, PuzzleF, [Head], N, Aux):-
	Aux == 9,!,
	nth1(Pos, PuzzleF, Head).

getSubList(Pos, PuzzleF, [Head | Tail], N, Aux):-
	(Aux == 3 ; Aux == 6),!,
	nth1(Pos, PuzzleF, Head),
	NewPos is Pos + N - 2,
	Aux1 is Aux + 1,
	getSubList(NewPos, PuzzleF, Tail, N, Aux1).

getSubList(Pos, PuzzleF, [Head|Tail], N, Aux):-
	nth1(Pos, PuzzleF, Head),
	Aux1 is Aux + 1,
	NewPos is  Pos + 1,
	getSubList(NewPos, PuzzleF, Tail, N, Aux1).

cycle([], _, _).
cycle([Num-Pos | T], PuzzleF, N):-
	getSubListLastRow([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListLastCol([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListFirstRow([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListCorners([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListFirstCol([Num-Pos], PuzzleF, List, N),
	paintWay(List, Num, 3),
	cycle(T, PuzzleF,N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListLastCol([Num-Pos], PuzzleF, List, N),
	paintWay(List, Num, 4),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	LeftTopPos is Pos - N - 1,
	getSubList(LeftTopPos, PuzzleF, List, N, 1),
	paintWay(List, Num, 5),
	cycle(T, PuzzleF, N).

/**
	Corner Top Left
*/
getClosure(PuzzleF, Pos, N):-
	Pos == 1,!,
	RigthPos is Pos + 1,
	nth1(RightPos, PuzzleF, Right),
	UnderPos is N + 1,
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Right, Under], [1-2,0-0]).
/**
	Corner Top Right
*/
getClosure(PuzzleF, Pos, N):-
	Pos == N,!,
	LeftPos is Pos - 1,
	nth1(LeftPos, PuzzleF, Left),
	UnderPos is Pos + N,
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Left | [Under]], [1-2,0-0]).
/**
	Corner Bottom Left
*/
getClosure(PuzzleF, Pos, N):-
	Pos == N*N - N + 1,!,
	RigthPos is Pos + 1,
	nth1(RightPos, PuzzleF, Right),
	AbovePos is Pos - N,
	nth1(AbovePos, PuzzleF, Above),
	global_cardinality([Right | [Above]], [1-2,0-0]).
/**
	Corner Bottom Right
*/
getClosure(PuzzleF, Pos, N):-
	Pos == N*N,!,
	LeftPos is Pos - 1,
	nth1(LeftPos, PuzzleF, Left),
	AbovePos is Pos - N,
	nth1(AbovePos, PuzzleF, Above),
	global_cardinality([Left | [Above]], [1-2,0-0]).
/**
	First Row
*/
getClosure(PuzzleF, Pos, N):-
	Pos > 1, Pos < N,!,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Left | [Right | [Under]]], [1-2, 0-1]).
/**
	Last Row
*/
getClosure(PuzzleF, Pos, N):-
	Pos > N*N - N, Pos < N*N,!,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	AbovePos is Pos - N,
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(AbovePos, PuzzleF, Above),
	global_cardinality([Left | [Right | [Above]]], [1-2, 0-1]).
/**
	First Col
*/
getClosure(PuzzleF, Pos, N):-
	Aux is mod(Pos, N),
	Aux == 1, !,	
	AbovePos is Pos - N,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Above | [Right | [Under]]], [1-2, 0-1]).
/**
	Last Col
*/
getClosure(PuzzleF, Pos, N):-
	Aux is mod(Pos, N),
	Aux == 0, !,	
	AbovePos is Pos - N,
	LeftPos is Pos - 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(LeftPos, PuzzleF, Left),
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Above | [Left | [Under]]], [1-2, 0-1]).
/**
	Middle
*/	
getClosure(PuzzleF, Pos, N):-
	AbovePos is Pos - N,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	global_cardinality([Above | [Left | [Right |[Under]]]], [1-2, 0-2]).
	
restrictionClosure(_, L, _, L).
restrictionClosure(PuzzleF, Pos, N, L):-
	element(Pos, PuzzleF, Cell),
	Cell #= 1,!,
	write(Pos), write(' '), write(Cell), nl,
	getClosure(PuzzleF, Pos, N),
	NewPos is Pos + 1,
	restrictionClosure(PuzzleF, NewPos, N, L).
restrictionClosure(PuzzleF, Pos, N, L):-
	NewPos is Pos + 1,
	restrictionClosure(PuzzleF, NewPos, N, L).

teste(PuzzleF):-
	puzzle6(Puzzle),
	numbers6(Numbers),
	N is 6, %side of matrix
	L is N*N,
	length(PuzzleF, L),
	domain(PuzzleF, 0, 1),
	cycle(Numbers, PuzzleF, N),
	restrictionClosure(PuzzleF, 1, N, L),
	labeling([], PuzzleF),
	write(PuzzleF), nl,
	printPuzzle(PuzzleF, Puzzle, N, 1).
