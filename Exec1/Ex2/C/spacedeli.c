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

struct lista
{
	int posi,posj;
	int pizza;
	struct lista* next;
};

char prev[1000][1000][2];
char tab[1000][1000];

struct lista* fixnodes(struct lista* current,struct lista* where,int N,int M);	//NxM pinakas

void printing (int i, int j, int flag);

int main(int argc, char *argv[]){
	int N=0,M=0;//N grammes M sthles
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
			tab[i][j] = c;
			prev[i][j][0]='A';
			prev[i][j][1]='A';
			if (c=='S') {
				current = (struct lista*) malloc(sizeof(struct lista));
				if (current==NULL) { printf("ERROR\n"); exit(0); }
				current->next = NULL;
				current->posi = i;
				current->posj = j;
				current->pizza = 1;
				prev[i][j][1] = 'n';
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
	int cost=0,rev;//rev gia to antistrofo pizza sto w
	int flag = 0;//1 an vrethei
	struct lista *temp = NULL, *plus1 = NULL, *plus2 = NULL;
	while (flag==0){
		while (current!=NULL){
			if (tab[current->posi][current->posj]=='E' && current->pizza){
				flag = 1;
				break;
			}
			if (tab[current->posi][current->posj]=='W'){
				if (current->pizza) rev = 0;
				else rev = 1;
				if (prev[current->posi][current->posj][rev]=='A'){
					temp = (struct lista*) malloc(sizeof(struct lista));
					if (temp==NULL) { printf("ERROR\n"); exit(0); }
					temp->next = plus1;
					temp->posi = current->posi;
					temp->posj = current->posj;
					temp->pizza = rev;
					prev[temp->posi][temp->posj][rev]='W';
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
	/*char c2;
	while (1){
		c2 = prev[i][j][flag];
		printf("%c",c2);
		if (c2=='W') {
			if (flag==1) flag = 0;
			else flag = 1;
		}
		else if (c2=='U') i++;
		else if (c2=='D') i--;
		else if (c2=='L') j++;
		else if (c2=='R') j--;
		else if (c2=='n') break;
	}*/
	printf("\n");
	return 0;
}

struct lista* fixnodes(struct lista* current,struct lista* where,int N,int M){	//NxM pinakas
	int newi,newj;
	struct lista* temp = NULL;
	//kinhsh U
	newi = current->posi - 1;
	newj = current->posj;
	if (newi>=0 && (tab[newi][newj]!='X' && prev[newi][newj][current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi][newj][current->pizza]='U';
		where = temp;
		temp = NULL;
	}
	//kinhsh D
	newi = current->posi + 1;
	newj = current->posj;
	if (newi<N && (tab[newi][newj]!='X' && prev[newi][newj][current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi][newj][current->pizza]='D';
		where = temp;
		temp = NULL;
	}
	//kinhsh L
	newi = current->posi;
	newj = current->posj - 1;
	if(newj>=0 && (tab[newi][newj]!='X' && prev[newi][newj][current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi][newj][current->pizza]='L';
		where = temp;
		temp = NULL;
	}
	//kinhsh R
	newi = current->posi;
	newj = current->posj + 1;
	if(newj<M && (tab[newi][newj]!='X' && prev[newi][newj][current->pizza]=='A') ){
		temp = (struct lista*) malloc(sizeof(struct lista));
		if (temp==NULL){ printf("ERROR\n"); exit(0); }
		temp->next = where;
		temp->posi = newi;
		temp->posj = newj;
		temp->pizza = current->pizza;
		prev[newi][newj][current->pizza]='R';
		where = temp;
		temp = NULL;
	}
	return where;
}

void printing(int i, int j, int flag){
	char c = prev[i][j][flag];
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
