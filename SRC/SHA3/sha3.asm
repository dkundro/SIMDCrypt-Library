global sha3_ASM, SHA3set224, SHA3set256, SHA3set384, SHA3set512

extern malloc
extern free

section .rodata

	RC: dq 	0x0000000000000001, 0x0000000000008082, 0x800000000000808A, 0x8000000080008000,\
		0x000000000000808B, 0x0000000080000001, 0x8000000080008081,	0x8000000000008009,\
		0x000000000000008A, 0x0000000000000088, 0x0000000080008009,	0x000000008000000A,\
		0x000000008000808B, 0x800000000000008B, 0x8000000000008089,	0x8000000000008003,\
		0x8000000000008002, 0x8000000000000080, 0x000000000000800A, 0x800000008000000A,\
		0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008
	
	rotOffset: db 	0, 1, 62, 28, 27,\
			36, 44, 6, 55, 20,\
			3, 10, 43, 25, 39,\
			41, 45, 15, 21, 8,\
			18, 2, 61, 56, 14
	
section .data
	
	PiSizeBits: dq 0	
	PiSizeBytes: dq 0
	hashSize: dq 0
	
section .text

SHA3set224:
	MOV RAX, 144
	MOV [PiSizeBits], RAX
	MOV RAX, 18
	MOV [PiSizeBytes], RAX
	MOV RAX, 28
	MOV [hashSize], RAX
ret 

SHA3set256:
	MOV RAX, 136
	MOV [PiSizeBits], RAX
	MOV RAX, 17
	MOV [PiSizeBytes], RAX
	MOV RAX, 32
	MOV [hashSize], RAX
ret 

SHA3set384:
	MOV RAX, 104
	MOV [PiSizeBits], RAX
	MOV RAX, 13
	MOV [PiSizeBytes], RAX
	MOV RAX, 48
	MOV [hashSize], RAX
ret 

SHA3set512:
	MOV RAX, 72
	MOV [PiSizeBits], RAX
	MOV RAX, 9
	MOV [PiSizeBytes], RAX
	MOV RAX, 64
	MOV [hashSize], RAX
ret

sha3_ASM:
	PUSH R13
	PUSH R14
	PUSH R15
	; RDI puntero al mensaje
	; RSI longitud del mensaje en cantidad de bloques Pi

	MOV R14, RDI
	MOV R13, RSI
	MOV RDI, 200
	CALL malloc
	MOV R15, RAX
	MOV RDI, RAX

	; Inicializacion del arreglo state
	CALL initialize

	; calculo el hash utilizando el algoritmo keccak
	MOV RDI, R14
	MOV RSI, R13
	MOV RDX, R15
	CALL keccak
	
	MOV RDI, RAX

	; a partir del resultado de la funcion anterior, preparo el hash final que sera devuelto
	CALL prepareHash
	PUSH RAX

	;libero la memoria correspondiente al mensaje ampliado con el padding
	MOV RDI, R14
	SUB RSP, 8
	CALL free
	ADD RSP, 8
	
	POP RAX
	
	POP R15
	POP R14
	POP R13
ret

prepareHash:
	PUSH R13
	PUSH R14
	PUSH R15

	;RDI direccion del arreglo state del cual saldra el hash final
	MOV R15, RDI
	MOV RDI, [hashSize]
	MOV R13, RDI
	CALL malloc
	MOV R14, RAX
	
	;R13 tamaño de hash con el que estoy operando
	;R14 direccion del hash final
	;R15 direccion del arreglo state

	CMP R13, 28
	JNE .256

		MOVDQU XMM0, [R15]
		MOV R8, [R15+16]
		MOV ECX, [R15+24]
		MOVDQU [R14], XMM0
		MOV [R14+16], R8
		MOV [R14+24], ECX

	JMP .fin
	.256:
		CMP R13, 32
		JNE .384

		VMOVDQU YMM0, [R15]
		VMOVDQU [R14], YMM0

		JMP .fin
	.384:
		CMP R13, 48
		JNE .512

		MOVDQU XMM0, [R15]
		MOVDQU XMM1, [R15+16]
		MOVDQU XMM2, [R15+32]

		MOVDQU [R14], XMM0
		MOVDQU [R14+16], XMM1
		MOVDQU [R14+32], XMM2

		JMP .fin
	.512:
		VMOVDQU YMM0, [R15]
		VMOVDQU YMM1, [R15+32]
		VMOVDQU [R14], YMM0
		VMOVDQU [R14+32], YMM1

	.fin:
	;libero la memoria correspondiente al arreglo state
	MOV RDI, R15
	CALL free
	MOV RAX, R14

	POP R15
	POP R14
	POP R13
