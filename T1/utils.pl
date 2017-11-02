:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(system)).

:-include('print.pl').
:-include('humanInput.pl').
:-include('computerInput.pl').
:-include('board.pl').
:-include('checkGameStatus.pl').

% Clone a list 
copyList(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

clearScreen :- write('\33\[2J').