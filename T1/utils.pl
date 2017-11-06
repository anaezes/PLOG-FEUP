:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(system)).

:-include('print.pl').
:-include('humanInput.pl').
:-include('computerInput.pl').
:-include('board.pl').
:-include('checkGameStatus.pl').
:-include('ia.pl').

:-style_check(-discontiguous).

% Dictionary of pieces
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

validSymbol(0, 'V'). % válida
validSymbol(1, 'I'). % inválida
validSymbol([Head | _], Valid):- validSymbol(Head, Valid).

getColorPlayer(1,'WHITE').
getColorPlayer(0,'BLACK').
getTypePlayer(1, ' HUMAN  ').
getTypePlayer(0, 'COMPUTER').

% Clone a list 
copyList(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

clearScreen :- write('\33\[2J').

getValidMoves(Board, ValidMoves) :-
	setof([X,Y], validMove(Board, X, Y), ValidMoves).