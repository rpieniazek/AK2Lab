#include <stdio.h>


int main()
{
	int a = 3;
	int b = 5;
	int result = 0;
	__asm__(
		"mov %1, %%ecx;\n"
        "mov %2, %%ebx;\n"
		"add %%ecx,%%ebx\n"
		"mov %%ebx,%0\n"

         : "=b" ( result )        /* output */
         : "c" ( a ), "b" (b)         /* input */
         : "%ecx"
	);

	printf("%d",result);

	return 0;
}
