read_input(File,NMap,Start,End,M,N):-
	open(File,read,Stream),
	readfile(Stream,[],0,Start,End,NMap,0,M,0,N),!.

readfile(Stream,Map,Counter,Start,End,NMap,Grammh,M,Sthles,N):-
	get_code(Stream,D),
	C is D+1,
	(C=:=11->NCounter is Counter+1,
		NGrammh is Grammh+1,
		N is Sthles,
		readfile(Stream,Map,NCounter,Start,End,NMap,NGrammh,M,0,N),!
	;true),
	(C=:=89->NCounter is Counter+1,
		NSthles is Sthles+1,
		readfile(Stream,Map,NCounter,Start,End,NMap,Grammh,M,NSthles,N),!
	;true),
	(C=:=47->NCounter is Counter+1,
		NSthles is Sthles+1,
		readfile(Stream,[Counter-[4000000,-1,t]|Map],NCounter,Start,End,NMap,Grammh,M,NSthles,N),!		%A=.    
	;true),
	(C=:=84->NCounter is Counter+1,
		Start is Counter,
		NSthles is Sthles+1,
		readfile(Stream,[Counter-[0,-1,t]|Map],NCounter,Start,End,NMap,Grammh,M,NSthles,N),!			%A=S
	;true),
	(C=:=70->NCounter is Counter+1,
		End is Counter,
		NSthles is Sthles+1,
		readfile(Stream,[Counter-[4000000,-1,t]|Map],NCounter,Start,End,NMap,Grammh,M,NSthles,N),!		%A=E
	;true),
	(C=:=0 ->reverse(Map, Rev_Map),
		NMap=Rev_Map,
		M is Grammh
	;true),!.


moveright(Map,NMap,Dist,Komvos,NewHeap,NHeap):-
	NKomvos is Komvos+1,
	(get_assoc(NKomvos,Map,[D,V,A])->N is Dist+1,
					(N<D ->	del_assoc(NKomvos,Map,[D,V,A],Map1),
						put_assoc(NKomvos,Map1,[N,Komvos,r],NMap),
						add_to_heap(NewHeap,N,NKomvos,NHeap)
					;NHeap=NewHeap,
					NMap=Map)
	;NHeap=NewHeap,
	NMap=Map).
	

moveleft(Map,NMap,Dist,Komvos,NewHeap,NHeap):-
	NKomvos is Komvos-1,
	(get_assoc(NKomvos,Map,[D,V,A])->N is Dist+2,
					(N<D ->	del_assoc(NKomvos,Map,[D,V,A],Map1),
						put_assoc(NKomvos,Map1,[N,Komvos,l],NMap),
						add_to_heap(NewHeap,N,NKomvos,NHeap)
					;NHeap=NewHeap,
					NMap=Map)
	;NHeap=NewHeap,
	NMap=Map).


moveup(Map,NMap,Dist,Komvos,NewHeap,NHeap,N):-
	NKomvos is Komvos-N-1,
	(get_assoc(NKomvos,Map,[D,V,A])->ND is Dist+3,
					(ND<D ->del_assoc(NKomvos,Map,[D,V,A],Map1),
						put_assoc(NKomvos,Map1,[ND,Komvos,u],NMap),
						add_to_heap(NewHeap,ND,NKomvos,NHeap)
					;NHeap=NewHeap,
					NMap=Map)
	;NHeap=NewHeap,
	NMap=Map).

movedown(Map,NMap,Dist,Komvos,NewHeap,NHeap,N):-
	NKomvos is Komvos+N+1,
	(get_assoc(NKomvos,Map,[D,V,A])->ND is Dist+1,
					(ND<D ->del_assoc(NKomvos,Map,[D,V,A],Map1),
						put_assoc(NKomvos,Map1,[ND,Komvos,d],NMap),
						add_to_heap(NewHeap,ND,NKomvos,NHeap)
					;NHeap=NewHeap,
					NMap=Map)
	;NHeap=NewHeap,
	NMap=Map).

findSolution(List,Start,Solution,_,Start):-
		Solution=List.

findSolution(List,V,Solution,Map,Start):-
		get_assoc(V,Map,[_,NewV,Prev]),
		findSolution([Prev|List],NewV,Solution,Map,Start).




moredeli(File,Cost,Solution):-
	read_input(File,NMap,Start,End,_,N),
	ord_list_to_assoc(NMap,Map),
	list_to_heap([0-Start],MyHeap),
	solve(Map,MyHeap,1,Cost,Solution,End,Start,N).


solve(Map,_,0,Cost,Solution,End,Start,_):-
	get_assoc(End,Map,[D,V,Prev]),
	Cost is D,
	findSolution([Prev],V,Solution,Map,Start).

solve(Map,Heap,_,Cost,Solution,End,Start,N):-
	get_from_heap(Heap,Dist,Komvos,NewHeap),
	moveright(Map,RMap,Dist,Komvos,NewHeap,RHeap),
	moveleft(RMap,LMap,Dist,Komvos,RHeap,LHeap),
	moveup(LMap,UMap,Dist,Komvos,LHeap,UHeap,N),
	movedown(UMap,NMap,Dist,Komvos,UHeap,NHeap,N),
	heap_size(NHeap,Size),
	solve(NMap,NHeap,Size,Cost,Solution,End,Start,N).




