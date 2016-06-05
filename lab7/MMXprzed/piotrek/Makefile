main: main.o negatyw.o negatyw_bez_MMX.o rozjasnienie.o rozjasnienie_bez_MMX.o
	gcc -m32 -o main main.o negatyw.o negatyw_bez_MMX.o rozjasnienie.o rozjasnienie_bez_MMX.o
main.o: main.c
	gcc -m32 -c -o main.o main.c
negatyw.o: negatyw.s
	gcc -m32 -c -o negatyw.o negatyw.s
negatyw_bez_MMX.o: negatyw_bez_MMX.s
	gcc -m32 -c -o negatyw_bez_MMX.o negatyw_bez_MMX.s
rozjasnienie.o: rozjasnienie.s
	gcc -m32 -c -o rozjasnienie.o rozjasnienie.s
rozjasnienie_bez_MMX.o: rozjasnienie_bez_MMX.s
	gcc -m32 -c -o rozjasnienie_bez_MMX.o rozjasnienie_bez_MMX.s
