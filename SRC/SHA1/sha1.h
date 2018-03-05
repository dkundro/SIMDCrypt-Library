#include "../AUXILIARES/aux.h"

#ifndef ___SHA1_H___
#define ___SHA1_H___

char* sha1(const char* msg);
char* sha1_ASCII(const char* msg);
extern char* sha1_ASM(const char* msg, unsigned long length);

#endif
