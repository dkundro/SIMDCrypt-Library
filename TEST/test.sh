#!/bin/bash
# Script para automatizar el testeo
echo "TESTING:"
echo "Generando casos de test"
eval "java -jar testGenerator.jar 150000"
echo "Generando resultados correctos"
eval "java -jar generateOutputJava.jar"
echo "Generando resultados utilizando SIMDCRYPT Lib"
eval "./generateOutputC"
echo "Verificando resultados obtenidos"
eval "java -jar checkFilesEqual.jar"
