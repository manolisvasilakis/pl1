(***************************************************************************
  Course    : Programming Languages 1 - Assignment 2 - Exercise 1
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : June 18, 2017
  Note      : Adjusted from http://www.geeksforgeeks.org/disjoint-set-data-structures-java-implementation/
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************)

(* a function to read an integer from an input stream *)
fun next_int input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

(* a function to find the representative of the set i belongs to *)
fun find (parent, i) =
	if (Array.sub(parent, i) = i) then (i, parent)
	else (
		let
		(* path compression *)
			val result =
				let
					val (a, b) = find (parent, Array.sub (parent, i))
				in
					a
				end
		in
			(Array.update (parent, i, result); (result, parent))
		end
	)

(* a function to union sets *)
fun union (rank, parent, i, j, teams) =
	let
		val (irep, parent) = find (parent, i)
		val (jrep, parent) = find (parent, j)
	in
		if (irep = jrep) then (rank, parent, teams)
		else (
			let
				val irank = Array.sub (rank, i)
				val jrank = Array.sub (rank, j)
			in
				if (irank < jrank) then (Array.update (parent, irep, jrep); (rank, parent, teams - 1))
				else if (irank > jrank) then (Array.update (parent, jrep, irep); (rank, parent, teams - 1))
				else (Array.update (parent, irep, jrep); Array.update (rank, jrep, Array.sub (rank, jrep) + 1); (rank, parent, teams - 1))
			end
		)
	end

fun repetition (rank, parent, stream, teams, 0) = teams
|	repetition (rank, parent, stream, teams, iterations) =
	let
		val i = (next_int stream) - 1	(* -1 epeidh exo pinakes 0-N-1 *)
		val j = (next_int stream) - 1
		val (rank, parent, teams) = union (rank, parent, i, j, teams)
	in
		repetition (rank, parent, stream, teams, iterations - 1)
	end

fun villages file =
	let
	(* open input file *)
		val stream = TextIO.openIn file
	(* Find N, M, K 	number of (villages, existing roads, roads to be made)	*)
		val N = next_int stream
		val M = next_int stream
		val K = next_int stream
	(* make the parent and rank array *)
		val parent = Array.tabulate (N, fn i => i)
		val rank = Array.array (N, 1)
	(* a function to make the teams *)
		val teams = repetition (rank, parent, stream, N, M)
	(* find the final number of teams *)
		val final = teams - K
	in
		if (final < 2) then 1 else final
	end
