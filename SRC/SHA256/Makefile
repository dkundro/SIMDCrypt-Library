CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha256.o ../../OBJECTS/sha256Asm.o

../../OBJECTS/sha256Asm.o: sha256.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha256.o: sha256.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
