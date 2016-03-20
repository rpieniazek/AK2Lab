SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
BUFOR_SIZE = 254

.data
bufor: .space BUFOR_SIZE
bufor_len = . - komunikat 

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
	
	#int $SYSCALL32
	
	mov $-3,%eax
	mov $2,%ebx
	imul %ebx
	mov %eax,%ecx
	add $'0',%ecx
	mov %ecx,bufor(0,1,1)
	out:
	#wyswietlenie
	movl $5, %edx
	
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

