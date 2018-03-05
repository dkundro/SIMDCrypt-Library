CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha3.o ../../OBJECTS/sha3Asm.o

../../OBJECTS/sha3Asm.o: sha3.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha3.o: sha3.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
