# reguła linkowania
zad2: output.o zad2.o
	ld output.o zad2.o -o zad2

# reguła kompilacji
output.o: output.s
	as output.s -o output.o
zad2.o: zad2.c
	gcc zad2.c -o zad2.o
clean:
	rm -f *.o
run:
	./zad2
