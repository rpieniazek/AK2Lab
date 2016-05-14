#!/bin/bash

as -gstabs -o zad3.o zad3.s
gcc -o zad3 zad3.c zad3.o

