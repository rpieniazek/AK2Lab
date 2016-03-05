# reguła linkowania
zad3: power.o zad3.o
	ld power.o zad3.o -o zad3

# reguła kompilacji
power.o: power.s
	as power.s -o power.o
zad3.o: zad3.c
	gcc zad3.c -o zad3.o
clean:
	rm -f *.o
run:
	./zad3
