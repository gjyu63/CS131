
sorted([]) :- true.
sorted([_]) :- true.

sorted([X,Y|L]) :- X=<Y, sorted([Y|L]).

perm([],[]).
perm([X],[X]).
perm([X|L0], S) :-
    perm(L0,AB),
    append(A,B,AB),
    append(A,[X|B],S).

append([],L,L).
apppend([X|L],M[X|append(L,M,LM)).

append(A,B,C).
A = [], B = C.
A = [_27], C = [_27 | B ].
A = [_27, _39], C = [_27,_39 | B].

append(A,B,C), fail.

fail, append(A,B,C).
