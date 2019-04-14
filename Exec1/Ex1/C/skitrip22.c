/***************************************************************************
  Course    : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : May 14, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************/

#include<stdio.h>

int main(int argc, char *argv[]){
	long N;
	FILE *fr;
	fr = fopen (argv[1],"r");
	fscanf(fr,"%ld\n",&N);
	long tab[N];
	long i,j;
	for(i=0;i<N;i++) fscanf(fr,"%ld",&tab[i]);
	fclose(fr);
	//diabasma ok
	long L[N],R[N],distance=0;
	L[0]=0;		//to min apo th thesi 0 mexri th thesi i
	R[N-1]=N-1;	//to max apo th thesi N-1 mexri i
	for(i=1;i<N;i++){
		if(tab[i]<tab[L[i-1]])	L[i]=i;
		else L[i]=L[i-1];
		if(tab[N-1-i]>tab[R[N-1-i+1]]) R[N-1-i]=N-1-i;
		else R[N-1-i]=R[N-1-i+1];
	}
	//eftia3a R,L
	j=1;	//j=0;
	i=0;
	while (j<N && i<N)
	{
		if(j<i) j=i+1;
		while (j<N && tab[L[i]]<=tab[R[j]])	//while (tab[L[i]]<=tab[R[j]] && j<N)
		{
			if(R[j]-L[i]>distance) distance=R[j]-L[i];
			j++;
		}
		i++;
	}
	printf("%ld\n",distance);
	return 0;
}
