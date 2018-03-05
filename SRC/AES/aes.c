#include "aes.h"

char* aes_encrypt128(const char* msg, const char* key)
{
    setAES128();
    return encrypt(msg, key);
}

char* aes_encrypt128_ASCII(const char* msg, const char* key)
{
    char* msgCifrado = aes_encrypt128(msg, key);
    return hexToASCII(msgCifrado, 16);
}

char* aes_decrypt128(const char* msg, const char* key)
{
    setAES128();
    return decrypt(msg, key);
}

char* aes_decrypt128_ASCII(const char* msg, const char* key)
{
    char* redMsg = reduceASCIIToHex(msg, 32);
    char* msgDecifrado = aes_decrypt128(redMsg, key);
    return copyAndAddStringEnd(msgDecifrado, 16);
}

char* aes_encrypt256(const char* msg, const char* key)
{
    setAES256();
    return encrypt(msg, key);
}

char* aes_encrypt256_ASCII(const char* msg, const char* key)
{
    char* msgCifrado = aes_encrypt256(msg, key);
    return hexToASCII(msgCifrado, 16);
}

char* aes_decrypt256(const char* msg, const char* key)
{
    setAES256();
    return decrypt(msg, key);
}

char* aes_decrypt256_ASCII(const char* msg, const char* key)
{
    char* redMsg = reduceASCIIToHex(msg, 32);
    char* msgDecifrado = aes_decrypt256(redMsg, key);
    return copyAndAddStringEnd(msgDecifrado, 16);
}

char* aes_encrypt192(const char* msg, const char* key)
{
    setAES192();
    return encrypt(msg, key);
}

char* aes_encrypt192_ASCII(const char* msg, const char* key)
{
    char* msgCifrado = aes_encrypt192(msg, key);
    return hexToASCII(msgCifrado, 16);
}

char* aes_decrypt192(const char* msg, const char* key)
{
    setAES192();
    return decrypt(msg, key);
}

char* aes_decrypt192_ASCII(const char* msg, const char* key)
{
    char* redMsg = reduceASCIIToHex(msg, 32);
    char* msgDecifrado = aes_decrypt192(redMsg, key);
    return copyAndAddStringEnd(msgDecifrado, 16);
}



char* encrypt(const char* msg, const char* key)
{
    expandKey(key);
    char* msgCifrado = (char*)cipher(msg);
    return msgCifrado;
}

char* decrypt(const char* msg, const char* key)
{
    expandKey(key);
    char* msgDecifrado = decipher(msg);
    return msgDecifrado;
}
