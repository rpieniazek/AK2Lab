# reguła linkowania
zad1: power.o zad1.o
	ld power.o zad1.o -o zad1

# reguła kompilacji
power.o: power.s
	as power.s -o power.o
zad1.o: zad1.s
	as zad1.s -o zad1.o
clean:
	rm -f *.o
run:
	./zad1
