SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.global main

        .text
main:
        mov     $10, %ecx               # licznik
        mov     $0, %eax              	#pierwsza zmienna 	 
        mov 	$1,%ebx			#druga zmienna              
        inc     %ebx                    

print:
        

        pushl    %eax 
	pushl   %ebx                   
        pushl    %ecx                    
	
 	mov %eax,%ecx		#string
	mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $5, %edx 		#dlugosc
	int $SYSCALL	

          
        popl     %ecx                    # restore caller-save register
	popl	%ebx
        popl     %eax                    # restore caller-save register

        mov     %eax, %edx              # save the current number
        mov     %ebx, %eax              # next number is now current
        add     %edx, %ebx              # get the new next number
        dec     %ecx                    # count down
        jnz     print                   # if not done counting, do some more

       ret


