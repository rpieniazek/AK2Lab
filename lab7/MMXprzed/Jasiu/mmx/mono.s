.global mono
.type mono, @function
mono:
mov 4(%esp), %esi   #bufor
mov 8(%esp), %ecx  #rozmiar
push %esi
srednia:
xor %ax, %ax
xor %bh, %bh

movb 0(%esi), %bl
addw %bx, %ax
movb 1(%esi), %bl
addw %bx, %ax
movb 2(%esi), %bl
addw %bx, %ax

movb $3, %bl
div %bl

movb %al, 0(%esi)
movb %al, 1(%esi)
movb %al, 2(%esi)

addl $3, %esi

loop srednia
pop %eax
ret 
