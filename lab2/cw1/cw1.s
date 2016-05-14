SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
MASK = 0x20 		#maska zamieniajaca kazda litere na wielka 0010 0000
BUFOR_SIZE = 254

.data
bufor: .space BUFOR_SIZE	#
bufor_len = . - bufor 

.text
.global _start

_start:

	movl $bufor_len, %edx	#wczytanie
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32	
	#początek przetwarzenia						
	xorl %edi, %edi 	#inicjalizacja wskaznika
	
loop:
		
	movb bufor(,%edi,1), %al #skopiowanie  znaku z bufora do rejestru
	
	cmpb $'\n',%al 		#sprawdzamy, czy przetworzono juz cala linie
	je print				

	orb $MASK, %al 		#zamiana wszystkich liter na male
	
	cmpb $'a', %al 		#sprawdzenie, czy znak jest literą
	jl break
	cmpb $'z', %al
	jg break

	movb %al,bufor(,%edi,1)#skopiowanie znaku do bufora

	break:
	incl %edi		#inkrementacja wskaznika
	jmp loop

	print:				#wyswietlenie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

