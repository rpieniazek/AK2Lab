.data
ROZJASNIENIE: .quad 0x4040404040404040
.text
.global negatyw
.type negatyw @function
negatyw:

push %rbp      # Umieszczenie na stosie poprzedniej wartości
               # rejestru bazowego
mov %rsp, %rbp # Pobranie zawartości rejestru RSP (zawierającego
               # wskaźnik na ostatni element umieszczony
               # na stosie) do rejestru bazowego
#sub $8, %rsp   # "Zwiększenie" wskaźnika stosu o jedną komórkę
 
mov 16(%rbp), %rsi # Pobranie pierwszego argumentu do rejestru RAX
mov 24(%rbp), %rcx # Pobranie drugiego argumentu do rejestru RBX


mov	%rsi, %rax
dzialanie:
	movq	0(%rsi), %mm0
	#movq	ROZJASNIENIE, %mm4
	#paddusb	%mm4, %mm0
	movq	%mm0, 0(%rsi)
	addq	$8, %rsi
	loop	dzialanie
ret
