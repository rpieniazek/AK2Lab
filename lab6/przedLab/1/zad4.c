#include <stdio.h>
#include <math.h>
#include <float.h>

extern int getExceptions();
extern void unmaskExc(int);

int main()
{
  char* exc[] = {"Invalid operation", "Denormalized operand", "Div by 0", 
	               "Numeric overflow", "Numeric underflow", "Inexact"};
  unsigned int tab[] = {0x1f, 0x2f, 0x37, 0x3b, 0x3d, 0x3e}; //kody wyjatkow
  __asm("fclex");
  double x = DBL_MAX; //zmienna x - maksymalna wartosc float
  double y = 2.5 * 3.5;
  int i;
  for(i=0; i<6; ++i)
  {
	  printf("%s: ", exc[i]); fflush(stdout); //wydruk wyjatku
	  unmaskExc(tab[i]);
	  y = x*x;
  }
  return 0;
}
