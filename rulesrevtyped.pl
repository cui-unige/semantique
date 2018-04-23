/* this is the basic rules and  the syntactic categories for the small language Mini.
The evaluation rules are described below:

bigstep_e: computes integer expressions for a given substitution and set of functions
           Profile: env(PROG,S), e -> N

bigstep_i: compute an instruction
           Profile: PROG, i, S -> S

bigstep_p: compute a sequence of instructions
           Profile: PROG, p, S -> S

*/

:-op(500,xfx,&).
:-op(600,fx,!).

/*

semantics of expressions
========================

syntax of expressions:

OPS: _ + _, _ * _, _ - _, _ / _
FCT: name( _), name( _, _)
VAR: v 

exemple: 

bigstep_e(ENV,E,N)


Numbers will be represented with usual Peano description: 0, s(N), typing is not fully verified and
admitted correct

*/

peanoadd(0:(nat),NN,NN).
peanoadd(s(N):(nat->nat),NN,s(NNN):(nat->nat)):-peanoadd(N,NN,NNN).

peanomul(0:(nat),NN,0:(nat)).
peanomul(s(N):(nat->nat),NN,NNNN):-peanomul(N,NN,NNN),peanoadd(NN,NNN,NNNN).

peanodiv(N,NN,s(NS):(nat->nat)):-peanoGT(N,NN,t),peanosub(N,NN,NNN),peanodiv(NNN,NN,NS).
peanodiv(N,NN,0:(nat)):-peanoLT(N,NN,t).
peanodiv(N,NN,s(0:(nat))):-peanoEQ(N,NN,t).

peanosub(0:(nat),0:(nat),0:(nat)).
peanosub(s(N):(nat->nat),0:(nat),s(N):(nat->nat)).
peanosub(s(N):(nat->nat),s(NN):(nat->nat),NNN):-peanosub(N,NN,NNN).


peanoLT(0:(nat),s(NN):(nat->nat),t:bool).
peanoLT(0:(nat),0:(nat),f:bool).
peanoLT(s(NN):(nat->nat),0:(nat),f:bool).
peanoLT(s(NN):(nat->nat),s(N):(nat->nat),R):-peanoLT(NN,N,R).

peanoGT(N,NN,R):-peanoLT(NN,N,R).

peanoEQ(0:(nat),s(NN):(nat->nat),f:bool).
peanoEQ(0:(nat),0:(nat),t:bool).
peanoEQ(s(NN):(nat->nat),0:(nat),f:bool).
peanoEQ(s(NN):(nat->nat),s(N):(nat->nat),R):-peanoEQ(NN,N,R).

peanoNEQ(N,NN,f:bool):-peanoEQ(N,NN,t:bool).
peanoNEQ(N,NN,t:bool):-peanoEQ(N,NN,f:bool).

isnat(N,N):-var(N),!.
isnat(0,0:nat).
isnat(s(N),s(NN):(nat->nat)):-isnat(N,NN).

tostring(N,N):-var(N),!.
tostring(0:nat,0).
tostring(s(NN):(nat->nat),s(N)):-tostring(NN,N).
tostring(t:bool,t).
tostring(f:bool,f).

% bool type operations

orbool(t:bool,N,t:bool).
orbool(f:bool,N,N).

andbool(t:bool,N,N).
andbool(f:bool,N,f:bool).

notbool(t:bool,f:bool).
notbool(f:bool,t:bool).


type(VAL:(EXP),T):-(var(EXP),T=EXP,!;EXP=..[H|L],(L=[],T=H;L=[P,T])).

checktype(T,TT):-T=TT,!;print('typing error').

bigstep_e(ENV,E,V:(T)):-var(E),!.


bigstep_e(ENV,E + EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat), peanoadd(N,NN,NS), type(NS,TS), checktype(TS,nat).
bigstep_e(ENV,E * EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat), peanomul(N,NN,NS), type(NS,TS), checktype(TS,nat).
bigstep_e(ENV,E / EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat), peanodiv(N,NN,NS), type(NS,TS), checktype(TS,nat).
bigstep_e(ENV,E - EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat), peanosub(N,NN,NS), type(NS,TS), checktype(TS,nat).

