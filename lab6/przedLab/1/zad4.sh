#!/bin/bash

as -gstabs -o zad4.o zad4.s
gcc -o zad4 zad4.c zad4.o -lm

