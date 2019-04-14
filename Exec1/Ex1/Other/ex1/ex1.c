#include<stdio.h>

int main(){
	int N;
	scanf("%d\n",&N);
	int tab[N];	// εχω διαβασει στον πινακα tab N θεσεων
	int i,j;
	for(i=0;i<N;i++) scanf("%d",&tab[i]);
	int begin,end,tempbegin,tempend;//δεικτες των τελικων
	int max,min;//μεσω αυτων κανω τις συγκρισεις
	int flag=0, flag2=0,flag3=0;
	int counter1=0,counter2=0;
	//bool x,y;
	int x,y;
	//θελω μιν των πρωτων και μαξ των τελευταιων αρα
	max = tab[N-1];	end = N-1;
	min = tab[0];	begin = 0;
	for(i=1;i<N;i++){ //εχω ηδη περασει τα ακρα του πινακα
		if(max>min) break;		//if(max>=min) break;
		x = tab[N-1-i+counter1] > max;
		y = tab[i-counter2] < min;
		if(x && (!y)) {
			end = N-1-i+counter1;
			max = tab[end];
			counter2++;
		}
		else if((!x)&&y) {
			begin = i-counter2;
			min = tab[begin];
			counter1++;
		}
		else if(x&&y){
			flag = 1;
			begin = i-counter2;
			min = tab[begin];
			end = N-1-i+counter1;
			max = tab[end];
		}
	}
	if (end<begin) printf("Cannot find suitable pair\n");
	else {
		if(flag==0) printf("Start at peak #%d and finish at peak #%d\n",end+1,begin+1);
		else{
			for(j=0;j<begin;j++){
				if(tab[j]<max){	//if(tab[j]<=max){
					flag2=1;
					tempbegin=j;
					break;
				}
			}
			for(j=N-1;j>end;j--){	
				if(tab[j]>min){	//if(tab[j]>=min){
					flag3=1;
					tempend=j;
					break;
				}
			}
			if(flag2&&(!flag3)) begin=tempbegin;
			else if((!flag2)&&flag3) end=tempend;
			else if(flag2&&flag3){
				if(end-tempbegin > tempend-begin) begin=tempbegin;
				else end=tempend;
			}//else pou tha meinoun stathera
			printf("Start at peak #%d and finish at peak #%d\n",end+1,begin+1);
		}
	}
	return 0;
}
