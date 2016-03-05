# reguła linkowania
prog: prog.o
	ld prog.o -o prog

# reguła kompilacji
prog.o: prog.s
	as prog.s -o prog.o

clean:
	rm -f *.o
run:
	./prog
