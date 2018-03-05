CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter

all: generateOutputC.o ../../generateOutputC

generateOutputC.o: generateOutputC.c 
	$(CC) -c $(CFLAGS) $^ -o $@

../../generateOutputC: 
	gcc -Wall -o ../../generateOutputC generateOutputC.o -L . -l simdcrypt
clean:
	rm -f *.o
