.data 32

PL: .space 8 #zmienna na licznik
PM: .space 8  #zmienna na mianownik
X2: .space 8  #zmienna tymczasowa na x^2
PR: .space 8  #zmienna tymczasowa na precyzje
SIL: .space 8 #licznik silni
WYNIK: .space 8

.text

.globl sinus   #funkcja obliczajaca funkcje sinus - rozwiniecie w szereg Taylora
  .type sinus, @function
sinus:
    push %ebp
	mov %esp, %ebp
	sub $8, %esp
	
	fldl 8(%ebp)                    #zaladuj x
	fmull 8(%ebp)                   #pomnoz go przez siebie
	fstpl X2                        #zapisz x^2 w pamieci i zdejmujemy ze stosu - cofamy kazdy rejestr o 1
	
	fldl 16(%ebp)
	fstpl PR                        #zapisz x
	
	fldl 8(%ebp)
	fstpl PL                        #zapisz precyzje
	
	fld1
	fstpl PM                        #zapisz mianownik
	fld1
	fstpl SIL                       #zapisz licznik silni
	
petla:
	fldl PL                         #laduj licznik i mianownik
	fldl PM
	fdivrp %st, %st(1)              #licza ktualny wyraz ciagu
	fld %st                         #kopiuj na szczyt
	fabs                            #zastap szczyt stosu jego wartoscia bezwzgledna
	fcompl PR                       #porownaj precyzje
	fstsw %ax                       #zapisz do ax stan fpu
	sahf                            #zapisz ah do flag
	jb wyjdz
	faddl WYNIK                     #dodaj obliczony wyraz do wyniku
	fstpl WYNIK                     #aktualizuj wynik
	
	fldl PL 
	fchs                            #zmiana znaku na przeciwny (dla nieparzystych n)
	fldl X2
	fmulp %st, %st(1)               #oblicz licznik
	fstpl PL                        #aktualizuj licznik
	
	fldl PM 
	fld1                            #laduj 1
	faddl SIL                       #zwieksz licznik silni
	fstl SIL
	fmulp %st, %st(1)               #oblicz mianownik - silnia
	fld1
	faddl SIL
	fstl SIL
	fmulp %st, %st(1)
	fstpl PM                        #aktualizuj mianownik
	
	jmp petla

wyjdz:
  fstp %st
  fldl WYNIK
	
  leave
  ret


.globl cosinus                      #funkcja obliczajaca funkcje cosinus - rozwiniecie w szereg Taylora
  .type cosinus, @function
cosinus:
    push %ebp
	mov %esp, %ebp
	sub $8, %esp
	
	fldl 8(%ebp)                    #zapisz x
	fmull 8(%ebp)                   #podnies do kwadratu
	fstpl X2                        #zapisz x^2
	
	fldl 16(%ebp)
	fstpl PR                        #zapisz precyzje
	
	fld1
	fstpl PL                        #zapisz x
	
	fld1
	fstpl PM
	fldz
	fstpl SIL
	
	fldz
	fstpl WYNIK
	
petla2:
	fldl PL
	fldl PM
	fdivrp %st, %st(1)              #licz aktualny wyraz ciagu
	fld %st                         #kopiuj na szczyt
	fabs
	fcompl PR                       #porownaj precyzje
	fstsw %ax
	sahf
	jb wyjdz2
	faddl WYNIK                     #dodaj obliczony wyraz do wyniku
	fstpl WYNIK                     #aktualizuj wynik
	
	fldl PL 
	fchs
	fldl X2
	fmulp %st, %st(1)               #oblicz licznik
	fstpl PL                        #aktualizuj licznik
	
	fldl PM 
	fld1
	faddl SIL
	fstl SIL
	fmulp %st, %st(1)               #oblicz mianownik - silnia
	fld1
	faddl SIL
	fstl SIL
	fmulp %st, %st(1)
	fstpl PM                        #aktualizuj mianownik
	
	jmp petla2

wyjdz2:
  fstp %st
	fldl WYNIK
	
  leave
  ret


.globl myexp                        #funkcja obliczajaca funkcje wykladnicza
  .type myexp, @function
myexp:
    push %ebp
	mov %esp, %ebp
	sub $8, %esp
	
	fldl 8(%ebp)
	fstpl X2
	
	fldl 16(%ebp)
	fstpl PR                        #zapisz precyzje
	
	fld1
	fstpl PL
	
	fld1
	fstpl PM
	
	fldz
	fstpl SIL
	
	fldz
	fstpl WYNIK
	
petla3:
	fldl PL
	fldl PM
	fdivrp %st, %st(1)               #licz aktualny wyraz ciagu
	fcoml PR                         #porownaj precyzje
	fstsw %ax
	sahf
	jb wyjdz3
	faddl WYNIK
	fstpl WYNIK                      #aktualizuj wynik
	
	fldl PL 
	fmull X2                         #oblicz licznik
	fstpl PL
	
	fld1
	fldl SIL
	faddp %st, %st(1)                #oblicz mianownik - silnia
	fstpl SIL
	fldl PM
	fmull SIL
	fstpl PM
		
	jmp petla3

wyjdz3:
  fstp %st
	fldl WYNIK
	
  leave
  ret


