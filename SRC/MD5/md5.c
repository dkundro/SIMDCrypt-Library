#include "md5.h"

char* md5(const char* msg)
{
    // length es la longitud del mensaje ampliado
    unsigned long length = lengthForPadding(msg, 512, 448, 1, 8);

    // pido memoria para el mensaje ampliado
    char* newMsg = (char*)malloc(length);

    // amplio el mensaje. Comienzo copiando el mensaje original
    long lengthAux = strlen(msg);
    for (int i = 0; i < lengthAux; i++)
        newMsg[i] = msg[i];
    newMsg[lengthAux] = (char)0x80; // se agrega al final del mensaje este char
    lengthAux++;

    // se rellena con 0s para el padding
    fillWith(newMsg, 0, lengthAux, length - 8);

    // agrego al final del mensaje extendido la longitud del mensaje original en bits
    unsigned long* l = (unsigned long*)&newMsg[length - 8];
    *l = strlen(msg) * 8;

    length = length * 8; // paso la longitud del mensaje extendido de bytes a bits
    char* hash = md5_ASM(newMsg, length);
    return hash;
}

char* md5_ASCII(const char* msg)
{
    char* hash = md5(msg);
    return hexToASCII(hash, 16);
}
