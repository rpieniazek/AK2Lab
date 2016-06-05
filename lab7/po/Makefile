main: main.o negatyw.o 
	gcc -m32 -o main main.o negatyw.o
main.o: main.c
	gcc -m32 -c -o main.o main.c
negatyw.o: negatyw.s
	gcc -m32 -c -o negatyw.o negatyw.s

run:
	./main lena.bmp wynikbezMxx2.bmp
