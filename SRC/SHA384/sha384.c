#include "sha384.h"

char* sha384(const char* msg)
{
    // length es la longitud del mensaje ampliado
    unsigned long length = lengthForPadding(msg, 1024, 896, 1, 16);

    // pido memoria para el mensaje ampliado
    char* newMsg = (char*)malloc(length);

    // amplio el mensaje original. Comienzo copiando el mensaje original de a quadwords
    // (invirtiendolas)
    long lengthAux = strlen(msg);
    copyAndPrepare(newMsg, msg, 0x80, lengthAux, 8);
    lengthAux += (8 - lengthAux % 8);

    // Relleno con 0s
    fillWith(newMsg, 0, lengthAux, length - 16);

    // agrego al final del mensaje extendido la longitud del mensaje original en bits de manera que
    // quede listo para ser utilizado por la funcion de hasheo en si
    unsigned long* dir = (unsigned long*)&newMsg[length - 16];
    *dir = 0;
    dir = (unsigned long*)&newMsg[length - 8];
    *dir = (strlen(msg) * 8);

    length *= 8; // paso la longitud del mensaje extendido de bytes a bits
    char* hash = sha384_ASM(newMsg, length);
    reOrder(hash, 6, 8);

    return hash;
}

char* sha384_ASCII(const char* msg)
{
    char* hash = sha384(msg);
    return hexToASCII(hash, 48);
}
