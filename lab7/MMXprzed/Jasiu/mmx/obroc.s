.text
.global obroc
.type obroc @function
obroc:
pushl %ebp
movl %esp, %ebp

mov 8(%esp), %esi   #bufor
mov 12(%esp), %ecx  #rozmiar
mov %esi, %eax
mov %ecx, %ebx

czytaj:
movl 0(%esi), %edx
ror $8, %edx
pushl %edx

movl 4(%esi), %edx
ror $16, %edx
pushl %edx

movl 8(%esi), %edx
ror $24, %edx
pushl %edx

addl $12, %esi

loop czytaj


mov %ebx, %ecx
mov %eax, %esi

wklej:
popl %edx
movl %edx, 0(%esi)
popl %edx
movl %edx, 4(%esi)
popl %edx
movl %edx, 8(%esi)

addl $12, %esi

loop wklej

pop %ebp
ret 
