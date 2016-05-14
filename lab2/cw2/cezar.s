SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
MASK = 0x20 #maska zamieniajaca kazda litere na wielka 0010 0000
BUFOR_SIZE = 254

.data
bufor: .space BUFOR_SIZE
bufor_len = . - bufor 

.text
.global _start
#male deszyfrowanie
#wielkie szyfrowanie

_start:

	#wczytanie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
	
	xorl %edi, %edi 				#inicjalizacja wskaznika
	
	movb bufor(,%edi,1), %bl 		#wczytanie parametru szyfru
	incl %edi
	
	or $0x40, %bl 					#duze kody mają kody 0x41,0x42....
	cmpb $'Z',%bl					#jezeli wielka to szyfrujemy
	jbe prepare_encrypt
prepare_decrypt:					#w przeciwnym przypadku deszyfrujemy
	subb $'a', %bl	
	negb %bl
	jmp cipher
	
	
prepare_encrypt:	
	subb $'A', %bl
	#movb $' ',bufor(,$0,1) 	#ukrycie klucza

	
cipher:							
			
	movb bufor(,%edi,1), %al	#pobranie znaku z bufora
	
	cmpb $'\n',%al		#sprawdzenie, czy nie nastąpił znak końca nowej linii
	je out

	orb $MASK, %al 		#zamiana wszystkich liter na male
	
	cmpb $'a', %al 		#sprawdzenie, czy znak jest literą
	jl hop				
	cmpb $'z', %al
	jg hop
	
	
	addb %bl, %al		#szyfrowanie

	cmpb $'z',%al	 	#koreka szyfru
	jle hop
	subb $'z', %al
	addb $'a', %al
	
	hop:
	movb %al,bufor(,%edi,1)	#wpisanie przetworzonego napisu do bufora
	incl %edi				#zwiększenie wskaźnika
	jmp cipher
	
	out:
	movl $bufor_len, %edx	#wyswietlenie
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

