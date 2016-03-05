SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0
  
.global main


main:   
		
 	mov $2, %ecx;
	jmp top;
top: 	
	cmp $0,%ecx 
	je center
	dec %ecx

	
	mov $blank,%edi
	call puts
	ret
	#mov $sign,%edi
	#call puts
	#mov $blank,%edi
	#call puts
	jmp top
	
	
center:
	jmp bottom	
			
   	bottom:
		
  	 mov $SYSEXIT, %eax
	 int $SYSCALL


blank: 	
	.asciz "hello"

sign: 
	.asciz "2"
newLine:
	.asciz "\n"

