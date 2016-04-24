#include <stdio.h> 
extern void funkcja_asm();  // nazwa funkcji zewnętrznej (z innego pliku) 
extern int globalna_z_asm;  // nazwa zmiennej zewnętrznej (z innego pliku) 

int globalna_z_C = 777;      
void moja_fun(char *arg)    // deklaracja własnej funkcji w C
{ 
	printf("Wywolanie z C: %s", arg); 
} 

int suma(int a, int b)      //  deklaracja własnej funkcji w C 
{ 
	return a+b; 
} 

float iloraz(float a, float b)   //  deklaracja własnej funkcji w C 
{ 
	if(b==0.0) return 0.0; 
	return a/b; 
} 

int main()                       /  funkcja główna w C 
{ 
	funkcja_asm();   // wywołanie funkcji zewnetrznej 
	printf("Zmienna z asemblera: %d\n", globalna_z_asm); 
	return 0; 
} 

.globl globalna_z_asm      # deklaracja nazwy zmiennej jako globalnej 
[.extern globalna_z_C]     # zbędne, symbol niezdefiniowany jest uznany za extern 
.data 
napis: .ascii "Argument z asemblera, wynik funkcji z C = %d\n\0" 
napis2:.ascii "Argument z asemblera, wynik float z C = %f\n\0" 

liczba1: .float 3 
liczba2: .float 4 

.type globalna_z_asm, @object    # zadeklaruj zmienna z C jako obiekt 
.size globalna_z_asm, 4 
globalna_z_asm: .long 444 


.text 
.globl funkcja_asm               # deklaracja nazwy funkcji jako globalnej 
.type funkcja_asm, @function 
 # definicja funkcji 
funkcja_asm: 
push %ebp 
mov %esp, %ebp             # utworz ramke stosu 
push $4                    # na stos liczbe 4 
push globalna_z_C          # na stos wartosc zmiennej globalne zdefiniowanej w C 
call suma                  # wywolaj funkcje z C 
add $8, %esp               # przesun stos 
push %eax                  # wynik sumowania na stos 
push $napis                # adres napisu jako ciag formatujacy dla printf 
call printf 
add $4, %esp 
mov liczba1, %eax          # zaladuj na stos zmienne float 
mov %eax, 4(%esp) 
mov liczba2, %eax 
mov %eax, (%esp) 
call iloraz                # wywolaj funkcje z C operujaca na zmiennych float 
fstps -8(%ebp)             # zapisz wynik z pamieci (ze stosu FPU st(0) ) 
flds -8(%ebp)              # zaladuj go ponownie do stosu FPU jako double 
fstpl (%esp)               # ze szczytu stosu FPU na szczyt sotsu programowego 
push $napis2               # adres napisu jako ciag formatuj
ą
cy dla printf 
call printf                # wypisz informacje 
add $4, %esp 
leave                      # usu
ń
 ramke stosu (mov %ebp, %esp / pop %ebp) 
ret                         
