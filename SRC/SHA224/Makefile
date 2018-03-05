CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha224.o ../../OBJECTS/sha224Asm.o

../../OBJECTS/sha224Asm.o: sha224.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha224.o: sha224.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
