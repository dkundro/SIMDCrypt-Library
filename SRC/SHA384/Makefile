CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/sha384.o ../../OBJECTS/sha384Asm.o

../../OBJECTS/sha384Asm.o: sha384.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/sha384.o: sha384.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
