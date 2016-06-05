.data
wspolczynnik: .quad 0x2020202020202020
.global rozjasnij
.type rozjasnij, @function
rozjasnij:
mov 4(%esp), %esi   #bufor
mov 8(%esp), %ecx  #rozmiar
mov %esi, %eax

dodaj:
movq 0(%esi), %mm0
movq wspolczynnik, %mm4
paddusb %mm4, %mm0
movq %mm4, 0(%esi)
addl $8, %esi
loop dodaj
mov %ebx, %ecx
ret 
