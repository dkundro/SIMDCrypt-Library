CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/aes.o ../../OBJECTS/aesAsm.o

../../OBJECTS/aesAsm.o: aes.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/aes.o: aes.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
