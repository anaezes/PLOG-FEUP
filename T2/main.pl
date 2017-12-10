:- use_module(library(clpfd)).

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
	printRow(H), nl,
	printPuzzle(T).

teste :- puzzle6(Puzzle), printPuzzle(Puzzle).