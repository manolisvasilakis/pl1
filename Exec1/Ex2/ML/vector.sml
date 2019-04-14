(* prev[i,j,pizza]=prev[pizza*NxM + Mxi + j]*)
(* tab[i,j] = tab[Mxi + j] *)

fun parse file =
		let
			val stream = TextIO.openIn file
			val a = TextIO.inputAll stream
			val initlist = explode a
			fun go ([],tab,N,M,tempm,starti,startj,found) = (Vector.fromList (List.rev tab),N,M,starti,startj)
			|	go (h::tl,tab,N,M,tempm,starti,startj,found) =
					let
						val M = if (tempm>M) then tempm else M
						val (starti,startj) = if (found = false) then (N,tempm) else (starti,startj)
						val found = if (h = #"S") then true else found
						val temp = Char.toString h
						val (N,tempm,tab) = if (h = #"\n") then (N+1,0,tab) else (N,tempm+1,temp::tab)
					in
						go (tl,tab,N,M,tempm,starti,startj,found)
					end
		in
			go(initlist,[],0,0,0,0,0,false)
		end
		
(* The solution *)

fun fixer (i,j,pizza,goeswhere,tab,N,M,prev) =
		let
			val (prev,goeswhere) = if ((i-1)>=0 andalso (Vector.sub(tab,M*(i-1) + j)<>"X" andalso Vector.sub(prev,N*M*pizza + M*(i-1) + j) = "A"))
									then (Vector.update(prev,N*M*pizza + M*(i-1) + j,"U"),(i-1,j,pizza)::goeswhere) else (prev,goeswhere)
			val (prev,goeswhere) = if ((i+1)<N  andalso (Vector.sub(tab,M*(i+1) + j)<>"X" andalso Vector.sub(prev,N*M*pizza + M*(i+1) + j) = "A"))
									then (Vector.update(prev,N*M*pizza + M*(i+1) + j,"D"),(i+1,j,pizza)::goeswhere) else (prev,goeswhere)
			val (prev,goeswhere) = if ((j-1)>=0 andalso (Vector.sub(tab,M*i + (j-1))<>"X" andalso Vector.sub(prev,N*M*pizza + M*i + (j-1)) = "A"))
									then (Vector.update(prev,N*M*pizza + M*i + (j-1),"L"),(i,j-1,pizza)::goeswhere) else (prev,goeswhere)
			val (prev,goeswhere) = if ((j+1)<M  andalso (Vector.sub(tab,M*i + (j+1))<>"X" andalso Vector.sub(prev,N*M*pizza + M*i + (j+1)) = "A"))
									then (Vector.update(prev,N*M*pizza + M*i + (j+1),"R"),(i,j+1,pizza)::goeswhere) else (prev,goeswhere)
		in
			(prev,goeswhere)
		end
		
fun checkW (N,M,i,j,pizza,plus1,prev) =
		let
			val temp = if (pizza = 1) then 0 else 1
			val (prev,plus1) = if (Vector.sub(prev,N*M*temp + M*i + j) = "A") then (Vector.update(prev,N*M*temp + M*i + j,"W"),(i,j,temp)::plus1) else (prev,plus1)
		in
			(prev,plus1)
		end
		
fun checkcurrent (tab,N,M,prev,[],plus1,plus2,_) = (prev,~1,~1,plus1,plus2)
|	checkcurrent (tab,N,M,prev,(i,j,pizza)::tl,plus1,plus2,1) = (prev,i,j,[],[])
|	checkcurrent (tab,N,M,prev,(i,j,pizza)::tl,plus1,plus2,0) =
		if (Vector.sub(tab,i*M + j) = "E" andalso pizza = 1) then checkcurrent(tab,N,M,prev,(i,j,pizza)::tl,[],[],1)
		else (
			let
				val (prev,plus1) = if (Vector.sub(tab,i*M + j) = "W") then checkW(N,M,i,j,pizza,plus1,prev) else (prev,plus1)  (* elegxei gia W *)
				val (prev,plus2) = if (pizza = 1) then fixer(i,j,pizza,plus2,tab,N,M,prev) else (prev,plus2)
				val (prev,plus1) = if (pizza = 1) then (prev,plus1) else fixer(i,j,pizza,plus1,tab,N,M,prev)
			in
				checkcurrent (tab,N,M,prev,tl,plus1,plus2,0)
			end)
			
fun checkiffound(tab,N,M, prev,~1,~1,current,plus1,plus2,cost) =
		let
			val (prev,i,j,plus1,plus2) = checkcurrent(tab,N,M,prev,current,plus1,plus2,0)
		in
			checkiffound(tab,N,M,prev,i,j,plus1,plus2,[],cost+1)
		end
|	checkiffound(tab,N,M,prev,posi,posj,current,plus1,plus2,cost) = (prev,cost,posi,posj)

fun printing (N,M,prev,_,_,2,mystring) = mystring
|	printing (N,M,prev,i,j,pizza,mystring) =
		let
			val str = Vector.sub(prev,N*M*pizza + M*i + j)
			val (k,l,m) = case (str) of
							"W" => if (pizza = 1) then (i,j,0) else (i,j,1) |
							"U" => (i+1,j,pizza) |
							"D" => (i-1,j,pizza) |
							"L" => (i,j+1,pizza) |
							"R" => (i,j-1,pizza) |
							 _  => (0,0,2) ;
							  
		in
		 	printing(N,M,prev,k,l,m,str^mystring) 
		end




fun almost (tab,N,M,starti,startj) =	(* N grammes, M sthles *)
		let
			val prev = Vector.tabulate(2*N*M,fn a => "A")	(* Arxikopoio ton prev *)
			val (prev,cost,posi,posj) = checkiffound(tab,N,M,prev,~1,~1,(starti,startj,1)::[],[],[],0)
			val str = printing(N,M,prev,posi,posj,1,"")
		in
			(cost,str)
		end
		
(* The format *)

fun spacedeli fileName = almost (parse fileName)
