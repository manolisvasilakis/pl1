/*
 * A predicate that reads the input from File and returns it in
 * the next arguments: N, K, B, Steps and Broken.
 * Example:
 *
 * ?- read_input('h1.txt', N, K, B, Steps, Broken).
 * N = 10,
 * K = 3,
 * B = 4,
 * Steps = [1, 2, 4],
 * Broken = [2, 4, 6, 7].
 */
read_input(File, N, Steps, Broken) :-
	open(File, read, Stream),
	read_line(Stream, [N, _K, _B]),
	read_line(Stream, StepsRandom),
	sort(StepsRandom, StepsSorted),
	fixsteps(StepsSorted, 0, Steps),
	read_line(Stream, BrokenUnsorted),
	sort(BrokenUnsorted, Broken).

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

fixsteps([], _, []).
fixsteps([HR | TR], Prev, [HF | TF]) :-
	HF is HR - Prev,
	fixsteps(TR, HR, TF).
	
% περίπτωση που το 1ο σκαλί σπασμένο
hopping(File, 0) :-
	read_input(File, _N, _Steps, [1 | _T]),
	!.

hopping(File, Answer) :-
	read_input(File, N, Steps, Broken),
	!,
	once(main([1], 1, Steps, Broken, N, PotAnswer)),
	( PotAnswer < 1	-> Answer = 0
	; true			-> Answer = PotAnswer
	).

% h main exei Lista mexri edo, CurrentLength, ......., Teliko mhkos

main([H | _], N, _, _, N, H).	%exo ftasei epithimito mhkos

main(L, Length, Steps, [], N, Answer) :- main(L, Length, Steps, [-2], N, Answer).			%proxeira grammeno, na ftiaxtei

main(L, Length, Steps, [HBr | TBr], N, Answer) :-
	NewLength is Length + 1,
	( NewLength = HBr	-> main([-1 | L], NewLength, Steps, TBr, N, Answer)
	; true				->
		once(getvalue(0, L, Steps, Value)),
		main([Value | L], NewLength, Steps, [HBr | TBr], N, Answer)
	).


getvalue(Final, [], _, Final).
getvalue(Final, _, [], Final).
getvalue(Current, [H | T], [1 | TS], Value) :-
	!,
	( H < 1	-> getvalue(Current, T, TS, Value)
	; true	->
		Sum is (Current + H) mod 1000000009,
		getvalue(Sum, T, TS, Value)
	).
getvalue(Current, [_H | T], [HS | TS], Value) :-
	NewHS is HS - 1,
	getvalue(Current, T, [NewHS | TS], Value).

/*
Πιθανες βελτιωσεις :
	1. Στην main το προχειρο γραμμενα κομματι
*/
