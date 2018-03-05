#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include "simdcryptlib.h"

enum algoritmo
{
    MD5,
    SHA1,
    SHA224,
    SHA256,
    SHA384,
    SHA512,
    SHA3_224,
    SHA3_256,
    SHA3_384,
    SHA3_512,
    AES_128,
    AES_192,
    AES_256,
    BLOWFISH,
    AES_128decipher,
    AES_192decipher,
    AES_256decipher,
    BLOWFISHdecipher
};

void applyFonFileContent(enum algoritmo alg, char* input, char* output);

int main(void)
{
    applyFonFileContent(SHA1, "Input/SHA1-Input.txt", "Output-C/SHA1-Output-C.txt");
    applyFonFileContent(MD5, "Input/MD5-Input.txt", "Output-C/MD5-Output-C.txt");
    applyFonFileContent(SHA256, "Input/SHA256-Input.txt", "Output-C/SHA256-Output-C.txt");
    applyFonFileContent(SHA224, "Input/SHA224-Input.txt", "Output-C/SHA224-Output-C.txt");
    applyFonFileContent(SHA384, "Input/SHA384-Input.txt", "Output-C/SHA384-Output-C.txt");
    applyFonFileContent(SHA512, "Input/SHA512-Input.txt", "Output-C/SHA512-Output-C.txt");
    applyFonFileContent(SHA3_224, "Input/SHA3_224-Input.txt", "Output-C/SHA3_224-Output-C.txt");
    applyFonFileContent(SHA3_256, "Input/SHA3_256-Input.txt", "Output-C/SHA3_256-Output-C.txt");
    applyFonFileContent(SHA3_384, "Input/SHA3_384-Input.txt", "Output-C/SHA3_384-Output-C.txt");
    applyFonFileContent(SHA3_512, "Input/SHA3_512-Input.txt", "Output-C/SHA3_512-Output-C.txt");
    applyFonFileContent(
        AES_128, "Input/AES_128cipher-Input.txt", "Output-C/AES_128cipher-Output-C.txt");
    applyFonFileContent(
        AES_192, "Input/AES_192cipher-Input.txt", "Output-C/AES_192cipher-Output-C.txt");
    applyFonFileContent(
        AES_256, "Input/AES_256cipher-Input.txt", "Output-C/AES_256cipher-Output-C.txt");
    applyFonFileContent(
        BLOWFISH, "Input/BLOWFISHcipher-Input.txt", "Output-C/BLOWFISHcipher-Output-C.txt");
    applyFonFileContent(AES_128decipher, "Input/AES_128decipher-Input.txt",
        "Output-C/AES_128decipher-Output-C.txt");
    applyFonFileContent(AES_192decipher, "Input/AES_192decipher-Input.txt",
        "Output-C/AES_192decipher-Output-C.txt");
    applyFonFileContent(AES_256decipher, "Input/AES_256decipher-Input.txt",
        "Output-C/AES_256decipher-Output-C.txt");
    applyFonFileContent(BLOWFISHdecipher, "Input/BLOWFISHdecipher-Input.txt",
        "Output-C/BLOWFISHdecipher-Output-C.txt");
}

void applyFonFileContent(enum algoritmo alg, char* input, char* output)
{
    FILE* fw = fopen(output, "w");
    if (fw == NULL)
    {
        printf("error\n");
        exit(1);
    }

    FILE* fp;
    char* line = NULL;
    char* line2 = NULL;
    char* line3 = NULL;
    size_t len = 0;
    ssize_t read;

    fp = fopen(input, "r");
    if (fp == NULL)
    {
        printf("error\n");
        exit(1);
    }

    char* res;
    while ((read = getline(&line, &len, fp)) != -1)
    {
        line[read - 1] = 0;

        if (alg == MD5)
            res = md5_ASCII(line);
        else if (alg == SHA1)
            res = sha1_ASCII(line);
        else if (alg == SHA256)
            res = sha256_ASCII(line);
        else if (alg == SHA224)
            res = sha224_ASCII(line);
        else if (alg == SHA384)
            res = sha384_ASCII(line);
        else if (alg == SHA512)
            res = sha512_ASCII(line);
        else if (alg == SHA3_224)
            res = sha3_224_ASCII(line);
        else if (alg == SHA3_256)
            res = sha3_256_ASCII(line);
        else if (alg == SHA3_384)
            res = sha3_384_ASCII(line);
        else if (alg == SHA3_512)
            res = sha3_512_ASCII(line);
        else if (alg == AES_128)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            res = aes_encrypt128_ASCII(line, line2);
        }
        else if (alg == AES_192)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            res = aes_encrypt192_ASCII(line, line2);
        }
        else if (alg == AES_256)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            res = aes_encrypt256_ASCII(line, line2);
        }
        else if (alg == BLOWFISH)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            res = blowfish_encrypt_ASCII(line, line2);
        }
        else if (alg == AES_128decipher)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            read = getline(&line3, &len, fp);
            line3[read - 1] = 0;
            res = aes_decrypt128_ASCII(line2, line3);
        }
        else if (alg == AES_192decipher)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            read = getline(&line3, &len, fp);
            line3[read - 1] = 0;
            res = aes_decrypt192_ASCII(line2, line3);
        }
        else if (alg == AES_256decipher)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            read = getline(&line3, &len, fp);
            line3[read - 1] = 0;
            res = aes_decrypt256_ASCII(line2, line3);
        }
        else if (alg == BLOWFISHdecipher)
        {
            read = getline(&line2, &len, fp);
            line2[read - 1] = 0;
            read = getline(&line3, &len, fp);
            line3[read - 1] = 0;
            res = blowfish_decrypt_ASCII(line2, line3);
        }
        fprintf(fw, "%s\n", res);
        free(res);
    }

    fclose(fw);
    fclose(fp);
    if (line)
        free(line);
}
