# reguła linkowania
cross: cross.o
	gcc -g cross.o

# reguła kompilacji
cross.o: cross.s
	as -g -o cross.o  cross.s

clean:
	rm -f *.o
run:
	./a.out
