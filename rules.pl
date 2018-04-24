/* this is the basic rules and  the syntactic categories for the small language Mini.
The evaluation rules are described below:

bigstep_e: computes integer expressions for a given substitution and set of functions
           Profile: env(PROG,S), e -> N

bigstep_i: compute an instruction
           Profile: PROG, i, S -> S

bigstep_p: compute a sequence of instructions
           Profile: PROG, p, S -> S

*/



/*

semantics of expressions
========================

syntax of expressions:

OPS: _ + _, _ * _, _ - _, _ / _
FCT: name( _), name( _, _)
VAR: v 

exemple: 

bigstep_e(ENV,E,N)

*/

bigstep_e(ENV,E + EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),NS is N + NN.
bigstep_e(ENV,E * EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),NS is N * NN.
bigstep_e(ENV,E / EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),NS is N / NN.
bigstep_e(ENV,E - EE,NS):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),NS is N - NN.

bigstep_e(ENV,N,N):-integer(N).

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
subsextract([(V,N)|L],V,N).
subsextract([(V,NN)|L],VV,N):-V \== VV, subsextract(L,VV,N).

% add a value to a variable in the substitution (expected properties such as unicity and non ordering  are guaranteed)
subsadd([],V,N,[(V,N)]).
subsadd([(V,NN)|L],V,N,[(V,N)|L]).
subsadd([(V,NN)|L],VV,N,[(V,NN)|LL]):-V \== VV, subsadd(L,VV,N,LL).


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
                       bigstep_c(env(PROG,S),COND),
                       bigstep_p(PROG,P,S,SS). 

bigstep_i(PROG,if_then_else(COND,P,PP),S,SS):-
                       not(bigstep_c(env(PROG,S),COND)),
                       bigstep_p(PROG,PP,S,SS).

bigstep_i(PROG,while(COND,P),S,SSS):-
                       bigstep_c(env(PROG,S),COND),
                       bigstep_p(PROG,P,S,SS),
                       bigstep_p(PROG,while(COND,P),SS,SSS). 

bigstep_i(PROG,while(COND,P),S,S):-
                       not(bigstep_c(env(PROG,S),COND)).

bigstep_i(PROG,(V:=E),S,SS):-
                       bigstep_e(env(PROG,S),E,N),subsadd(S,V,N,SS).



/* evaluation of conditions */

bigstep_c(ENV,E < EE):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),N < NN.
bigstep_c(ENV,E > EE):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),N > NN.
bigstep_c(ENV,E = EE):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),N = NN.
bigstep_c(ENV,E \== EE):- bigstep_e(ENV,E,N),bigstep_e(ENV,EE,NN),N \== NN.



/* encoded examples for simplicity*/

deffun(sqrt,func(sqrt(x),y:=1;while(sq(y)<x,y:=y+1),y)).
deffun(sq,func(sq(x),y:=1,x*x)).
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


consult('InterpretProlog/rules.pl').
*/


 
