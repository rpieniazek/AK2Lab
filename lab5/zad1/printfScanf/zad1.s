.data	
.align 32
format_string_input: 
	.string "%d"


format_string: 
	.ascii "Przykladowy string,Czesc  %s!, Jestem %s i mam   %d lata \n\0"

text1: 
	.ascii "Rafal\0"   # pierwszy parameter %s (łańcuch znaków zakończony \0) 
text2:
	.ascii "Rafal\0"   # drugi parameter %s (łańcuch znaków zakończony \0) 


number: 
	.long 0           # trzeci parameter %d (liczba dziesiętna)
 

.global main
 
.text 

 
main:

push $number
pushl $format_string_input       #łańcuch formatujący 
call scanf

                           # parametery przez stos w odwróconej kolejności 
push number           		# trzeci liczba dziesiętna (%d)  
pushl $text2               # drugi łańcuch (%s) 
pushl $text1               # pierwszy łańcuch (%s) 
pushl $format_string       #łańcuch formatujący 
call printf


call exit                  # funkcja zakończenia programu