ret

keccak:
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	SUB RSP, 8

	MOV R15, RDX
	MOV R14, RDI
	MOV R13, RSI

	;R15 direccion del arreglo state (S)
	;R14 direccion de Pi
	;R13 cantidad de bloques Pi
	
	MOV R12, 0
	.cicloBloques:
		CMP R12, R13	
		JE .finCicloBloques

		MOV R10, 0
		.cicloX:
			CMP R10, 5
			JE .finCicloX
	
			MOV R11, 0
			.cicloY:	
				CMP R11, 5
				JE .finCicloY

				XOR R9, R9
				IMUL R9, R11, 5
				ADD R9, R10; x+5*y
				CMP R9, [PiSizeBytes]; 
				JNB .noMenor
				
				IMUL RAX, R10, 8
				IMUL RCX, R11, 40
				ADD RAX, RCX; [x,y]	
				IMUL RCX, R9, 8; [x+5*y]
			
				MOV RDX, [R15+RAX]; S[x,y]
				MOV R8, [R14+RCX]; Pi[x+5*y]
				XOR RDX, R8; S[x,y] XOR Pi[x+5*y]
			
				MOV [R15+RAX], RDX; S[x,y] = S[x,y] XOR Pi[x+5*y]

				.noMenor:

				INC R11 
				JMP .cicloY
			.finCicloY:	
		
			INC R10
			JMP .cicloX
		.finCicloX:	
		MOV RDI, R15

		CALL keccakF
		
		INC R12
		ADD R14, [PiSizeBits]; 
		JMP .cicloBloques	
	.finCicloBloques:

	MOV RAX, R15

	ADD RSP, 8
	POP R15
	POP R14
	POP R13
	POP R12
ret

keccakF:
	; RDI: A
	PUSH R12
	PUSH R13
	SUB RSP, 8

	MOV R12, RDI

	MOV R13, 0
	.ciclo:
		CMP R13, 24; 24 rounds al estar usando Keccak-f[1600]
		JE .finCiclo

		IMUL RAX, R13, 8
		MOV RSI, [RC+RAX]	
		MOV RDI, R12	

		CALL round; RDI: A, RSI: i

		INC R13
		JMP .ciclo
	.finCiclo:

	ADD RSP, 8
	POP R13
	POP R12
ret

initialize:
	PXOR XMM0, XMM0
	XOR R10, R10

	MOVDQU [RDI], XMM0
	MOVDQU [RDI+16], XMM0	 	
	MOVDQU [RDI+16*2], XMM0	
	MOVDQU [RDI+16*3], XMM0	
	MOVDQU [RDI+16*4], XMM0	
	MOVDQU [RDI+16*5], XMM0	
	MOVDQU [RDI+16*6], XMM0	
	MOVDQU [RDI+16*7], XMM0	
	MOVDQU [RDI+16*8], XMM0	
	MOVDQU [RDI+16*9], XMM0	
	MOVDQU [RDI+16*10], XMM0	
	MOVDQU [RDI+16*11], XMM0	
	MOV [RDI+16*12], R10	
ret

