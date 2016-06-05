.data
.text
.global _rozjasnienie_bez_MMX
.type _rozjasnienie_bez_MMX @function
_rozjasnienie_bez_MMX:
	mov	4(%esp), %esi
	mov	8(%esp), %ecx
dzialanie:
	mov		0(%esi), %ebx
	addl	$0x40404040, 0(%esi)
	cmp		%ebx, 0(%esi)
	jb		napraw
nie_naprawiaj:
	addl	$1, %esi
	loop	dzialanie
ret

napraw:
	movb	$255, 0(%esi)
	jmp		nie_naprawiaj
