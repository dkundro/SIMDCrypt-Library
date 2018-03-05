#include "sha3.h"

char* sha3_224(const char* msg)
{
    unsigned long length = 0;
    if ((strlen(msg) + 1) * 8 % 1152 == 0)
        length = lengthForPadding(msg, 1152, 0, 1, 0);
    else
        length = lengthForPadding(msg, 1152, 0, 2, 0);
    char* newMsg = padding_sha3(msg, length);
    SHA3set224();
    char* hash = sha3_ASM(newMsg, (length * 8) / 1152);
    return hash; // el hash ocupa 28 bytes
}

char* sha3_256(const char* msg)
{
    unsigned long length = 0;
    if ((strlen(msg) + 1) * 8 % 1088 == 0)
        length = lengthForPadding(msg, 1088, 0, 1, 0);
    else
        length = lengthForPadding(msg, 1088, 0, 2, 0);
    char* newMsg = padding_sha3(msg, length);
    SHA3set256();
    char* hash = sha3_ASM(newMsg, (length * 8) / 1088);
    return hash; // el hash ocupa 32 bytes
}

char* sha3_384(const char* msg)
{
    unsigned long length = 0;
    if ((strlen(msg) + 1) * 8 % 832 == 0)
        length = lengthForPadding(msg, 832, 0, 1, 0);
    else
        length = lengthForPadding(msg, 832, 0, 2, 0);
    char* newMsg = padding_sha3(msg, length);
    SHA3set384();
    char* hash = sha3_ASM(newMsg, (length * 8) / 832);
    return hash; // el hash ocupa 48 bytes
}

char* sha3_512(const char* msg)
{
    unsigned long length = 0;
    if ((strlen(msg) + 1) * 8 % 576 == 0)
        length = lengthForPadding(msg, 576, 0, 1, 0);
    else
        length = lengthForPadding(msg, 576, 0, 2, 0);
    char* newMsg = padding_sha3(msg, length);
    SHA3set512();
    char* hash = sha3_ASM(newMsg, (length * 8) / 576);
    return hash; // el hash ocupa 64 bytes
}

char* sha3_224_ASCII(const char* msg)
{
    char* hash = sha3_224(msg);
    return hexToASCII(hash, 28);
}

char* sha3_256_ASCII(const char* msg)
{
    char* hash = sha3_256(msg);
    return hexToASCII(hash, 32);
}

char* sha3_384_ASCII(const char* msg)
{
    char* hash = sha3_384(msg);
    return hexToASCII(hash, 48);
}

char* sha3_512_ASCII(const char* msg)
{
    char* hash = sha3_512(msg);
    return hexToASCII(hash, 64);
}

char* padding_sha3(const char* msg, unsigned long length)
{
    // pido memoria para el mensaje ampliado
    unsigned char* newMsg = (unsigned char*)malloc(length);

    // copio el mensaje original
    long lengthAux = strlen(msg);
    for (int i = 0; i < lengthAux; i++)
        newMsg[i] = msg[i];

    // amplio el mensaje original con el padding
    if (length - lengthAux != 1)
    {
        fillWith((char*)newMsg, 0, lengthAux, length);
        newMsg[lengthAux] = 0x06;
        newMsg[length - 1] = 0x80;
    }
    else
        newMsg[length - 1] = 0x86;

    return (char*)newMsg;
}
