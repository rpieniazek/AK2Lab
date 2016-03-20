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
.global _start
#male deszyfrowanie
#wielkie szyfrowanie

_start:

	#wczytanie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
	
	xorl %edi, %edi 				#inicjalizacja wskaznika
	
	movb komunikat(,%edi,1), %bl 			#wczytanie parametru szyfru
	incl %edi
	
	or $0x40, %bl 					#duze kody mają kody 0x41,0x42....
	cmpb $'Z',%bl					#jezeli wielka to szyfrujemy
	jbe prepare_encrypt
prepare_decrypt:	
	subb $'a', %bl	
	negb %bl
	jmp cipher
	
	
	
prepare_encrypt:	
	subb $'A', %bl
	#movb $' ',komunikat(,$0,1) 	#ukrycie klucza

	
cipher:
			
	movb komunikat(,%edi,1), %al
	
	cmpb $'\n',%al
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
	
	
	

