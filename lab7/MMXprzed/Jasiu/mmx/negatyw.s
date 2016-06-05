.text
.global negatyw
.type negatyw @function
negatyw:
pushl %ebp
movl %esp, %ebp
        mov     8(%esp), %esi   #bufor
        mov     12(%esp), %ecx   #rozmiar
        mov %esi, %eax
petla1:
        movq    0(%esi), %mm0
        pcmpeqw %mm4, %mm4
        pxor    %mm4, %mm0
        movq    %mm0, 0(%esi)
        addl    $8, %esi
        loop    petla1
       // mov %ebx, %ecx
       pop %ebp
ret
