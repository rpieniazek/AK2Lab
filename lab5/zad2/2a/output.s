SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
BUFOR_SIZE = 10
BASE = 10

.data
bufor: .space BUFOR_SIZE
bufor_len = . - bufor 

outputBufor: 
	.ascii "wynik:         \n"	
outputBuforLen=.-outputBufor

format_string: 
	.ascii "Wynik to:   %d \n\0"


.text
.global output

output:
	push %ebp
	mov %esp, %ebp
	mov 8(%ebp), %eax
	mov 12(%ebp), %ebx
break:
	add %eax, %ebx
		
	push %ebx
	push $format_string
	call printf
	
	mov %ebp, %esp	#	przywroc wskaznik stosu	
	pop %ebp 		# 	
	
	ret