bigstep_e(ENV,E < EE,R):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat),peanoLT(N,NN,R), type(R,TR), checktype(TR,bool).
bigstep_e(ENV,E > EE,R):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat),peanoGT(N,NN,R), type(R,TR), checktype(TR,bool).
bigstep_e(ENV,E = EE,R):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat),peanoEQ(N,NN,R), type(R,TR), checktype(TR,bool).
bigstep_e(ENV,E \== EE,R):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),type(N,T),type(NN,TT), checktype(T,nat), checktype(TT,nat), peanoNEQ(N,NN,R), type(R,TR), checktype(TR,bool).


bigstep_e(ENV,(E | EE),NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,bool), checktype(TT,bool), orbool(N,NN,NS), type(NS,TS), checktype(TS,bool).
bigstep_e(ENV,(E & EE),NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN), type(N,T),type(NN,TT), checktype(T,bool), checktype(TT,bool), andbool(N,NN,NS), type(NS,TS), checktype(TS,bool).
bigstep_e(ENV, (!E),NS):- bigstep_e(ENV,E,N), type(N,T), checktype(T,bool),  notbool(N,NN,NS), type(NS,TS), checktype(TS,bool).

bigstep_e(ENV,0,0:(nat)).
bigstep_e(ENV,s(N),s(NN):(nat->nat)):-isnat(N,NN).
bigstep_e(ENV,t,t:(bool)).
bigstep_e(ENV,f,f:(bool)).


bigstep_e(env(PROG,S),V,N):-atom(V),subsextract(S,V,N). % detect variable names as atoms

% functions without parameters are not allowed
% detect function calls as functors

bigstep_e(env(PROG,S),FCTCALL,N):-FCTCALL =..[NAME|PARAM],length(PARAM,M),M>0,
                              findfunction(PROG,NAME,func(NAMEPARAMFORMAL,FBODY,ERETURN)),
                              NAMEPARAMFORMAL =..[NAME|PARAMFORMAL],
                              bigstep_le(env(PROG,S),PARAM,LN),
                              bindparam(LN,PARAMFORMAL,SS),
                              bigstep_p(PROG,FBODY,SS,SSS),
                              bigstep_e(env(PROG,SSS),ERETURN,N).


/* evaluation of list of expressions*/

bigstep_le(env(PROG,S),[],[]).
bigstep_le(env(PROG,S),[HP|LP],[N|LN]):-bigstep_e(env(PROG,S),HP,N),bigstep_le(env(PROG,S),LP,LN).




/* operations on substitutions*/


% find the value assigned to a given variable
/* subsextract([],V,0):- fail */
subsextract([(V:(T),N)|L],V,N).
subsextract([(V:(T),NN)|L],VV,N):-V \== VV, subsextract(L,VV,N).

% add a value to a variable in the substitution (expected properties such as unicity and non ordering  are guaranteed)
% first assignment define the variable type (PERL like semantics?)!!

subsadd([],V,N,[(V:(T),N)]):-type(N,T).
subsadd([(V:(T),NN)|L],V,N,[(V:(T),N)|L]):-type(N,TN),checktype(TN,T).
subsadd([(V:(T),NN)|L],VV,N,[(V:(T),NN)|LL]):-V \== VV, subsadd(L,VV,N,LL).

% print subs
subsprint([]):-nl.
subsprint([(V:(T),NN)|L]):-tostring(NN,SS),print(V),print(':'),print(T), print(' = '), print(SS),nl, subsprint(L).


/* function manipulation*/

/* select a function by its unique name*/

findfunction([func(NAMEPARAMFORMAL,FBODY,ERETURN)|PROG],NAME,func(NAMEPARAMFORMAL,FBODY,ERETURN)):-NAMEPARAMFORMAL =..[NAME|PARAM].

findfunction([func(NAMEPARAMFORMAL,_,_)|PROG],NAME,FCT):- NAMEPARAMFORMAL =..[NAMED|PARAM],NAMED\==NAME,findfunction(PROG,NAME,FCT).



/* assign actual parameters to formal ones and provide a substitution*/

bindparam([],[],[]).
bindparam([HLN|LN],[HPARAM|PARAMFORMAL],SS):-bindparam(LN,PARAMFORMAL,S),subsadd(S,HPARAM,HLN,SS).


/* semantics of programs as list of instructions*/


