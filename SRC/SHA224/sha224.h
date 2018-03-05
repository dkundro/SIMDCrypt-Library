#include "../AUXILIARES/aux.h"

#ifndef ___SHA224_H___
#define ___SHA224_H___

char* sha224(const char* msg);
char* sha224_ASCII(const char* msg);
extern char* sha224_ASM(const char* msg, unsigned long length);

#endif
