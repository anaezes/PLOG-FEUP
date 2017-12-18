printMenu :- nl, nl,
	write('     *************** BOSNIAN ROAD PUZZLE ***************'), nl,
	write('     ***************************************************'), nl, nl,
	write('     Press the option:'), nl,
	write('     1. Solve puzzle'), nl,
	write('     2. Rules'), nl,
	write('     3. Quit'), nl, nl.

/**
* Ask the user what is the menu option.
**/
askMenuInput(Options, Option):-
	nl, read(Option),
	member(Option, Options).

askPuzzle(Options, Option):-
	nl, write('     Choose a puzzle side size (from 4x4 to 12x12)'),
	read(Option),
	member(Option, Options).

askAux(Options, Option):-
	nl, write('Press 1 to continue... '),
	read(Option),
	member(Option, Options).

rulesPuzzle :- 
	write('     BOSNIAN ROAD RULES:'), nl, nl, nl,
	write('     Draw a continuous snake-like loop of one-cell width, that does not touch itself, '), nl,
	write('     even diagonally. It does not go through clue cells. The clues indicate how many '),nl,
	write('     of the 8 (or less for edges and corners) cells around the clue cell the loop passes'), nl,
	write('     through. This does not necessarily imply that all these cells have to be passed'), nl,
	write('     through at once, they can be broken up too (similar to Minesweeper-like clues)'), nl, nl, nl.

% Options to menu
options([1, 2, 3]).
auxOptions([1]).
puzzleOptions([4,5,6,7,8,9,10,11,12]).

bosnianRoad :-
	clearScreen,
	printMenu,
	options(Options),
	askMenuInput(Options, Option),
	init(Option).

init(Option):-
	Option == 1, !,
	write('Option 1'), nl,
	clearScreen,
	puzzleOptions(Options),
	askPuzzle(Options, PuzzleOption),
	puzzle(PuzzleOption),
	auxOptions(Aux),
	askAux(Aux, _),
	bosnianRoad.

init(Option):-
	Option == 2, !,
	write('Option 2'), nl,
	clearScreen,
	rulesPuzzle,
	auxOptions(Aux),
	askAux(Aux, _),
	bosnianRoad.

init(_Option).