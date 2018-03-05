#include "../AUXILIARES/aux.h"

#ifndef ___SHA256_H___
#define ___SHA256_H___

char* sha256(const char* msg);
char* sha256_ASCII(const char* msg);
extern char* sha256_ASM(const char* msg, unsigned long length);

#endif
