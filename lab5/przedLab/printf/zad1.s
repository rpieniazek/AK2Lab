
.data	
.align 32
format_string: # 
	.ascii "Hello! %s is a %s who loves the number %d\n\0"

text1: 
	.ascii "Tekst1\0"   # pierwszy parameter %s (łańcuch znaków zakończony \0) 
text2:
	.ascii "Tekst2\0"   # drugi parameter %s (łańcuch znaków zakończony \0) 


.global main
 
.text 

 
main:
                           # parametery przez stos w odwróconej kolejności 
push number           		# trzeci liczba dziesiętna (%d)  
pushl $text2               # drugi łańcuch (%s) 
pushl $text1               # pierwszy łańcuch (%s) 
pushl $format_string       #łańcuch formatujący 
call printf
#pushl $0                  .. zwracany kod błędu # 
call exit                  # funkcja zakończenia programu

number: 
	.long 3            # trzeci parameter %d (liczba dziesiętna)
 
