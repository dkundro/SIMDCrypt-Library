#include "../AUXILIARES/aux.h"

#ifndef ___MD5_H___
#define ___MD5_H___

char* md5(const char* msg);
char* md5_ASCII(const char* msg);
extern char* md5_ASM(const char* msg, unsigned long length);

#endif
