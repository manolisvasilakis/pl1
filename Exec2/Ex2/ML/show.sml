fun show (a,i,j,N,M,mylist,temp) = 
		if (j = M) then show (a,i+1,0,N,M,(List.rev temp)::mylist,[])
		else if (i = N) then (List.rev mylist)
		else show (a,i,j+1,N,M,mylist,Array2.sub(a,i,j)::temp)
