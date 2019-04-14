#include<stdio.h>
int main ()
{
  int n,max,max1,min,min1,i,changemin,changemax;
  scanf("%d\n",&n);
  int tab[n];
  for(i=0;i<n;i++) scanf("%d",&tab[i]); //o pinakas einai etoimos
  max=tab[n-1];
  max1=max;
  min=tab[0];
  min1=min;   //to min1 kai to max1 einai ta prohgoymena max kai min
  i=0;
  while(min>max && i<n-1)
    {
      i++;
      changemin=0;
      changemax=0;
      if(tab[i]<min)
        {
          min1=min;
          min=tab[i];
          changemin=1;
        }
      if(tab[n-i-1]>max)
        {
          max1=max;
          max=tab[n-i-1];
          changemax=1;
        }
    }
  if(min>max)
    printf("no suitable pair");
  else if(changemin&&(!changemax))
    {
      // 4a3e sthn perioxh n-i-1 eos n-1
      printf("h apanthsh einai %d km",arithmos);
    }
  else if(changemax&&(!changemin))
    {
      //4a3e sthn perioxh 0 eos i
      printf("h apanthsh einai %d km",arithmos);
    }
  else if((changemin==1) && (changemax==1))
    {
      //exoyme 3 periptwseis:
      // a.4axnw me to min1 sthn perioxh n-i-1 eos n-1
      // b.4axnw me to max1 sthn perioxh 0 eos i
      // c.koitaw thn apostash i me n-i-1
      // h megalyterh diadromh einai kai h apanthsh
      printf("h apanthsh einai %d km",arithmos);
    }


}
