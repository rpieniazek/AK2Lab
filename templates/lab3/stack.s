SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.global _start

_start:
        #mov     $5, %rcx               # licznik
        mov $0,%rax		                  

#L1:
        
	
	mov 8(%rsp,%rax,8), %rsi
	
	# mov %rax,%r8
	# mov %rcx,%r9
	
	 mov $1, %rax			#funkcja
	 mov $STDOUT, %rdi		#strumien
     #mov %rdx,%rsi			#string
     mov $40, %rdx 			#dlugosc
		
     syscall
    

 	mov $new_line,%rsi			#string
     mov $40, %rdx 			#dlugosc
     syscall 
     
	   # mov %r8,%rax  
		#mov %r9,%rcx 
		#inc %rax 
	
		#dec %rcx 	# nast rejestr
		#jnz L1
	
	 mov $60,%rax		# exit syscall (x86_64)
	 mov $0,%rdi			# status = 0 (exit normally)
	
	 syscall



new_line :
	.asciz "/n"