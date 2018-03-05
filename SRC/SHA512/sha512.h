#include "../AUXILIARES/aux.h"

#ifndef ___SHA512_H___
#define ___SHA512_H___

char* sha512(const char* msg);
char* sha512_ASCII(const char* msg);
extern char* sha512_ASM(const char* msg, unsigned long length);

#endif
