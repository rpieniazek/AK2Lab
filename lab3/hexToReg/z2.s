SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
BUFOR_SIZE = 10
BASE = 16
MASK = 0x20
.data
	bufor: .space BUFOR_SIZE
	bufor_len = . - bufor 

.text
.global _start


_start:

	#wczytanie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
	mov $0,%edx		#wynik
	mov $0,%edi
	mov $0,%ecx
L1:
	
	movb bufor(,%edi,1), %cl
		
	cmpb $'\n',%cl
	je out
	
	L2:
		mov $BASE,%eax
		mul %edx
		mov %eax,%edx
		
		orb $MASK,%cl	
		cmp $'a',%cl
		jb is_digit
		cmp $'f',%cl
		ja is_digit
		subb $'a',%cl
		add $10, %cl
		jmp hop
		
	is_digit:
		subb $'0', %cl
				
	hop:
		add %ecx,%edx
			
	
	inc %edi
	jmp L1
	

##wypisywanie 
mov %edx, %ebx
mov $0,%edi
regToBuffer:
	L3:
		mov %ebx, %eax
		mov $0, %edx
		mov $BASE,%ecx
		div %ecx
		mov %eax,%ebx
		movb %cl, bufor(,%edi,1)
		inc %edi
		cmp $0,%ebx	
		jne L3
	
			
		

break:	
	

	out:
	#wyswietlenie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

