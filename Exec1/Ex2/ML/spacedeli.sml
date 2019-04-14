(***************************************************************************
  Course    : Programming Languages 1 - Assignment 1 - Exercise 2
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : May 14, 2017
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

fun fixer (i,j,pizza,goeswhere,tab,N,M,changewhat) =
		let
			val goeswhere = if (i-1>=0 andalso (Array2.sub(tab,i-1,j) <> "X" andalso Array2.sub(changewhat,i-1,j) = "A")) then (Array2.update(changewhat,i-1,j,"U"); ((i-1,j,pizza)::goeswhere)) else goeswhere
			val goeswhere = if (i+1<N  andalso (Array2.sub(tab,i+1,j) <> "X" andalso Array2.sub(changewhat,i+1,j) = "A")) then (Array2.update(changewhat,i+1,j,"D"); ((i+1,j,pizza)::goeswhere)) else goeswhere
			val goeswhere = if (j-1>=0 andalso (Array2.sub(tab,i,j-1) <> "X" andalso Array2.sub(changewhat,i,j-1) = "A")) then (Array2.update(changewhat,i,j-1,"L"); ((i,j-1,pizza)::goeswhere)) else goeswhere
			val goeswhere = if (j+1<M  andalso (Array2.sub(tab,i,j+1) <> "X" andalso Array2.sub(changewhat,i,j+1) = "A")) then (Array2.update(changewhat,i,j+1,"R"); ((i,j+1,pizza)::goeswhere)) else goeswhere
		in
			(changewhat,goeswhere)
		end
		
fun checkW (i,j,pizza,plus1,prevwith,prevwithout) =
		let
			val plus1 = if (pizza = 0 andalso Array2.sub(prevwith,i,j) = "A") then (Array2.update(prevwith,i,j,"W"); ((i,j,1)::plus1))
						else if (pizza = 1 andalso Array2.sub(prevwithout,i,j) = "A") then (Array2.update(prevwithout,i,j,"W"); ((i,j,0)::plus1))
						else plus1
		in
			(prevwith,prevwithout,plus1)
		end
		
fun checkcurrent (tab,N,M,prevwith,prevwithout,[],plus1,plus2,_) = (prevwith,prevwithout,~1,~1,plus1,plus2)
|	checkcurrent (tab,N,M,prevwith,prevwithout,(i,j,pizza)::tl,plus1,plus2,1) = (prevwith,prevwithout,i,j,[],[])
|	checkcurrent (tab,N,M,prevwith,prevwithout,(i,j,pizza)::tl,plus1,plus2,0) =
		if (Array2.sub(tab,i,j) = "E" andalso pizza = 1) then checkcurrent(tab,N,M,prevwith,prevwithout,(i,j,pizza)::tl,[],[],1)
		else (
			let
				val (prevwith,prevwithout,plus1) = if (Array2.sub(tab,i,j) = "W") then checkW(i,j,pizza,plus1,prevwith,prevwithout) else (prevwith,prevwithout,plus1)  (* elegxei gia W *)
				val (prevwith,plus2) = if (pizza = 1) then fixer(i,j,pizza,plus2,tab,N,M,prevwith) else (prevwith,plus2)
				val (prevwithout,plus1) = if (pizza = 1) then (prevwithout,plus1) else fixer(i,j,pizza,plus1,tab,N,M,prevwithout)
			in
				checkcurrent (tab,N,M,prevwith,prevwithout,tl,plus1,plus2,0)
			end)
			
fun checkiffound(tab,N,M, prevwith,prevwithout,~1,~1,current,plus1,plus2,cost) =
		let
			val (prevwith,prevwithout,i,j,plus1,plus2) = checkcurrent(tab,N,M,prevwith,prevwithout,current,plus1,plus2,0)
		in
			checkiffound(tab,N,M,prevwith,prevwithout,i,j,plus1,plus2,[],cost+1)
		end
|	checkiffound(tab,N,M,prevwith,prevwithout, posi,posj,current,plus1,plus2,cost) = (prevwith,prevwithout,cost,posi,posj)

fun	printing (prevwith,prevwithout,i,j,pizza,mystring) =
		let
			val str = if (pizza = 1) then Array2.sub(prevwith,i,j) else Array2.sub(prevwithout,i,j)
			val (k,l,m) = case (str) of
							"W" => if (pizza = 1) then (i,j,0) else (i,j,1) |
							"U" => (i+1,j,pizza) |
							"D" => (i-1,j,pizza) |
							"L" => (i,j+1,pizza) |
							"R" => (i,j-1,pizza) |
							 _  => (0,0,2) ;
							  
		in
		 	if (str <> "n") then printing(prevwith,prevwithout,k,l,m,str^mystring) else mystring
		end




fun almost (tab,starti,startj) =
		let
			val N = Array2.nRows tab
			val M = Array2.nCols tab
			fun init (N,M,Si,Sj) =
					let
						val w = Array2.array(N,M,"A")
						val wnot = Array2.array(N,M,"A")
					in
						(Array2.update(w,Si,Sj,"n"); (w,wnot))
					end
			val (prevwith, prevwithout) = init (N,M,starti,startj)
			val (prevwith,prevwithout,cost,posi,posj) = checkiffound(tab,N,M,prevwith,prevwithout,~1,~1,(starti,startj,1)::[],[],[],0)
			val str = printing(prevwith,prevwithout,posi,posj,1,"")
		in
			(cost-1,str)
		end

(* The format *)

fun spacedeli fileName = almost (parse fileName)
