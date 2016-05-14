#include <stdio.h>

extern int getPrecision();
extern int getRoundingMode();
extern int getStackStatus(int);


int main()
{
  __asm("finit");
  int precision = getPrecision(); //sprawdzanie precyzji
	printf("Precision is: \t\t"); 
	switch(precision)
	{
	  case 0:
		  puts("Single Precision (24 bits)"); break; //pojedyncza
	  case 2:
		  puts("Double Precision (54 bits)"); break;//podwojna
		case 3:
		  puts("Double Extended Precision (64 bits)"); break;//rozszerzona
		default:
		  puts("Undefined"); break;//niezdefiniowana
	}
	
	__asm("finit");
	int rounding_mode = getRoundingMode();//sprawdzanie trybu zaokraglania
	printf("Rounding mode is: \t");
	switch(rounding_mode)
	{
	  case 0:
		  puts("Round to nearest (even)"); break; //zaokraglanie do najblizszej
		case 1:
		  puts("Round down"); break;//zaokraglanie w dol
	  case 2:
		  puts("Round up"); break;//zaokraglanie w gore
		case 3:
		  puts("Round toward zero (truncate)"); break; //zaokraglanie 'do zera'
		default:
		  puts("Undefined"); break;//niezdefiniowane
	}
	
	__asm("finit");
	int exceptions = getExceptions();//wyj�tki
	printf("Exceptions:\n");
	if (exceptions & 1)  puts("\t\t\tInvalid operation");//niewlasciwa operacja
	if (exceptions & 2)  puts("\t\t\tDenormalized operand");//zdenormalizowany argument
	if (exceptions & 4)  puts("\t\t\tDivide-by-zero");//dzielenie przez zero
	if (exceptions & 8)  puts("\t\t\tNumeric overflow");//nadmiar
	if (exceptions & 16) puts("\t\t\tNumeric underflow");//niedomiar
	if (exceptions & 32) puts("\t\t\tInexact result (precision)");//niedokladnosc
	if (exceptions == 0) puts("\t\t\tNo exceptions");//brak wyjatkow
	
	printf("Stack: \n");
	int i, j, stack_status;
	for(i=0, j=0; i<8; ++i)
	{
		__asm("finit");
		stack_status = getStackStatus(i);//stan rejest�w stosu
		if(stack_status == 3) continue;
		printf("\t\t\tst(%d) is: ", j);
	    switch(getStackStatus(i))
		{
		  case 0:
			  puts("Valid"); break;//poprawny
			case 1:
				puts("Zero"); break;//zero
			case 2:
			  puts("Special: invalid (NaN, unsupported), infinity, or denormal"); //specjalny
				break;
			case 3:
				puts("Empty"); break;
			default:
			  break;
		}
		++j;
	}
	return 0;
}


