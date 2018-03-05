#include "blowfish.h"

char* blowfish_encrypt(const char* msg, const char* key)
{
    unsigned int keyLength = strlen(key); // longitud de la password
    char* extendedKey = malloc(72); // pido memoria para extender la clave a 576 bits (72 bytes)

    // Extiendo la clave
    extendKey(extendedKey, key, keyLength);

    // Extiendo el mensaje
    int msgLength = strlen(msg);
    while (msgLength % 8 != 0)
        msgLength++;
    char* extendedMsg = malloc(msgLength);
    for (unsigned int i = 0; i < strlen(msg); i++)
        extendedMsg[i] = msg[i];
    fillWith(
        extendedMsg, 0, strlen(msg), msgLength); // Padding con 0 hasta completar una longitud%8==0

    // Reordeno el mensaje
    reOrder(extendedMsg, 2, 4);

    // Encripto el mensaje extendido con la clave extendida
    blowfishEncrypt_ASM(extendedMsg, msgLength * 8, extendedKey);

    // Reordeno el mensaje ya encriptado
    reOrder(extendedMsg, 2, 4);

    return extendedMsg;
}

char* blowfish_encrypt_ASCII(const char* msg, const char* key)
{
    char* msgCifrado = blowfish_encrypt(msg, key);
    return hexToASCII(msgCifrado, 8);
}

char* blowfish_decrypt(const char* msg, const char* key)
{
    char* newMsg = malloc(8);
    for (int i = 0; i < 8; i++)
        newMsg[i] = msg[i];
    return blowfish_decrypt_aux(newMsg, key);
}

char* blowfish_decrypt_ASCII(const char* msg, const char* key)
{
    char* newMsg = malloc(9);
    for (int i = 0; i < 8; i++)
        newMsg[i] = charAHex(msg[i * 2]) * 16 + charAHex(msg[i * 2 + 1]);
    blowfish_decrypt_aux(newMsg, key);
    newMsg[8] = 0;
    return newMsg;
}

char* blowfish_decrypt_aux(char* msg, const char* key)
{
    unsigned int keyLength = strlen(key); // longitud de la password
    char* extendedKey = malloc(72); // pido memoria para extender la clave a 576 bits (72 bytes)

    // Extiendo la clave
    extendKey(extendedKey, key, keyLength);

    // Reacomodo el mensaje encriptado
    reOrder(msg, 2, 4);

    // Desencripto el mensaje con la clave extendida
    blowfishDecrypt_ASM(msg, 64, extendedKey);

    // Reacomodo el mensaje ya desencriptado
    reOrder(msg, 2, 4);

    return msg;
}

void extendKey(char* extKey, const char* key, unsigned int keyLength)
{
    for (int i = 0; i < 72; i++)
        extKey[i] = key[i % keyLength];

    for (int i = 0; i < 18; i++)
    {
        char aux = extKey[i * 4 + 3];
        extKey[i * 4 + 3] = extKey[i * 4];
        extKey[i * 4] = aux;
        aux = extKey[i * 4 + 2];
        extKey[i * 4 + 2] = extKey[i * 4 + 1];
        extKey[i * 4 + 1] = aux;
    }
}
