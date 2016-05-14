#!/bin/bash

as -gstabs -o zad1.o zad1.s
gcc -o zad1 zad1.c zad1.o

