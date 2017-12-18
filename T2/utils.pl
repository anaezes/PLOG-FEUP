:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(statistics)).

:-include('puzzles.pl').
:-include('menu.pl').


/*********************************
****** FUNTIONS TO PRINT  ********
**********************************/


printSolution(PuzzleF, Puzzle, N) :-
    nl, nl,
    write('     :::::::::: SOLUTION ::::::::::'), nl,
    printSpace(10), write('_'), printChar(N,'_'), nl,
    printSpace(10), write('|'),
    printPuzzle(PuzzleF, Puzzle, N, 1), nl,
	printSpace(10), write('-'), printChar(N,'-'), nl.

printInitial(Puzzle, N) :-
	nl, nl, nl,
	write('     ::::: BOSNIAN ROAD PUZZLE :::::'), nl,
	printSpace(10), write('_'), printChar(N,'_'), nl,
	printSpace(10), write('|'),
	printPuzzle(Puzzle, N, 1), nl,
	printSpace(10), write('-'), printChar(N,'-'), nl, nl.

printChar(0, Char).
printChar(Value, Char):-
	write(Char), write(Char),
	NewValue is Value - 1,
	printChar(NewValue, Char).

printSpace(0).
printSpace(Value):-
	write(' '),
	NewValue is Value - 1,
	printSpace(NewValue).

printPuzzle([], _, _).
printPuzzle([H|T], N, Count) :-
	Count > N, !, nl,
	printSpace(10), write('|'),
	printPuzzle([H|T], N, 	1).

printPuzzle([H|T], N, Count) :-
	H \== nil,
	write(H), write('|'),
	NewCount is Count + 1,
	printPuzzle(T, N, NewCount).

printPuzzle([H|T], N, Count) :-
	write(' |'),
	NewCount is Count + 1,
	printPuzzle(T, N, NewCount).


printPuzzle([], [], _, _).
printPuzzle([H|T], [H2|T2], N, 	Count) :-
	Count > N, !, nl,
	printSpace(10), write('|'),
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

clearScreen :- write('\33\[2J').