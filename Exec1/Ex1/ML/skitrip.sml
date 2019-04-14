(***************************************************************************
  Course    : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : May 14, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************)

(* Reading the file *)

fun parse file =
    let
	(* a function to read an integer from an input stream *)
        fun next_int input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	(* open input file and read the integer in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
		val _ = TextIO.inputLine stream
	(* a function to read the integers in the subsequent line *)
        fun scanner 0 acc = acc
          | scanner i acc =
            let
                val d = next_int stream
            in
                scanner (i - 1) (d :: acc)
            end
    in
        (n, rev(scanner n []))
    end

(* The solution *)

fun buildL (h::tl, 0, _) = 0::buildL(tl, 1, h)
|	buildL ([], position, minvalue) = []
|	buildL (h::tl,position, minvalue) =
		if (h<minvalue) then position::buildL(tl, position+1, h)
		else buildL(tl, position+1,minvalue)


fun buildR (h::tl, position, [], _) = buildR (tl, position-1, position::[], h)
|	buildR ([], position, maxlist, maxvalue) = maxlist
|	buildR (h::tl, position, maxlist, maxvalue) =
		if (h>maxvalue) then buildR (tl, position-1, position::maxlist, h)
		else buildR (tl, position-1,maxlist,maxvalue)


fun reverse (h::tl, rev) = reverse (tl, h::rev)
|	reverse ([], rev) = rev


fun finddistance (distance,[],rlist,l1,l2,pos1,pos2) = distance
|	finddistance (distance,llist,[],l1,l2,pos1,pos2) = distance
|	finddistance (distance,lefthead::lefttail,righthead::righttail,lh::ltail,rh::rtail,pos1,pos2) =
		if (pos1<lefthead) then finddistance (distance,lefthead::lefttail,righthead::righttail,ltail,rh::rtail,pos1+1,pos2)
		else if (pos2<righthead) then finddistance (distance,lefthead::lefttail,righthead::righttail,lh::ltail,rtail,pos1,pos2+1)
		else if (pos2<pos1) then finddistance(distance,lefthead::lefttail,righttail,lh::ltail,rh::rtail,pos1,pos2)
		else
			if (rh-lh>=0) then (
						if (righthead-lefthead>distance) then finddistance (righthead-lefthead,lefthead::lefttail,righttail,lh::ltail,rh::rtail,pos1,pos2)
						else finddistance (distance,lefthead::lefttail,righttail,lh::ltail,rh::rtail,pos1,pos2))
			else finddistance (distance,lefttail,righthead::righttail,lh::ltail,rh::rtail,pos1,pos2)


fun teliko (n,l) =
	let
		val revl = reverse (l,[])
		val L = buildL (l,0,123)
		val R = buildR (revl,n-1,[],345)
	in
		finddistance (0,L,R,l,l,0,0)
	end
	
(* Appropriate format *)

fun skitrip fileName = teliko (parse fileName)
