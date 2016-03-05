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
	
	
	#movl $0, %edi #inicjalizacja wskaznika
	#sub $1,%eax 	#w eax znajduje sie ilosc odzczytanych znakow odejmujemy znak nowej linii
	#mov %eax,%ecx #
	
modify:
		
	movb komunikat(,%edi,1), %al
	xor $MASK,%al
	movb %al,komunikat(,%edi,1)
		
	incl %edi	#zwieksz licznik
	cmp %ecx,%edi	#jezeli przetworzylismy wszyskie znaki
	jb modify	#skok do etykiety modify
	
	#wyswietlenie
	movl $komunikat_len, %edx
	movl $komunikat, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

