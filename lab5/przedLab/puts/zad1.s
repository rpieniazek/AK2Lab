.data
.align 32

napis:
	.ascii "Napis\0" 	# musi być zakończony terminatorem ‘\0’ (koniec)  
	
.global main             # dyrektywa eksportowania nazwy do linkera 
#################################################################

.text 


main:                   # etykieta startowa jak dla C, kompilacja gcc 

	push $napis           # adres łańcucha na stos (parametr funkcji puts) 
	call puts               # wywołanie funkcji języka C  
	call exit



