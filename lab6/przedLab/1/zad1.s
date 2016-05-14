.align 32

.data
status_word: .word 0
environment: .space 28

test: .long 234

.text
.globl getPrecision                 #funkcja umozlwiajaca sprawdzenie precyzji
    .type getPrecision, @function
getPrecision:
	fstcw status_word	
	mov status_word, %eax           #odczytanie precyzji         
	shr $8, %eax                    #pole PC (precision control) znajduje sie 
	and $3, %eax                    #miedzy 8 a 9 bitem slowa controlnego FPU       
	ret


.globl getRoundingMode              #funkcja umozliwiajace sprawdzic tryb zaokraglania
    .type getRoundingMode, @function
getRoundingMode:
    fstcw status_word
	mov status_word, %eax           #odczytanie trybu zaokraglania
	shr $10, %eax                   #informacje o trybie zawieraja bity 10 oraz 11
	and $3, %eax                    #slowa kontrolnego
	ret

.globl getExceptions                #funkcja umozliwaiajaca odczytanie obslugiwanych wyjatkow
    .type getExceptions, @function
getExceptions:
	fstcw status_word               #informacje o wystepujacych wyjatkach
	mov status_word, %eax           #znajduja si� na najmlodszych 6 bitach slowa kontrolnego
	and $63, %eax
	ret

.globl getStackStatus               #funkcja umozliwiajaca sprawdzenie stanow poszczegolnych
  .type getStackStatus, @function   #rejestrow stosu
getStackStatus:
    push %ebp                       #tworzenie ramki stosu
    mov %esp, %ebp
	add $8, %ebp
	push %ecx
	push %edi
	mov (%ebp), %ecx
	fild test                       #zaladuj zmienna calkowita test          
	fldz	                        #zaladuj 0
	xor %eax, %eax                  
    fstenv environment              #zapisz srodowisko
	mov $8, %edi
	mov environment(%edi), %eax	
	cmp $0, %ecx
	jz nie_przesuwaj
przesuwaj:	                        #petla umozliwiajaca przejscie przez wszystkie rejestry
	shr $2, %eax
	loop przesuwaj
nie_przesuwaj:	                    #sprawdzanie zawartosci poszczegolnych rejestrow
	and $3, %eax
	pop %edi                        #niszczenie ramki stosu  
	pop %ecx
	pop %ebp
ret

