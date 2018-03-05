#include "../AUXILIARES/aux.h"

#ifndef ___SHA3_H___
#define ___SHA3_H___

char* sha3_224(const char* msg);
char* sha3_256(const char* msg);
char* sha3_384(const char* msg);
char* sha3_512(const char* msg);

char* sha3_224_ASCII(const char* msg);
char* sha3_256_ASCII(const char* msg);
char* sha3_384_ASCII(const char* msg);
char* sha3_512_ASCII(const char* msg);

char* padding_sha3(const char* msg, unsigned long length);

extern char* sha3_ASM(const char* msg, unsigned long length);

extern void setSHA3224();
extern void setSHA3256();
extern void setSHA3384();
extern void setSHA3512();

#endif
