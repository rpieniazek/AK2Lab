#include "power.h"
int power(int base,int exp)
{
	int wynik = 1;
	int i=0;
	for(i=0;i<exp;i++)
	{
		wynik*=base;
	}
	return wynik;

}
void main(){}
