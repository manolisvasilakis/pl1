#include<stdio.h>
int main ()
{
  int n,k,l,max,max1,min,min1,i,j,changemin=1,changemax=1;
  scanf("%d\n",&n);
  int tab[n],min_tab[n],max_tab[n],flag;
  for(i=0;i<n;i++) scanf("%d",&tab[i]); //o pinakas einai etoimos
  max=tab[n-1];
  min=tab[0];
  i=0;
  min_tab[i]=min;
  max_tab[n-1]=max;
  while(i<n/2 )
    {
      if(min<=max)
	{
	  flag=1; break;
	}
      i++;
      changemin=0;
      changemax=0;
      if(tab[i]<min)
        {
          min=tab[i];
          changemin=1;
        }
      if(tab[n-i-1]>max)
        {
          max=tab[n-i-1];
          changemax=1;
        }
      min_tab[i]=min;
      max_tab[n-1-i]=max;
    }
 int maxdistance1=-1,maxdistance2=-1;
    //tsekarw sthn apenanti perioxh poy egine h teleytaia allagh
 if (flag==1)
    {
      if(changemin==1 || i>=n/2)
	{
	  for(j=n-1;j>=n-1-i;j--)
	    {
	      if(tab[j]>=min)
		{
		  maxdistance1=j-i;
		  break;
		}
	    }
	}
      if(changemax==1|| i>=n/2)
	{
	  for(j=0;j<i;j++)
	    {
	      if(tab[j]<=max)
		{
		  maxdistance2=n-1-i-j;
		  break;
		}
	    }

	}


     if(maxdistance1>maxdistance2)
        printf("3.a.max apostash einai %d \n",maxdistance1);
     else
        printf("3.b.max apostash einai %d\n",maxdistance2);
    }
 else
  {
    int distance1=0,distance2=0,flag1=0,flag2=0;
    for(i=0;i<n/2;i++)
      {

	if(tab[n/2+i]<=max_tab[n/2+i+1] && flag1==0)
	  {
	    flag1=1;
	    for(l=n/2+i+1;l<=n-1;l++)
	      {
                 if(tab[n/2+i]>max_tab[l])
		   break;
		 else
		   distance1++;
	      }

	  }
	if(tab[n/2-i]>=min_tab[n/2-i-1] && flag2==0)
	  {
	    flag2=1;
	    for(l=n/2-i-1;l>=0;l--)
	      {
		if(tab[n/2-i]<min_tab[l])
		  break;
		else
		  distance2++;
	      }
	  }
      }
          if(distance1>distance2)
	    printf("1.a.max apostash=%d\n",distance1);
	  else
	    printf("1.b.max apostash=%d\n",distance2);


  }
  return 0;
}
      
