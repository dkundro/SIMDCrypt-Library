CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha512.o ../../OBJECTS/sha512Asm.o

../../OBJECTS/sha512Asm.o: sha512.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha512.o: sha512.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
