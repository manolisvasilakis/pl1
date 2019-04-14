#include<stdio.h>

int main(){
	int N;
	scanf("%d\n",&N);
	int tab[N];
	int i,j;
	for(i=0;i<N;i++) scanf("%d",&tab[i]);
	// εχω διαβασει στον πινακα tab N θεσεων----------------------------
	int begin,end,tempbegin,tempend;//δεικτες των τελικων
	int max,min;//μεσω αυτων κανω τις συγκρισεις
	int flag=0, flag2=0,flag3=0,movement1=0,movement2=0,maxmovement=0;
	int counter1=0,counter2=0;
	int x,y;
	int result;
	max = tab[N-1];	end = N-1;
	min = tab[0];	begin = 0;
	for(i=1;i<N;i++){
		if(max>=min) break;		//if(max>=min) break;
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
		else {	//else if (!x&&!y) {
			for(j=N-1;j>N-1-i+counter1;j--){ // εδω
				if(tab[j]>=tab[N-1-i+counter1]){
					movement2=j-N-1-i+counter1;
					break;
				}
			}
			for(j=0;j<i-counter2;j++){
				if(tab[j]<=tab[i-counter2]){ // εδω
					movement2=i-counter2-j;
					break;
				}
			}
			if(maxmovement<movement1) maxmovement=movement1;
			if(maxmovement<movement2) maxmovement=movement2;
		}
	}
	//printf("%d\n",maxmovement);
	if (end<begin) printf("%d\n",maxmovement);
	else {
		if(flag==0) {
			//printf("Start at peak #%d and finish at peak #%d\n",end+1,begin+1);
			result = end-begin;
			if(maxmovement>result) result=maxmovement;
			printf("%d\n",result);
		}
		else{
			for(j=0;j<begin;j++){
				if(tab[j]<=max){	//if(tab[j]<=max){
					flag2=1;
					tempbegin=j;
					break;
				}
			}
			for(j=N-1;j>end;j--){	
				if(tab[j]>=min){	//if(tab[j]>=min){
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
			}
			//else pou tha meinoun stathera
			//printf("Start at peak #%d and finish at peak #%d\n",end+1,begin+1);
			result = end-begin;
			if(maxmovement>result) result=maxmovement;
			printf("%d\n",result);
		}
	}
	return 0;
}
