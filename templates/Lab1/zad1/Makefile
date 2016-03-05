# reguła linkowania
link: link.o
	gcc -std=c99 link.o

# reguła kompilacji
link.o: link.s
	as -o link.o link.s

clean:
	rm -f *.o

run:
	./a.out
