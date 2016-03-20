SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
MASK = 0x20 		#maska zamieniajaca kazda litere na wielka 0010 0000
BUFOR_SIZE = 254

.data
komunikat: .space BUFOR_SIZE
komunikat_len = . - komunikat 

.text
.global _start

_start:

	#wczytanie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
						#przetworzenie
	
	
	xorl %edi, %edi 	#inicjalizacja wskaznika
	
loop:
		
	movb komunikat(,%edi,1), %al #skopiowanie  znaku z bufora do rejestru
	
	cmpb $'\n',%al 		#sprawdzamy, czy przetworzono juz cala linie
	je print				

	orb $MASK, %al 		#zamiana wszystkich liter na male
	
	cmpb $'a', %al 		#sprawdzenie, czy znak jest literą
	jl break
	cmpb $'z', %al
	jg break


	
	movb %al,komunikat(,%edi,1)

	break:
	incl %edi
	jmp loop
	


	print:
	#wyswietlenie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

