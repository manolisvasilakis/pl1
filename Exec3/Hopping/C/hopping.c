#include<stdio.h>

int main(int argc, char *argv[]){
	int N, K, B, i, j, num;
	FILE *fr;
	fr = fopen (argv[1], "r");
	fscanf(fr, "%d", &N);		//αριθμός σκαλοπατιών
	fscanf(fr, "%d", &K);		//αριθμός δυνατών κινήσεων
	fscanf(fr, "%d", &B);		//αριθμός χαλασμένων σκαλοπατιών
	int stairs[N], moves[K];
	for(i = 0; i < K; i++) fscanf(fr, "%d", &moves[i]);
	for(i = 0; i < N; i++) stairs[i] = 0;
	stairs[0] = 1;
	for(i = 0; i < B; i++){
		fscanf(fr, "%d", &num);
		stairs[num-1] = -1;		//σπασμένο -1, οκ 0
	}
	fclose(fr);
	if (stairs[0] == -1 || stairs[N-1] == -1) printf("0\n");
	else{
		for (i = 0; i < N-1; i++)
		{
			if (stairs[i] < 1) continue;
			for (j = 0; j < K; j++){
				if (i + moves[j] > N-1) continue;	//αν moves ταξινομημένος θα γίνει break
				if (stairs[i + moves[j]] == -1) continue;
				stairs[i + moves[j]] = (stairs[i + moves[j]] + stairs[i]) % 1000000009;
			}
		}
		printf("%d\n", stairs[N-1]);
	}
	return 0;
}

/*
	πιθανές βελτιώσεις :
		ταξινόμηση πίνακα moves
		δομή που αποδεσμεύει χώρο αφού περάσω τα σκαλοπάτια
*/
