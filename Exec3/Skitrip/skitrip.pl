%vrisko th thesi tou min apo aristera pros de3ia
makeL([], _, _, []).
makeL([H | T], Position, Minvalue, Result) :-
	H < Minvalue,
	Nextpos is Position + 1,
	makeL(T, Nextpos, H, Almost),
	Result = [[Position, H] | Almost].

makeL([H | T], Position, Minvalue, Result) :-
	H >= Minvalue,
	Nextpos is Position + 1,
	makeL(T, Nextpos, Minvalue, Result).

buildL([H | T], Result) :-
	makeL(T, 2, H, Almost),
	Result = [[1, H] | Almost].

%gia ton R vrisko apo dejia pros aristera thesi tou max
makeR([], _, _, []).
makeR([H | T], Position, Maxvalue, Result) :-
	H > Maxvalue,
	Prevpos is Position - 1,
	makeR(T, Prevpos, H, Almost),
	Result = [[Position, H] | Almost].

makeR([H | T], Position, Maxvalue, Result) :-
	H =< Maxvalue,
	Prevpos is Position - 1,
	makeR(T, Prevpos, Maxvalue, Result).

buildR([Hrevl | Trevl], Length, Result) :-
	Pos is Length - 1,
	makeR(Trevl, Pos, Hrevl, Almost),
	RevResult = [[Length, Hrevl] | Almost],
	reverse(RevResult, Result).


% an teleiosei mia lista exv brei to max
finddistance([], _, Max, Max).
finddistance(_, [], Max, Max).
finddistance([[Lpos, Lvalue] | LT], [[Rpos, Rvalue] | RT], Max, Final) :-
	(Rpos < Lpos -> finddistance([[Lpos, Lvalue] | LT], RT, Max, Final), !
	;Rvalue < Lvalue -> finddistance(LT, [[Rpos, Rvalue] | RT], Max, Final)
	;Rvalue>= Lvalue ->
		Dist is Rpos - Lpos,
		(Dist > Max ->
			finddistance([[Lpos, Lvalue] | LT], RT, Dist, Final)
		;Dist=< Max ->
			finddistance([[Lpos, Lvalue] | LT], RT, Max, Final)
		)
	).



main([], _, 0).
main(List, Length, Maxdistance) :-
	buildL(List, L),
	reverse(List, Revlist),
	buildR(Revlist, Length, R),
	%			max, final
	finddistance(L, R, 0, Maxdistance).

/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */
read_line(Stream, List) :-
	read_line_to_codes(Stream, Line),
	( Line = [] -> List = []
	; atom_codes(A, Line),
	  atomic_list_concat(As, ' ', A),
	  maplist(atom_number, As, List)
	).

skitrip(File, Answer) :-
	open(File, read, Stream),
    read_line(Stream, [Length]),
    read_line(Stream, List),
    once(main(List, Length, Answer)).
