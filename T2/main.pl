:-use_module(library(clpfd)).
:-use_module(library(lists)).

:-include('puzzles.pl').


printRow([]) :- write('|').
printRow([H|T]) :-
	H == nil, !,
	write('| '),
	printRow(T).

printRow([H|T]) :-
	write('|'),
	write(H),
	write(''),
	printRow(T).

printPuzzle([]).
printPuzzle([H|T]) :- 
	write(H),
	printPuzzle(T).

paintWay(List, Num, Pos):-
	length(List, L),
	Rest is L - Num,
	global_cardinality(List, [1-Num, 0-Rest]),
	element(Pos, List, 0).

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
	LeftTopPos is Pos - N - 1,
	write('HALO'),nl,
	getSubList(LeftTopPos, PuzzleF, List, N, 1),
	write(List),nl,
	write(PuzzleF),nl,
	paintWay(List, Num, 5),
	cycle(T, PuzzleF, N).

teste(PuzzleF):-
	puzzle4(Puzzle),
	numbers(Numbers),
	length(PuzzleF, 16),
	N is 4, %side of matrix
	domain(PuzzleF, 0, 1),
	cycle(Numbers, PuzzleF, N),
	labeling([], PuzzleF),
	write(PuzzleF).