bigstep_p(PROG,(I;P),S,SSS):-!, % cut for parsing only once single instruction
                       bigstep_i(PROG,I,S,SS),bigstep_p(PROG,P,SS,SSS).
bigstep_p(PROG,I,S,SS):-bigstep_i(PROG,I,S,SS).


/* semantics of the different instructions*/

bigstep_i(PROG,if_then_else(COND,P,PP),S,SS):-
                       bigstep_e(env(PROG,S),COND,t:bool),
                       bigstep_p(PROG,P,S,SS). 

bigstep_i(PROG,if_then_else(COND,P,PP),S,SS):-
                       bigstep_e(env(PROG,S),COND,f:bool),
                       bigstep_p(PROG,PP,S,SS).

bigstep_i(PROG,while(COND,P),S,S):-
                       bigstep_e(env(PROG,S),COND,f:bool).

bigstep_i(PROG,while(COND,P),S,SSS):-
                       bigstep_e(env(PROG,S),COND,t:bool),
                       bigstep_p(PROG,P,S,SS),
                       bigstep_p(PROG,while(COND,P),SS,SSS). 


bigstep_i(PROG,(V:=E),S,SS):-
                       bigstep_e(env(PROG,S),E,N),subsadd(S,V,N,SS).

eval(P):-bigstep_p([],P,[],R),nl,subsprint(R).

/* encoded examples for simplicity*/

deffun(sqrt,func(sqrt(x),y:=s(0);while(sq(y)<x,y:=y+s(0)),y)).
deffun(sq,func(sq(x),y:=s(0),x*x)).
loadfun([],[]).
loadfun([H|L],[HF|TL]):-deffun(H,HF),loadfun(L,TL).


/*
tests

?- bigstep_e(env([],[(x,20),(y,2)]),(1+y*3-4*7+x),N).

?- bigstep_e(env([],[(x,20)]),(1+2*3-4*7+x),N).

?- bigstep_c(env([],[(x,20),(y,2)]),(1+y*3-4*7+x<0)).

Yes
?- bigstep_c(env([],[(x,20),(y,2)]),(1+y*3-4*7+x>0)).

No
?- bigstep_c(env([],[(x,20),(y,2)]),(1+y*3-4*7+x\==0)).

Yes

?- bigstep_i([],(z:=1),[(x,20),(y,2)],S).

S = [ (x, 20), (y, 2), (z, 1)] ;

No

?- bigstep_i([],(z:=1+2*6+x),[(x,20),(y,2)],S).

S = [ (x, 20), (y, 2), (z, 33)] ;

?- bigstep_i([],(x:=1+2*6+x),[(x,20),(y,2)],S).

S = [ (x, 33), (y, 2)] ;

No
?- bigstep_p([],(x:=y+2*6+x;y:=x),[(x,20),(y,2)],S).

S = [ (x, 34), (y, 34)] ;

?- bigstep_p([],(if_then_else( x>0 ,x:=y+2*6+x;y:=x, x:=3)),[(x,20),(y,2)],S).

S = [ (x, 34), (y, 34)] ;

No
?- bigstep_p([],(if_then_else( x<0 ,x:=y+2*6+x;y:=x, x:=3)),[(x,20),(y,2)],S).

S = [ (x, 3), (y, 2)] ;

?- bigstep_p([],(x:=655360;y:=1;while( y*y<x ,y:=y+1)),[],S).

S = [ (x, 655360), (y, 810)] ;

?- bigstep_p([func(sqrt(x),y:=1;while(y*y<x,y:=y+1),y)],x:=sqrt(65536),[],S).

S = [ (x, 256)] ;

No

?- bigstep_p([func(sqrt(x),y:=1;while(y*y<x,y:=y+1),y)],x:=sqrt(36),[],S).

S = [ (x, 6)] ;

No

?- loadfun([sqrt,sq],CXT),bigstep_p(CXT,x:=sqrt(65536),[],R).

CXT = [func(sqrt(x), (y:=1;while(sq(y)<x, y:=y+1)), y), func(sq(x), y:=1, x*x)]
R = [ (x, 256)] ;

No

 loadfun([sqrt,sq],C),bigstep_p(C,x:=sqrt(s(s(s(s(s(s(0)))))))),[],R).


consult('InterpretProlog/rules.pl').
*/


 
