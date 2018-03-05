#include "sha256.h"

char* sha256(const char* msg)
{
    // length es la longitud del mensaje ampliado
    unsigned long length = lengthForPadding(msg, 512, 448, 1, 8);

    // pido memoria para el mensaje ampliado
    char* newMsg = (char*)malloc(length);

    // amplio el mensaje original. Comienzo copiando el mensaje original de a double-words
    // (invirtiendolas)
    long lengthAux = strlen(msg);
    copyAndPrepare(newMsg, msg, 0x80, lengthAux, 4);
    lengthAux += (4 - lengthAux % 4);

    // Relleno con 0s
    fillWith(newMsg, 0, lengthAux, length - 8);

    // agrego al final del mensaje extendido la longitud del mensaje original en bits de manera que
    // quede listo para ser utilizado por la funcion de hasheo en si
    appendLength((unsigned long*)&newMsg[length - 8], (unsigned long)(strlen(msg) * 8));

    length *= 8; // paso la longitud del mensaje extendido de bytes a bits
    char* hash = sha256_ASM(newMsg, length);
    reOrder(hash, 8, 4);

    return hash;
}

char* sha256_ASCII(const char* msg)
{
    char* hash = sha256(msg);
    return hexToASCII(hash, 32);
}
