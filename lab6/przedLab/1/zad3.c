#include <stdio.h>

extern void loadBCD(double);

int main()
{
    double x;
	scanf("%lf", &x);
	loadBCD(x);
	return 0;
}
