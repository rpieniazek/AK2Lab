# reguła linkowania
stos: stos.o
	ld stos.o -o stos

# reguła kompilacji
stos.o: stos.s
	as stos.s -o stos.o

clean:
	rm -f *.o
run:
	./stos
