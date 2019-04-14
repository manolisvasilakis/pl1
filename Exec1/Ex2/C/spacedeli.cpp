/***************************************************************************
  Course    : Programming Languages 1 - Assignment 1 - Exercise 2
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : May 14, 2017
  Note      : Mention whatever you think should be brought to our attention
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
int size_tab;
int size_prev;
int N=0,M=0;//N grammes M sthles
std::vector<char> tab (size_tab);
std::vector<char> prev (size_prev);


struct lista
{
	int posi,posj;
	int pizza;
	struct lista* next;
};

struct lista* fixnodes(struct lista* current,struct lista* where,int N,int M);	//NxM pinakas

void printing (int i, int j, int flag);

int main(int argc, char *argv[]){
	int i=0,j=0;
	FILE *fr;
	fr = fopen (argv[1],"r");
	char c;
	struct lista* current = NULL;
	c = fgetc(fr);
	while ((int)c != EOF){
		if(c=='\n'){
			i++;
			j=0;
		}
		else{
			tab.push_back(c);
			prev.push_back('A');
			prev.push_back('A');
			if (c=='S') {
				current = (struct lista*) malloc(sizeof(struct lista));
				if (current==NULL) { printf("ERROR\n"); exit(0); }
				current->next = NULL;
				current->posi = i;
				current->posj = j;
				current->pizza = 1;
			}
			if (j>M) M=j;
			j++;
		}
		c = fgetc(fr);
	}
	fclose(fr);
	if (current == NULL) exit(0);
	N = i;
	M++;
	prev[M*N+current->posi*M+current->posj] = 'n';
	int cost=0,rev;//rev gia to antistrofo pizza sto w
	int flag = 0;//1 an vrethei
	struct lista *temp = NULL, *plus1 = NULL, *plus2 = NULL;
	while (flag==0){
		while (current!=NULL){
			if (tab[current->posi*M+current->posj]=='E' && current->pizza){
				flag = 1;
				break;
			}
			if (tab[current->posi*M+current->posj]=='W'){
				if (current->pizza) rev = 0;
				else rev = 1;
				if (prev[current->posi*M + current->posj+M*N*rev]=='A'){
					temp = (struct lista*) malloc(sizeof(struct lista));
					if (temp==NULL) { printf("ERROR\n"); exit(0); }
					temp->next = plus1;
					temp->posi = current->posi;
					temp->posj = current->posj;
					temp->pizza = rev;
					prev[temp->posi*M+temp->posj+M*N*rev]='W';
					plus1 = temp;
					temp = NULL;
				}
			}
			if (current->pizza) plus2 = fixnodes(current, plus2, N, M);
			else plus1 = fixnodes(current, plus1, N, M);
			temp = current->next;
			free(current);
			current = temp;
			temp = NULL;
		}
		if(flag==0){
			cost++;
			current = plus1;
			plus1 = plus2;
			plus2 = NULL;
		}
	}
	printf("%d ",cost);
	i = current->posi;
	j = current->posj;
	//free gia tis listes
	while (current !=NULL){
		temp = current->next;
		free(current);
		current = temp;
	}
	while (plus1 !=NULL){
		temp = plus1->next;
		free(plus1);
		plus1 = temp;
	}
	while (plus2 !=NULL){
		temp = plus2->next;
		free(plus2);
		plus2 = temp;
	}
	//telos ton free
	printing(i,j,flag);
	printf("\n");
	return 0;
}

struct lista* fixnodes(struct lista* current,struct lista* where,int N,int M){	//NxM pinakas
	int newi,newj;
	struct lista* temp = NULL;
	//kinhsh U
	newi = current->posi - 1;
	newj = current->posj;
	if (newi>=0 && (tab[newi*M+newj]!='X' && prev[newi*M+newj+M*N*current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi*M+newj+M*N*current->pizza]='U';
		where = temp;
		temp = NULL;
	}
	//kinhsh D
	newi = current->posi + 1;
	newj = current->posj;
	if (newi<N && (tab[newi*M+newj]!='X' && prev[newi*M+newj+M*N*current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi*M+newj+M*N*current->pizza]='D';
		where = temp;
		temp = NULL;
	}
	//kinhsh L
	newi = current->posi;
	newj = current->posj - 1;
	if(newj>=0 && (tab[newi*M+newj]!='X' && prev[newi*M+newj+M*N*current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi*M+newj+M*N*current->pizza]='L';
		where = temp;
		temp = NULL;
	}
	//kinhsh R
	newi = current->posi;
	newj = current->posj + 1;
	if(newj<M && (tab[newi*M+newj]!='X' && prev[newi*M+newj+M*N*current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi*M+newj+M*N*current->pizza]='R';
		where = temp;
		temp = NULL;
	}
	return where;
}

void printing(int i, int j, int flag){
	char c = prev[i*M+j+M*N*flag];
	if (c=='W') {
		if (flag) flag = 0;
		else flag = 1;
		printing(i,j,flag);
	}
	else if (c=='U') printing(i+1,j,flag);
	else if (c=='D') printing(i-1,j,flag);
	else if (c=='L') printing(i,j+1,flag);
	else if (c=='R') printing(i,j-1,flag);
	else if (c=='n') return;
	printf("%c",c);
	return;
}
