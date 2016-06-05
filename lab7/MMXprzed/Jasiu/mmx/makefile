main: 	main.o negatyw.o obroc.o rozjasnij.o mono.o
	gcc main.o negatyw.o obroc.o rozjasnij.o mono.o -o main -m32
main.o: main.c
	gcc -c main.c -o main.o -m32
negatyw.o: negatyw.s
	gcc -c negatyw.s -o negatyw.o -m32
obroc.o: obroc.s
	gcc -c obroc.s -o obroc.o -m32
rozjasnij.o: rozjasnij.s
	gcc -c rozjasnij.s -o rozjasnij.o -m32
mono.o: mono.s
	gcc -c mono.s -o mono.o -m32