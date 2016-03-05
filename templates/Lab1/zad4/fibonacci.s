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
        mov 	$1,%ebx					#druga zmienna              
        inc     %ebx                    

print:
        

	#push    %eax 	#odkladamy na stos rejestry
	#push   	%ebx                   
	#push    %ecx                    
	
	#---------------- 
	#wypisywanie
	#------------
	mov $SYSWRITE, %eax	#funkcja
	mov $STDOUT, %ebx	#strumien
        mov $5,%ecx		#string
       	mov $5, %edx 		#dlugosc
         int $SYSCALL  
      #  pop     %ecx                    # sciagamy ze stosu rejestry(licznik)
	#	pop		%ebx					#pierwsza liczba
     #   pop     %eax                    # druga liczba

    #    mov     %eax, %edx              # tmp = a
    #    mov     %ebx, %eax              # a=b
     #   add     %edx, %ebx              # b = tmp+b
     #   dec     %ecx                    # zmniejszamy licznk
       # jnz     print                   #jezeli zawartosc rejestru jest ecx jest ronwa 0 t 

       ret

xorl %esi, %esi
# te petle slyzylyby do wydrukowania integera, mamy liczbe dzielimy przez 10 dopoki nie uzyskamy 0 kolejne liczby odkladac na stosie(cyfry zaczynaja sie od 48)
loop:
	movl $0, %edx
	movl $10, %ebx
	divl %ebx
	addl $48, %edx
	pushl %edx
	incl %esi
	cmpl $0, %eax
	jz   next
	jmp loop

next:
	cmpl $0, %esi
	jz   exit
	decl %esi
	movl $4, %eax
	movl %esp, %ecx
	movl $1, %ebx
	movl $1, %edx
	int  $0x80
	addl $4, %esp
	jmp  next

format:
        .asciz  "%20ld\n"
tekst:
	.string "bla"
