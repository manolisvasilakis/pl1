/***************************************************************************
  Course    : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : May 14, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************/

#include<stdio.h>
#include<stdlib.h>

struct intlist
{
	long mylong;
	struct intlist* next;
};

int main(int argc, char *argv[]){
	long N;
	FILE *fr;
	fr = fopen (argv[1],"r");
	fscanf(fr,"%ld\n",&N);
	long tab[N];
	struct intlist* L = NULL;	//to min apo th thesi 0 mexri th thesi i
	L = (struct intlist* ) malloc (sizeof(struct intlist));
	if (L==NULL) {printf("ERROR\n"); exit(0);}
	L->mylong = 0;
	L->next = NULL;
	struct intlist* head = L;
	long min;
	fscanf(fr,"%ld",&min);
	tab[0] = min;
	long i;
	for(i=1;i<N;i++) {
		fscanf(fr,"%ld",&tab[i]);
		if (tab[i]<min) {
			min = tab[i];
			L->next = (struct intlist* ) malloc (sizeof(struct intlist));
			if (L->next==NULL) {printf("ERROR\n"); exit(0);}
			L->next->mylong = i;
			L->next->next = NULL;
			L = L->next;
		}
	}
	fclose(fr);
	L = head;
	//diabasma ok, L ok
	long distance=0;
	struct intlist* R = NULL;
	struct intlist* temp = NULL;
	R = (struct intlist* ) malloc (sizeof(struct intlist));
	if (R==NULL) {printf("ERROR\n"); exit(0);}
	R->mylong = N-1;	//to max apo th thesi N-1 mexri i
	R->next = NULL;
	long max = tab[N-1];
	for(i=N-2;i>=0;i--){
		if(tab[i]>max){
			max = tab[i];
			temp = (struct intlist* ) malloc (sizeof(struct intlist));
			if (temp==NULL) {printf("ERROR\n"); exit(0);}
			temp->mylong = i;
			temp->next = R;
			R = temp;
			temp = NULL;
		}
	}
	//eftia3a R,L
	while (L!=NULL && R!=NULL)
	{
		while (R->mylong < L->mylong) {
			temp = R->next;
			free(R);
			R = temp;
		}
		while (R!=NULL && tab[L->mylong]<=tab[R->mylong])
		{
			if(R->mylong - L->mylong>distance) distance = R->mylong - L->mylong;
			temp = R->next;
			free(R);
			R = temp;
		}
		temp = L->next;
		free(L);
		L = temp;
	}
	while (L!=NULL){
		temp = L->next;
		free(L);
		L = temp;
	}
	while (R!=NULL){
		temp = R->next;
		free(R);
		R = temp;
	}
	printf("%ld\n",distance);
	return 0;
}
