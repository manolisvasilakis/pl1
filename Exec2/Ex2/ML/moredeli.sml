(***************************************************************************
  Course    : Programming Languages 1 - Assignment 2 - Exercise 2
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : June 18, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************)

fun parse file =
		let
			val stream = TextIO.openIn file
			val a = TextIO.inputAll stream
			val initlist = explode a
			fun makelist (l, [],i,j,flag) = (Array2.fromList(List.rev l),i,j)
			|	makelist (l, init,i,j,flag) =
					let
						fun sm (l1, h::tl,j,flag) = if (h = #"\n") then (List.rev l1,tl,j,flag) else (let
							val temp = Char.toString h
							val (j,flag) = if (flag = true orelse h = #"S") then (j,true) else (j+1,false)
						in
							sm(temp::l1,tl,j,flag) end)
						val (l1,init,j,flag) = sm ([],init,j,flag)
						val (i,j) = if (flag = true) then (i,j) else ((i+1),0)
					in
						makelist ((l1::l), init,i,j,flag)
					end
		in
			makelist ([],initlist,0,0,false)
		end

(* The solution *)

fun fixer (i,j,plus1,plus2,plus3,tab,N,M) =
		let
			val plus3 = if (i-1>=0 andalso Array2.sub(tab,i-1,j) <> "X") then ((i-1,j,"U")::plus3) else plus3
			val plus1 = if (i+1<N  andalso Array2.sub(tab,i+1,j) <> "X") then ((i+1,j,"D")::plus1) else plus1
			val plus2 = if (j-1>=0 andalso Array2.sub(tab,i,j-1) <> "X") then ((i,j-1,"L")::plus2) else plus2
			val plus1 = if (j+1<M  andalso Array2.sub(tab,i,j+1) <> "X") then ((i,j+1,"R")::plus1) else plus1
		in
			(plus1,plus2,plus3)
		end

fun checkcurrent (tab,N,M,prev,[],plus1,plus2,plus3) = (prev,~1,~1,plus1,plus2,plus3)
|	checkcurrent (tab,N,M,prev,(i,j,character)::tl,plus1,plus2,plus3) =
		if (Array2.sub(prev,i,j) <> "A") then checkcurrent (tab,N,M,prev,tl,plus1,plus2,plus3)
		else(
			Array2.update(prev,i,j,character);
			if (Array2.sub(tab,i,j) = "E") then (prev,i,j,[],[],[])
			else(
				let
					val (plus1,plus2,plus3) = fixer(i,j,plus1,plus2,plus3,tab,N,M)
				in
					checkcurrent (tab,N,M,prev,tl,plus1,plus2,plus3)
				end))

fun checkiffound(tab,N,M,prev,~1,~1,current,plus1,plus2,plus3,cost) =
		let
			val (prev,i,j,plus1,plus2,plus3) = checkcurrent(tab,N,M,prev,current,plus1,plus2,plus3)
		in
			checkiffound(tab,N,M,prev,i,j,plus1,plus2,plus3,[],cost+1)
		end
|	checkiffound(tab,N,M,prev,posi,posj,current,plus1,plus2,plus3,cost) = (prev,cost,posi,posj)

fun	printing (prev,i,j,mystring) =
		let
			val str = Array2.sub(prev,i,j)
			val (k,l) = case (str) of
							"U" => (i+1,j) |
							"D" => (i-1,j) |
							"L" => (i,j+1) |
							"R" => (i,j-1) |
							 _  => (i,j) ;
							  
		in
		 	if (str <> "n") then printing(prev,k,l,str^mystring) else mystring
		end

fun almost (tab,starti,startj) =
		let
			val N = Array2.nRows tab
			val M = Array2.nCols tab
			val prev = Array2.array(N,M,"A")
			val (prev,cost,posi,posj) = checkiffound(tab,N,M,prev,~1,~1,(starti,startj,"n")::[],[],[],[],0)
			val str = printing(prev,posi,posj,"")
		in
			(cost-1,str)
		end

(* The format *)

fun moredeli fileName = almost (parse fileName)
