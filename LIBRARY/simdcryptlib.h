
#ifndef ___SIMDCRYPT_H___
#define ___SIMDCRYPT_H___

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Precond: (keyLength == 16) && (msgLength == 16 bytes) 
char* aes_encrypt128(const char* msg, const char* key);
char* aes_decrypt128(const char* msg, const char* key);

// Precond: (keyLength == 16) && (msgLength == 16 bytes) 
char* aes_encrypt128_ASCII(const char* msg, const char* key);
// Precond: (keyLength == 16) && (msgLength == 32 bytes) 
char* aes_decrypt128_ASCII(const char* msg, const char* key);

// Precond: (keyLength == 24) && (msgLength == 16 bytes) 
char* aes_encrypt192(const char* msg, const char* key);
char* aes_decrypt192(const char* msg, const char* key);

// Precond: (keyLength == 24) && (msgLength == 16 bytes) 
char* aes_encrypt192_ASCII(const char* msg, const char* key);
char* aes_decrypt192_ASCII(const char* msg, const char* key);

// Precond: (keyLength == 32) && (msgLength == 16 bytes) 
char* aes_encrypt256(const char* msg, const char* key);
// Precond: (keyLength == 24) && (msgLength == 32 bytes) 
char* aes_decrypt256(const char* msg, const char* key);

// Precond: (keyLength == 32) && (msgLength == 16 bytes) 
char* aes_encrypt256_ASCII(const char* msg, const char* key);
// Precond: (keyLength == 32) && (msgLength == 32 bytes) 
char* aes_decrypt256_ASCII(const char* msg, const char* key);

char* md5(const char* msg);
char* md5_ASCII(const char* msg);

char* sha1(const char* msg);
char* sha1_ASCII(const char* msg);

char* sha224(const char* msg);
char* sha224_ASCII(const char* msg);

char* sha256(const char* msg);
char* sha256_ASCII(const char* msg);

char* sha384(const char* msg);
char* sha384_ASCII(const char* msg);

char* sha512(const char* msg);
char* sha512_ASCII(const char* msg);

char* sha3_224(const char* msg);
char* sha3_224_ASCII(const char* msg);

char* sha3_256(const char* msg);
char* sha3_256_ASCII(const char* msg);

char* sha3_384(const char* msg);
char* sha3_384_ASCII(const char* msg);

char* sha3_512(const char* msg);
char* sha3_512_ASCII(const char* msg);

// Precond: (keyLength >= 4 bytes && keyLength <= 56 bytes) && (msgLength == 8 bytes) 
char* blowfish_encrypt(const char* msg, const char* key);
char* blowfish_decrypt(const char* msg, const char* key);

// Precond: (keyLength >= 4 bytes && keyLength <= 56 bytes) && (msgLength == 16 bytes) 
char* blowfish_encrypt_ASCII(const char* msg, const char* key);
char* blowfish_decrypt_ASCII(const char* msg, const char* key);


#endif

