.data
z: .space 10
.text

.globl loadBCD
  .type loadBCD, @function
loadBCD:
    push %ebp             #ramka stosu
	mov %esp, %ebp
	sub $8, %esp
	
	fldl 8(%ebp)          #zaladuj
	fbstp z               #zachowaj zmienna w kodzie BCD
bpt:
	fstp %st
	fstp %st
	
	leave
  ret
