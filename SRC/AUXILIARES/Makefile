CC=c99
CFLAGS= -Wall -Wextra -pedantic -Ofast -g -lm -Wno-unused-variable -Wno-unused-parameter

all: ../../OBJECTS/aux.o

../../OBJECTS/aux.o: aux.c 
	$(CC) -c $(CFLAGS) $^ -o $@
clean:
	rm -f *.o
