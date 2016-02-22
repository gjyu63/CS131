% Test results
% kenken
% 4 x 4 is less than 1ms
% 6 x 6 is less than 1ms
%
% plain_kenken
% 4 x 4 is 1ms
% 6 x 6 did not complete in an hour
%
% no-op kenken API
%
% We can maintain many of the parameters in the specification for this
% assignment: N, we need the puzzle size, C, although we obviously
% need just the list of cages not the operators included. As far
% as the implementation would go, we know that if a constraint had
% only two items, we'd have division and subtraction, otherwise
% we'd require addition and multiplication. Finally, I'm not sure
% how we could implement non-standard predicates, but we would need
% a list of the standard operators that the puzzle takes, e.g.,
% addition, multiplication, subtraction and addition.
%
% puzzle from first example in the linked page for noop kenken in specs
%
% noop_kenken(5, O
%   [(10, [1-1, 1-2])],
%   [(10, [1-3, 1-4, 1-5, 1-6])],
%   [(10, [2-1, 3-1, 3-2])],
%   [(10, [2-2, 2-3, 2-4])],
%   [(10, [3-3, 3-4, 3-5])],
%   [(10, [4-1, 4-2, 5-1])],
%   [(10, [4-1, 5-2, 5-3, 5-4])],
%   [(10, [4-4, 4-5, 5-5])], T).


% makes sure that we are using GProlog's FDC
in_domain(N, L) :-
    fd_domain(L, 1, N).

% proving constraints
addition(_, [], 0).
addition(X, [I-J|T], Y) :-
    ij(X, I, J, E),
    addition(X, T, Z),
    Y #= Z + E.

subtraction(X, I1-J1, I2-J2, Y) :-
    ij(X, I1, J1, X1),
    ij(X, I2, J2, X2),
    Y #= X1 - X2.

multiplication(_, [], 1).
multiplication(X, [I-J|T], Y) :-
    ij(X, I, J, E),
    multiplication(X, T, Z),
    Y #= Z * E.

division(X, I1-J1, I2-J2, Y) :-
    ij(X, I1, J1, X1),
    ij(X, I2, J2, X2),
    Y #= X1 / X2.

% retrieve the i-th row, j-th column
ij(X, I, J, Y) :-
    I1 is I - 1,
    J1 is J - 1,
    n(X, I1, X1),
    n(X1, J1, Y).

% gets a column
column([], _, []).
column([HD | TL], I, X) :-
    n(HD, I, E),
    column(TL, I, Y),
    append([E], Y, X).

% get n-th element from a list
n([], _, []).
n([HD | _], 0, HD).
n([_ | TL], I, X) :-
    I \= 0, N is I - 1, n(TL, N, X).

% checks lengths
lengths_match([HD | TL], N) :-
    length(HD, N), lengths_match(TL, N).
lengths_match([HD], N) :-
    length(HD, N).

unique_column(_, 0) :- !.
unique_column(X, N) :-
    N1 is N - 1,
    column(X, N1, T),
    fd_all_different(T),
    unique_column(X, N1).

unique_row([]).
unique_row([HD | TL]) :-
    fd_all_different(HD),
    unique_row(TL).

% prove the kenken constraints
constraint(X, +(Y, [HD | TL])) :-
    addition(X, [HD | TL], Y).
constraint(X, -(Y, A, B)) :-
    subtraction(X, A, B, Y);
    subtraction(X, B, A, Y).

constraint(X, *(Y, [HD | TL])) :-
    multiplication(X, [HD | TL], Y).
constraint(X, /(Y, A, B)) :-
    division(X, A, B, Y);
    division(X, B, A, Y).

constraints(_, []).
constraints(X, [HD | TL]) :-
    constraint(X, HD), constraints(X, TL).

% prove the numbers to solve the kenken puzzle
kenken(N, C, T) :-
    length(T, N),
    lengths_match(T, N),
    maplist(in_domain(N), T),
    constraints(T, C),
    unique_column(T, N),
    unique_row(T), 
    maplist(fd_labeling, T).

get_domain_list(0, _) :- !.
get_domain_list(N, R) :-
    length(R, N),
    N1 is N - 1,
    append(R1, [N], R),
    get_domain_list(N1, R1).

plain_domain([], _) :- !.
plain_domain([HD | TL], N) :-
    get_domain_list(N, P),
    permutation(P, HD),
    plain_domain(TL, N).

plain_unique_column(_, 0, _) :- !.
plain_unique_column(X, N, R) :-
    N1 is N - 1,
    column(X, N1, T),
    permutation(T, R),
    plain_unique_column(X, N1, R).

plain_kenken(N, C, T) :-
    length(T, N),
    lengths_match(T, N),
    get_domain_list(N, R),
    plain_domain(T, N),
    constraints(T, C),
    plain_unique_column(T, N, R).

kenken_testcase(
	6,
	[
	    +(11, [1-1, 2-1]),
	    /(2, 1-2, 1-3),
	    *(20, [1-4, 2-4]),
	    *(6, [1-5, 1-6, 2-6, 3-6]),
	    -(3, 2-2, 2-3),
	    /(3, 2-5, 3-5),
	    *(240, [3-1, 3-2, 4-1, 4-2]),
	    *(6, [3-3, 3-4]),
	    *(6, [4-3, 5-3]),
	    +(7, [4-4, 5-4, 5-5]),
	    *(30, [4-5, 4-6]),
	    *(6, [5-1, 5-2]),
	    +(9, [5-6, 6-6]),
	    +(8, [6-1, 6-2, 6-3]),
	    /(2, 6-4, 6-5)
	]
    ).

kenken_testcase0(
	4,
	[
	    +(3, [1-1,1-2]),
	    *(4, [3-2,3-3,2-3]),
	    /(2, 4-3, 4-4),
	    -(2, 4-3, 4-4)

	]
    ).
