SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0
counter = 2    

   
.global main


main:   
  	mov $counter, %ecx;
           	
        jmp L1
        
        	
 L1:
        push %ecx 	#dla petli
   	

        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $blank,%ecx		#string
       	mov $3, %edx 		#dlugosc
	
        int $SYSCALL
	
        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $sign,%ecx		#string
       	mov $3, %edx 		#dlugosc
	
        int $SYSCALL

        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $new_line,%ecx	#string
       	mov $1, %edx 		#dlugosc
	
        int $SYSCALL

	pop %ecx
	dec %ecx
	jnz L1
        mov $counter,%ecx 
        jmp center
        

center:
       
        push %ecx 	#dla petli
   	

        mov $3,%ecx
        center_inner:
	        
                push %ecx

                mov $SYSWRITE, %eax	#funkcja
	        mov $STDOUT, %ebx	#strumien
                mov $sign,%ecx		#string
               	mov $3, %edx 		#dlugosc
	
                int $SYSCALL
                
                pop %ecx
                dec %ecx
                jnz center_inner
                

        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $new_line,%ecx	#string
       	mov $1, %edx 		#dlugosc
	
        int $SYSCALL

	pop %ecx
	dec %ecx
	jnz center
        mov $counter,%ecx
        jmp L2
        
L2:
        push %ecx 	#dla petli
   	

        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $blank,%ecx		#string
       	mov $3, %edx 		#dlugosc
	
        int $SYSCALL
	
        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $sign,%ecx		#string
       	mov $3, %edx 		#dlugosc
	
        int $SYSCALL

        mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $new_line,%ecx	#string
       	mov $1, %edx 		#dlugosc
	
        int $SYSCALL

	pop %ecx
	dec %ecx
	jnz L2
        
        ret



          


	
blank: 	
	.string "   "

sign: 
	.string "***"

new_line:
	.string "\n"
