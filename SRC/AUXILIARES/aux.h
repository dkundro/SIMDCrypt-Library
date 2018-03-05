#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef ___AUX_H___
#define ___AUX_H___

char hexAChar(unsigned int hex);
unsigned short charAHex(char c);
unsigned long lengthForPadding(const char* msg, int size, unsigned long lim, int initAdd, int msgSize);
char* hexToASCII(char* hex, int size);
char* reduceASCIIToHex(const char* ascii, int size);
void reOrder(char* hash, int xWords, int wSize);
unsigned long reverse(unsigned long num);
void copyAndPrepare(char* newMsg, const char* origMsg, unsigned char separador, long length, int wSize);
char* copyAndAddStringEnd(char* origMsg, int size);

#endif
