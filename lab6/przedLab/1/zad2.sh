#!/bin/bash

as -gstabs -o zad2.o zad2.s
gcc -o zad2 zad2.c zad2.o -lm

