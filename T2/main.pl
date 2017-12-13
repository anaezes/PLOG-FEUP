:-use_module(library(clpfd)).

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


paintWay(List, Num):-
	global_cardinality(List, [1-Num]),
	element(4, List, 1).


cycle([], []).
cycle([H | T], PuzzleF):-
	H \== nil.
	/*paintWay(PuzzleF, H).*/
cycle([H | T], [HF | TF]):-
	HF in 0..1,
	cycle(T, TF).

teste :- puzzle6(Puzzle), printPuzzle(Puzzle).

teste1 :- 
	puzzle3(Puzzle),
	length(PuzzleF, 9),
	domain(PuzzleF, 0, 1),
	cycle(Puzzle, PuzzleF),
	labeling([], PuzzleF),
	printPuzzle(PuzzleF).
