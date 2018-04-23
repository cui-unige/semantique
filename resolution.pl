%------------------------------------------------------------------------
% SolveSLD: implementation of Prolog Strategy in Prolog !!!!
%------------------------------------------------------------------------


solveSLD([]).
solveSLD([H|T]):-axiom(H,RESTE),solveSLD(RESTE),solveSLD(T).


%------------------------------------------------------------------------
% SolveRes: implementation of Logic Programming without Strategy in Prolog !!!!
%------------------------------------------------------------------------

solveRes([]).
solveRes(L):-elem_liste_random(L,H,R),
             bagof(axiom(H,T),H^axiom(H,T),LAXIOMS),
             chooseaxiom(LAXIOMS,H,R).

chooseaxiom([HL|L],H,R):-
             elem_liste_random([HL|L],axiom(HH,RESTE),OTHERS),
             (append(R,RESTE,RR),H=HH,solveRes(RR);
             (OTHERS=[_|_],chooseaxiom(OTHERS,H,R))).


% choisi aleatoirement un element dans une liste
% elem_liste_random(liste, element choisi, liste privee de l'element choisi)
:- mode(elem_liste_random(+,-,-)).
elem_liste_random([E|L], F, NL) :-
	length([E|L], Length), Lengthi is Length + 1,
        random(1,Lengthi, Ranki),(Lengthi = Ranki, Rank = Length,!;Rank = Ranki),  % Hack pour random fragile
        neme_elem(Rank, [E|L], F, NL).

% retourne le neme element d'une liste
:- mode(neme_elem(++,+,-,-)).
neme_elem(1, [E|L], E, L) :- !.
neme_elem(N, [E|L], F, [E|NL]) :-
	M is N-1,
	neme_elem(M, L, F, NL).

axiom(a(X,Y),[b(X),c(Y)]).
axiom(b(1),[]).
axiom(b(2),[]).
axiom(c(3),[]).
axiom(c(4),[]).


% paths in a binary tree

axiom(path(leaf),[]).
axiom(path(l(P)),[path(P)]).
axiom(path(r(P)),[path(P)]).

axiom(length(leaf,0),[]).
axiom(length(l(P),s(R)),[length(P,R)]).
axiom(length(r(P),s(R)),[length(P,R)]).


