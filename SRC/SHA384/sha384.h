#include "../AUXILIARES/aux.h"

#ifndef ___SHA384_H___
#define ___SHA384_H___

char* sha384(const char* msg);
char* sha384_ASCII(const char* msg);
extern char* sha384_ASM(const char* msg, unsigned long length);

#endif
