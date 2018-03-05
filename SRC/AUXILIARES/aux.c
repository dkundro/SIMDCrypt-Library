#include "aux.h"

char hexAChar(unsigned int hex)//Recibe un numero hexadecimal y devuelve ese numero en formato ASCII
{
    char aux;
    if (hex <= 9)
        aux = hex + 48;
    else
        aux = hex + 87;
    return aux;
}

unsigned short charAHex(char c)//Recibe un caracter (0..9, a..f) y devuelve ese caracter en 
{
    unsigned short aux;
    if (c < 58)
        aux = c - 48;
    else
        aux = c - 87;
    return aux;
}

unsigned long lengthForPadding(const char* msg, int size, unsigned long lim, int initAdd, int origMsgSize)
//calcula la longitud del input luego de aplicar su padding correspondiente
{
    unsigned long length = strlen(msg);
    length += initAdd;
    while ((length * 8) % size != lim)
        length++;
    return length + origMsgSize;
}

char* hexToASCII(char* hex, int size)// recibe una cadena de numeros hexadecimales y la transforma en una cadena
			               // ASCII
{
    char* ASCII = malloc(size * 2 + 1);
    for (int i = 0; i < size; i++) // Paso a hexa
    {
        unsigned int a = (unsigned int)hex[i];
        ASCII[i * 2 + 1] = hexAChar((a << 28) >> 28);
        ASCII[i * 2] = hexAChar((a << 24) >> 28);
    }
    free(hex);
    ASCII[size * 2] = 0;

    return ASCII;
}

char* reduceASCIIToHex(const char* ascii, int size)//recibe un string ASCII donde dos caracteres representan un byte,
						   //luego, el string recibido se reduce a la mitad.
{
    char* redMsg = malloc(size / 2);
    for (int i = 0; i < size / 2; i++) // reduzco el mensaje, dos caracteres a uno (2 hexa = 1 byte)
        redMsg[i] = charAHex(ascii[i * 2]) * 16 + charAHex(ascii[i * 2 + 1]);
    return redMsg;
}

void fillWith(char* msg, char c, int from, int to)
{
    for (int i = from; i < to; i++)
        msg[i] = c;
}

void reOrder(char* input, int wordsNum, int wSize)//divide el input en words de tamaño wSize e invierte las mismas
{
    char aux;
    for (int i = 0; i < wSize / 2; i++)
        for (int j = 0; j < wordsNum; j++)
        {
            aux = input[wSize * j + i];
            input[wSize * j + i] = input[(wSize * (j + 1) - 1) - i];
            input[(wSize * (j + 1) - 1) - i] = aux;
        }
}

void appendLength(unsigned long* dir, unsigned long num)
{
    *dir = num;
    unsigned int* primeraMitad = (unsigned int*)dir;
    unsigned int* segundaMitad = (unsigned int*)dir + 1;
    unsigned int aux = *primeraMitad;
    *primeraMitad = *segundaMitad;
    *segundaMitad = aux;
}

void copyAndPrepare(char* newMsg, const char* origMsg, unsigned char separador, long length, int wSize)

{
    for (int i = 0; i < length / wSize; i++)//Copio las words invirtiendolas
    {
        int iAux = i * wSize;
        for (int j = 0; j < wSize; j++)
            newMsg[iAux + j] = origMsg[iAux + (wSize - 1 - j)];
    }
    for (int i = 0; i < wSize; i++)//Manejo los datos restantes que no completan una word
    {
        if (length % wSize == i)
        {
            int offset = (wSize - 1) - i;
            for (int j = 0; j < i; j++)
                newMsg[length + offset - j] = origMsg[length - i + j];
            newMsg[length + offset - i] = separador; //Agrego el separador
            for (int j = i + 1; j < wSize; j++)
                newMsg[length + offset - j] = 0; //Relleno con 0 hasta completar la word, dejandolo listo para terminar el padding
        }
    }
}

char* copyAndAddStringEnd(char* origMsg, int size)
{
   char* newMsg= malloc(size+1);
   for(int i=0; i<size;i++)
	newMsg[i]=origMsg[i];
   newMsg[size]=0;
   free(origMsg);
   return newMsg;
}
