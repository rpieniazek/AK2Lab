SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
MASK = 0x20 #maska zamieniajaca kazda litere na wielka 0010 0000
BUFOR_SIZE = 254

.data
komunikat: .space BUFOR_SIZE
komunikat_len = . - komunikat 

.text
.global main

main:

	#wczytanie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
	#przetworzenie
	
	
	xorl %edi, %edi #inicjalizacja wskaznika
	
cipher:
		
	movb komunikat(,%edi,1), %al
	
	cmpb $'\n',%al
	je out

	orb $MASK, %al #zamiana wszystkich liter na male
	
	cmpb $'a', %al #sprawdzenie, czy znak jest literą
	jl hop
	cmpb $'z', %al
	jg hop
break:	
	#szyfrowanie
	addb $3, %al
	cmpb $'z',%al	 #koreka szyfru
	jbe hop
	subb $'z', %al
	
	hop:
	movb %al,komunikat(,%edi,1)
	incl %edi
	jmp cipher
	


	out:
	#wyswietlenie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

