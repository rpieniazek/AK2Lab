#include <stdio.h>
#include <math.h>

extern double sinus(double, double);
extern double cosinus(double, double);
extern double myexp(double,double);

int main()
{
    double x, d;
    puts("sin(x), cos(x) z dokladnoscia d");
	printf("x = "); scanf("%lf", &x);
	printf("d = "); scanf("%lf", &d);
    printf("\nsin(%lf) [Taylor] = %lf\nsin(%lf) [biblio] = %lf\n\n",x,sinus(x,d),x,sin(x));
	printf("cos(%lf) [Taylor] = %lf\ncos(%lf) [biblio] = %lf\n\n",x,cosinus(x,d),x,cos(x));
	printf("exp(%lf) [Taylor] = %lf\nexp(%lf) [biblio] = %lf\n\n",x,myexp(x,d),x,exp(x));
	return 0;
}