round:
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	PUSH RBX

	MOV R12, RDI
	PUSH RSI
	SUB RSP, 8

	;pido memoria para los arreglos auxiliares C y D
	MOV RDI, 40 ; 5 quadwords (5*8)
	CALL malloc
	MOV R14, RAX
	MOV RDI, 40
	CALL malloc
	MOV R15, RAX
	;pido memoria para la matriz B
	MOV RDI, 200
	CALL malloc
	MOV R13, RAX
	
	ADD RSP, 8
	;R12 dir de A
	;R13 dir de B
	;R14 dir de C
	;R15 dir de D

	;Comienzo a preparar C
	;Cargo las primeras 4 qwords de cada fila para luego hacer XOR entre ellas. La quinta qword es manejada por separado

	MOVDQU XMM0, [R12]
	MOVDQU XMM1, [R12+16]
	MOVDQU XMM2, [R12+40]
	MOVDQU XMM3, [R12+40+16]
	MOVDQU XMM4, [R12+40*2]
	MOVDQU XMM5, [R12+40*2+16]
	MOVDQU XMM6, [R12+40*3]
	MOVDQU XMM7, [R12+40*3+16]
	MOVDQU XMM8, [R12+40*4]
	MOVDQU XMM9, [R12+40*4+16]

	PXOR XMM0, XMM2
	PXOR XMM0, XMM4
	PXOR XMM0, XMM6
	PXOR XMM0, XMM8

	PXOR XMM1, XMM3
	PXOR XMM1, XMM5
	PXOR XMM1, XMM7
	PXOR XMM1, XMM9

	MOV R10, [R12+32]
	MOV R11, [R12+40+32]
	XOR R10, R11
	MOV R11, [R12+40*2+32]
	XOR R10, R11
	MOV R11, [R12+40*3+32]
	XOR R10, R11
	MOV R11, [R12+40*4+32]
	XOR R10, R11

	;guardo los valores en C
	MOVDQU [R14], XMM0
	MOVDQU [R14+16], XMM1
	MOV [R14+32], R10

	;preparo D
	;cargo partes de C para preparar D

	MOVDQU XMM0, [R14+8] ; cargo 1 2 
	;roto 1 bit hacia la derecha
	MOVDQU XMM1, XMM0
	PSLLQ XMM0, 1
	PSRLQ XMM1, 63
	POR XMM0, XMM1

	MOVDQU XMM2, [R14+24] ; cargo 3 4 
	;roto 1 bit hacia la derecha
	MOVDQU XMM3, XMM2
	PSLLQ XMM2, 1
	PSRLQ XMM3, 63
	POR XMM2, XMM3

	MOV R10, [R14]; cargo 0
	;roto 1 bit hacia la derecha
	MOV R11, R10
	SHL R10, 1 
	SHR R11, 63
	OR R10, R11

	;guardo en D la parte ya calculada (D[x]=rot(C[x+1],1))
	MOVDQU [R15], XMM0
	MOVDQU [R15+16], XMM2
	MOV [R15+32], R10

	; cargo 0 1 2 y 3 de C y 2 3 4 0 ya rotadas de D para hacer XOR entre ellas y guardar el resultado en D
	MOVDQU XMM0, [R14]
	MOVDQU XMM1, [R14+16]
	MOVDQU XMM2, [R15+8]
	MOVDQU XMM3, [R15+24]
	PXOR XMM0, XMM2
	PXOR XMM1, XMM3
	MOVDQU [R15+8], XMM0
	MOVDQU [R15+24], XMM1

	; XOR de la parte 0 de D y la parte 4 de C
	MOV R10, [R15]
	MOV R11, [R14+8*4]
	XOR R10, R11
	MOV [R15], R10

	; cargo las primeras 4 qwords de D y comienzo a hacer XOR con las primeras 4 columnas de cada fila de la matriz A
	MOVDQU XMM0, [R15]
	MOVDQU XMM1, [R15+16]

	MOVDQU XMM2, [R12]
	MOVDQU XMM3, [R12+16]
	PXOR XMM2, XMM0
	PXOR XMM3, XMM1
	MOVDQU [R12], XMM2
	MOVDQU [R12+16], XMM3

	MOVDQU XMM2, [R12+40]
	MOVDQU XMM3, [R12+40+16]
	PXOR XMM2, XMM0
	PXOR XMM3, XMM1
	MOVDQU [R12+40], XMM2
	MOVDQU [R12+40+16], XMM3

	MOVDQU XMM2, [R12+40*2]
	MOVDQU XMM3, [R12+40*2+16]
	PXOR XMM2, XMM0
	PXOR XMM3, XMM1
	MOVDQU [R12+40*2], XMM2
	MOVDQU [R12+40*2+16], XMM3

	MOVDQU XMM2, [R12+40*3]
	MOVDQU XMM3, [R12+40*3+16]
	PXOR XMM2, XMM0
	PXOR XMM3, XMM1
	MOVDQU [R12+40*3], XMM2
	MOVDQU [R12+40*3+16], XMM3

	MOVDQU XMM2, [R12+40*4]
	MOVDQU XMM3, [R12+40*4+16]
	PXOR XMM2, XMM0
	PXOR XMM3, XMM1
	MOVDQU [R12+40*4], XMM2
	MOVDQU [R12+40*4+16], XMM3

	MOV R10, [R15+32]; cargo la ultima qword de D para hacer XOR con la quinta columna de A

	MOV R11, [R12+32]
	XOR R11, R10
	MOV [R12+32], R11

	MOV R11, [R12+32+40]
	XOR R11, R10
	MOV [R12+32+40], R11

	MOV R11, [R12+32+40*2]
	XOR R11, R10
	MOV [R12+32+40*2], R11

	MOV R11, [R12+32+40*3]
	XOR R11, R10
	MOV [R12+32+40*3], R11

	MOV R11, [R12+32+40*4]
	XOR R11, R10
	MOV [R12+32+40*4], R11

	;Preparo B

	MOV R9, 0
	.cicloX:
		CMP R9, 5
		JE .finCicloX

		MOV RBX,0
		.cicloY:
			CMP RBX, 5
			JE .finCicloY

			IMUL RDX, R9, 8
			IMUL RSI, RBX, 40
			ADD RDX, RSI
			MOV R10, [R12+RDX]; A[X][Y]
		
			IMUL RSI, RBX, 5
			MOV RDX, R9
			ADD RDX, RSI
			MOV R11, [rotOffset+RDX]; r[X][Y]

			MOV RCX, R11
			MOV R11, R10
			SHL R10, CL
			MOV R8, 64
			SUB R8, RCX
			MOV RCX, R8
			SHR R11, CL
			OR R10, R11

			IMUL RAX, R9, 2
			IMUL RDX, RBX, 3
			ADD RAX, RDX

			MOV CL, 5
			DIV CL

			;AH tiene el resto de la division
			XOR RCX, RCX
			MOV CL, AH
				
			IMUL RDX, RCX, 40
			IMUL RSI, RBX, 8
			ADD RDX, RSI

			MOV [R13+RDX], R10; B[y,2*x+3*y] = rot(A[x,y], r[x,y])
					

			INC RBX
			JMP .cicloY	
		.finCicloY:

		INC R9
		JMP .cicloX
	.finCicloX:

	;Paso X (chi)
	;X de 1 a 5

	MOVDQU XMM0, [R13];    [   0   |   1   ] (B[X])
	MOVDQU XMM1, [R13+16]; [   2   |   3   ] (B[X])

	MOVDQU XMM2, [R13+8];  [   1   |   2   ] (B[X+1])
	MOVDQU XMM3, [R13+24]; [   3   |   4   ] (B[X+1])

	PCMPEQB XMM4, XMM4

	PXOR XMM2, XMM4; NOT B[X+1]
	PXOR XMM3, XMM4; NOT B[X+1]

	MOVDQU XMM5, [R13+16]; [   2   |   3   ] (B[x+2,0])

	PINSRQ XMM6, [R13+32], 0 ; [   4   |   X   ] 
	PINSRQ XMM6, [R13], 1 ; [   4   |   0   ] (B[x+2,0])

	PAND XMM2, XMM5; ((not B[x+1,0]) and B[x+2,0])
	PAND XMM3, XMM6

	PXOR XMM0, XMM2; B[x,0] XOR ((not B[x+1,0]) and B[x+2,0])
	PXOR XMM1, XMM3

	MOV R10, [R13]; B[x+1,0]
	NOT R10; (not B[x+1,0])
	MOV R11, [R13+8];
	AND R10, R11
	MOV R11, [R13+32]
	XOR R10, R11

	MOVDQU [R12], XMM0 ; A[x,y] = B[x,y] XOR ((not B[x+1,y]) and B[x+2,y])
	MOVDQU [R12+16], XMM1
	MOV [R12+32], R10

	; X de 6 a 10

	MOVDQU XMM0, [R13+40];    [   0   |   1   ] (B[X])
	MOVDQU XMM1, [R13+40+16]; [   2   |   3   ] (B[X])

	MOVDQU XMM2, [R13+40+8];  [   1   |   2   ] (B[X+1])
	MOVDQU XMM3, [R13+40+24]; [   3   |   4   ] (B[X+1])

	PXOR XMM2, XMM4; NOT B[X+1]
	PXOR XMM3, XMM4; NOT B[X+1]

	MOVDQU XMM5, [R13+40+16]; [   2   |   3   ] (B[x+2,0])

	PINSRQ XMM6, [R13+40+32], 0 ; [   4   |   X   ] 
	PINSRQ XMM6, [R13+40], 1 ; [   4   |   0   ] (B[x+2,0])

	PAND XMM2, XMM5; ((not B[x+1,0]) and B[x+2,0])
	PAND XMM3, XMM6

	PXOR XMM0, XMM2; B[x,0] XOR ((not B[x+1,0]) and B[x+2,0])
	PXOR XMM1, XMM3

	MOV R10, [R13+40]; B[x+1,0]
	NOT R10; (not B[x+1,0])
	MOV R11, [R13+40+8];
	AND R10, R11
	MOV R11, [R13+40+32]
	XOR R10, R11

	MOVDQU [R12+40], XMM0 ; A[x,y] = B[x,y] XOR ((not B[x+1,y]) and B[x+2,y])
	MOVDQU [R12+40+16], XMM1
	MOV [R12+40+32], R10

	; X de 11 a 15

	MOVDQU XMM0, [R13+40*2];    [   0   |   1   ] (B[X])
	MOVDQU XMM1, [R13+40*2+16]; [   2   |   3   ] (B[X])

	MOVDQU XMM2, [R13+40*2+8];  [   1   |   2   ] (B[X+1])
	MOVDQU XMM3, [R13+40*2+24]; [   3   |   4   ] (B[X+1])

	PXOR XMM2, XMM4; NOT B[X+1]
	PXOR XMM3, XMM4; NOT B[X+1]

	MOVDQU XMM5, [R13+40*2+16]; [   2   |   3   ] (B[x+2,0])

	PINSRQ XMM6, [R13+40*2+32], 0 ; [   4   |   X   ] 
	PINSRQ XMM6, [R13+40*2], 1 ; [   4   |   0   ] (B[x+2,0])

	PAND XMM2, XMM5; ((not B[x+1,0]) and B[x+2,0])
	PAND XMM3, XMM6

	PXOR XMM0, XMM2; B[x,0] XOR ((not B[x+1,0]) and B[x+2,0])
	PXOR XMM1, XMM3

	MOV R10, [R13+40*2]; B[x+1,0]
	NOT R10; (not B[x+1,0])
	MOV R11, [R13+40*2+8];
	AND R10, R11
	MOV R11, [R13+40*2+32]
	XOR R10, R11

	MOVDQU [R12+40*2], XMM0 ; A[x,y] = B[x,y] XOR ((not B[x+1,y]) and B[x+2,y])
	MOVDQU [R12+40*2+16], XMM1
	MOV [R12+40*2+32], R10

	; X de 16 a 20 

	MOVDQU XMM0, [R13+40*3];    [   0   |   1   ] (B[X])
	MOVDQU XMM1, [R13+40*3+16]; [   2   |   3   ] (B[X])

	MOVDQU XMM2, [R13+40*3+8];  [   1   |   2   ] (B[X+1])
	MOVDQU XMM3, [R13+40*3+24]; [   3   |   4   ] (B[X+1])

	PXOR XMM2, XMM4; NOT B[X+1]
	PXOR XMM3, XMM4; NOT B[X+1]

	MOVDQU XMM5, [R13+40*3+16]; [   2   |   3   ] (B[x+2,0])

	PINSRQ XMM6, [R13+40*3+32], 0 ; [   4   |   X   ] 
	PINSRQ XMM6, [R13+40*3], 1 ; [   4   |   0   ] (B[x+2,0])

	PAND XMM2, XMM5; ((not B[x+1,0]) and B[x+2,0])
	PAND XMM3, XMM6

	PXOR XMM0, XMM2; B[x,0] XOR ((not B[x+1,0]) and B[x+2,0])
	PXOR XMM1, XMM3

	MOV R10, [R13+40*3]; B[x+1,0]
	NOT R10; (not B[x+1,0])
	MOV R11, [R13+40*3+8];
	AND R10, R11
	MOV R11, [R13+40*3+32]
	XOR R10, R11

	MOVDQU [R12+40*3], XMM0 ; A[x,y] = B[x,y] XOR ((not B[x+1,y]) and B[x+2,y])
	MOVDQU [R12+40*3+16], XMM1
	MOV [R12+40*3+32], R10

	; X de 21 a 25 

	MOVDQU XMM0, [R13+40*4];    [   0   |   1   ] (B[X])
	MOVDQU XMM1, [R13+40*4+16]; [   2   |   3   ] (B[X])

	MOVDQU XMM2, [R13+40*4+8];  [   1   |   2   ] (B[X+1])
	MOVDQU XMM3, [R13+40*4+24]; [   3   |   4   ] (B[X+1])

	PXOR XMM2, XMM4; NOT B[X+1]
	PXOR XMM3, XMM4; NOT B[X+1]

	MOVDQU XMM5, [R13+40*4+16]; [   2   |   3   ] (B[x+2,0])

	PINSRQ XMM6, [R13+40*4+32], 0 ; [   4   |   X   ] 
	PINSRQ XMM6, [R13+40*4], 1 ; [   4   |   0   ] (B[x+2,0])

	PAND XMM2, XMM5; ((not B[x+1,0]) and B[x+2,0])
	PAND XMM3, XMM6

	PXOR XMM0, XMM2; B[x,0] XOR ((not B[x+1,0]) and B[x+2,0])
	PXOR XMM1, XMM3

	MOV R10, [R13+40*4]; B[x+1,0]
	NOT R10; (not B[x+1,0])
	MOV R11, [R13+40*4+8];
	AND R10, R11
	MOV R11, [R13+40*4+32]
	XOR R10, R11

	MOVDQU [R12+40*4], XMM0 ; A[x,y] = B[x,y] XOR ((not B[x+1,y]) and B[x+2,y])
	MOVDQU [R12+40*4+16], XMM1
	MOV [R12+40*4+32], R10

	;Paso Iota

	POP RSI
	MOV R10, [R12]
	XOR R10, RSI
	MOV [R12], R10

	;libero la memoria de los arreglos auxiliares
	MOV RDI, R13
	CALL free
	MOV RDI, R14
	CALL free
	MOV RDI, R15
	CALL free

	POP RBX
	POP R15
	POP R14
	POP R13
	POP R12
ret
