
.align 32

.data
status_word: .word 0
env: .space 28

.text

.globl getExceptions                #funkcja umozliwaiajaca odczytanie obslugiwanych wyjatkow
  .type getExceptions, @function
getExceptions:
	fstcw status_word               #informacje o wystepujacych wyjatkach
	mov status_word, %eax           #znajduja si� na najmlodszych 6 bitach slowa kontrolnego
	and $63, %eax
	ret
	
.globl unmaskExc                    #funkcja okreslajaca wyjatek
  .type unmaskExc, @function
unmaskExc:
    fstcw status_word
	mov status_word, %eax
	and $0xffffffc0, %eax
	or 4(%esp), %eax
	mov %eax, status_word
	fldcw status_word
	ret
