#include <stdio.h>
#include <stdlib.h>
int main()
{
 int i,k;
 time_t t;
 FILE *fp;
 fp=fopen("cases.txt","w+");
srand((unsigned) time(&t));
 for(i=1;i<100;i++)
  {
    for(k=1;k<=i;k++)
      {
	fprintf(fp,"%d ",rand()%100);
      }
    fprintf(fp,"\n");
  }
  fclose(fp);
 return(0);
}
