#include "../AUXILIARES/aux.h"

#ifndef ___AES_H___
#define ___AES_H___

extern char* cipher(const char* msg);
extern char* decipher(const char* msgCifrado);
extern char* expandKey(const char* key);

extern void setAES128();
extern void setAES192();
extern void setAES256();

// Precond: (keyLength == 16) && (msgLength == 16 bytes) 
char* aes_encrypt128(const char* msg, const char* key);
char* aes_decrypt128(const char* msg, const char* key);

// Precond: (keyLength == 24) && (msgLength == 16 bytes) 
char* aes_encrypt192(const char* msg, const char* key);
char* aes_decrypt192(const char* msg, const char* key);

// Precond: (keyLength == 32) && (msgLength == 16 bytes) 
char* aes_encrypt256(const char* msg, const char* key);
char* aes_decrypt256(const char* msg, const char* key);

char* aes_encrypt128_ASCII(const char* msg, const char* key);// Precond: (keyLength == 16) && (msgLength == 16 bytes) 
char* aes_decrypt128_ASCII(const char* msg, const char* key);// Precond: (keyLength == 16) && (msgLength == 32 bytes) 

char* aes_encrypt192_ASCII(const char* msg, const char* key);// Precond: (keyLength == 24) && (msgLength == 16 bytes) 
char* aes_decrypt192_ASCII(const char* msg, const char* key);// Precond: (keyLength == 24) && (msgLength == 32 bytes) 

char* aes_encrypt256_ASCII(const char* msg, const char* key);// Precond: (keyLength == 32) && (msgLength == 16 bytes) 
char* aes_decrypt256_ASCII(const char* msg, const char* key);// Precond: (keyLength == 32) && (msgLength == 32 bytes) 

char* encrypt(const char* msg, const char* key);
char* decrypt(const char* msg, const char* key);

#endif
