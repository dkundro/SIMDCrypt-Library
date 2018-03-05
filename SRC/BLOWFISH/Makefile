CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/blowfish.o ../../OBJECTS/blowfishAsm.o

../../OBJECTS/blowfishAsm.o: blowfish.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/blowfish.o: blowfish.c
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
