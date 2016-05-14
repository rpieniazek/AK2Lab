#include <stdio.h>

double X2;
double PM;
double PL;
double SIL;

double sinus(double x)
{
  X2 = x*x;
	PL = x;
	PM = 1.0;
	SIL = 1.0;
	
	PL = -1.0*PL*X2;
	PM = SIL*(SIL+1)*(SIL+1+1);
	
	SIL = SIL + 1.0 + 1.0;
	
	return PL/PM;
}

int main()
{
  double x = sinus(2.0);
	printf("%lf\n", x);
	return 0;
}

