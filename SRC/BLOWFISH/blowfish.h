#include "../AUXILIARES/aux.h"

#ifndef ___BLOWFISH_H___
#define ___BLOWFISH_H___

// Precond: (keyLength >= 4 bytes && keyLength <= 56 bytes) && (msgLength == 8 bytes) 
char* blowfish_encrypt(const char* msg, const char* key);
char* blowfish_decrypt(const char* msg, const char* key);

// Precond: (keyLength >= 4 bytes && keyLength <= 56 bytes) && (msgLength == 16 bytes) 
char* blowfish_encrypt_ASCII(const char* msg, const char* key);
char* blowfish_decrypt_ASCII(const char* msg, const char* key);

char* blowfish_decrypt_aux(char* msg, const char* key);

extern char* blowfishEncrypt_ASM(char* msg, unsigned long length, char* key);
extern char* blowfishDecrypt_ASM(char* msg, unsigned long length, char* key);

void extendKey(char* extKey, const char* key, unsigned int keyLength);

#endif
