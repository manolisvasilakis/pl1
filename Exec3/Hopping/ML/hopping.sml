(***************************************************************************
  Course    : Programming Languages 1 - Assignment 3 - Exercise 3
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : July 23, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************)

fun next_int input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

fun read_and_order_moves (0, acc, _) = ListMergeSort.sort (op >) acc
|	read_and_order_moves (i, acc, input) =
	let
		val d = next_int input
	in
		read_and_order_moves (i-1, d::acc, input)
	end

fun broken (Stairs, _, 0) = Stairs
|	broken (Stairs, Stream, i) =
	let
		val d = next_int Stream
	in
		broken (Vector.update (Stairs, d-1, ~1), Stream, i-1)
	end

fun fixway (_, Final, nil, _) = Final
|	fixway (Goal, Way, h::t, position) =
		if (position + h > Goal) then Way
		else if (Vector.sub (Way, position + h) = ~1) then fixway (Goal, Way, t, position)
		else(
				let
					val temp = ((Vector.sub (Way, position + h)) + (Vector.sub (Way, position))) mod 1000000009
				in
					fixway (Goal, Vector.update (Way, position + h, temp), t, position)
				end
			)


fun count_ways (Goal, Way, Moves, position) =
	if (Goal = position) then (Vector.sub (Way, Goal))
	else if (Vector.sub (Way, position) < 1) then count_ways (Goal, Way, Moves, position + 1)
	else(
			let
				val NewWay = fixway (Goal, Way, Moves, position)
			in
				count_ways (Goal, NewWay, Moves, position + 1)
			end
		)

fun hopping file =
	let
		val stream = TextIO.openIn file
		val N = next_int stream 																(* Number of stairs *)
		val K = next_int stream 																(* Number of available moves *)
		val B = next_int stream 																(* Number of broken stairs *)
		val Moves = read_and_order_moves (K, nil, stream)										(* List of available moves ordered *)
		val Stairs = broken (Vector.tabulate (N, fn i => if i=0 then 1 else 0), stream, B)	(* ~1 if broken, 0 if ok *)
	in
		if ((Vector.sub (Stairs, 0) = ~1) orelse (Vector.sub (Stairs, N-1) = ~1)) then 0 else count_ways(N-1, Stairs, Moves, 0)
	end
