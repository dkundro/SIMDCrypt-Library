CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha1.o ../../OBJECTS/sha1Asm.o

../../OBJECTS/sha1Asm.o: sha1.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha1.o: sha1.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
