CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: ../../OBJECTS/md5.o ../../OBJECTS/md5Asm.o

../../OBJECTS/md5Asm.o: md5.asm
	$(NASM) $(NASMFLAGS) $< -o $@

../../OBJECTS/md5.o: md5.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
