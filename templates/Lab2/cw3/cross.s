SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.data  
counter = 2       
.global main

main:   
    
    mov $counter,%ecx      # store var x in ecx register
    
    top:
        cmp $0, %ecx  #test at top of loop
        je bottom    
    
        mov $blank, %eax
        movl $SYSWRITE, %eax
           
        mov $sign, %rdi
        call printf
            
        dec %ecx
        jmp top
    bottom:
       int $SYSCALL

blank: 	
    .asciz "%%%"

sign: 
    .asciz "***"


