global sha256_ASM

extern malloc
extern free

section .data

	constABCD:  
		dd  0x6a09e667 ;A
	  	dd  0xbb67ae85 ;B
	  	dd  0x3c6ef372 ;C
		dd  0xa54ff53a ;D
	constEFGH:  
	  	dd  0x510e527f ;E
		dd  0x9b05688c ;F
		dd  0x1f83d9ab ;G
		dd  0x5be0cd19 ;H

	preCalcConsts:
		dd  0x428a2f98
		dd  0x71374491
		dd  0xb5c0fbcf
		dd  0xe9b5dba5
		dd  0x3956c25b
		dd  0x59f111f1
		dd  0x923f82a4
		dd  0xab1c5ed5
		dd  0xd807aa98
		dd  0x12835b01
		dd  0x243185be
		dd  0x550c7dc3
		dd  0x72be5d74
		dd  0x80deb1fe
		dd  0x9bdc06a7
		dd  0xc19bf174
		dd  0xe49b69c1
		dd  0xefbe4786
		dd  0x0fc19dc6
		dd  0x240ca1cc
		dd  0x2de92c6f
		dd  0x4a7484aa
		dd  0x5cb0a9dc
		dd  0x76f988da
		dd  0x983e5152
		dd  0xa831c66d
		dd  0xb00327c8
		dd  0xbf597fc7
		dd  0xc6e00bf3
		dd  0xd5a79147
		dd  0x06ca6351
		dd  0x14292967	
		dd  0x27b70a85
		dd  0x2e1b2138
		dd  0x4d2c6dfc
		dd  0x53380d13
		dd  0x650a7354
		dd  0x766a0abb
		dd  0x81c2c92e
		dd  0x92722c85
		dd  0xa2bfe8a1
		dd  0xa81a664b
		dd  0xc24b8b70
		dd  0xc76c51a3
		dd  0xd192e819
		dd  0xd6990624
		dd  0xf40e3585
		dd  0x106aa070
		dd  0x19a4c116
		dd  0x1e376c08
		dd  0x2748774c
		dd  0x34b0bcb5
		dd  0x391c0cb3
		dd  0x4ed8aa4a
		dd  0x5b9cca4f
		dd  0x682e6ff3
		dd  0x748f82ee
		dd  0x78a5636f
		dd  0x84c87814
		dd  0x8cc70208
		dd  0x90befffa
		dd  0xa4506ceb
		dd  0xbef9a3f7
		dd  0xc67178f2	

section .text
sha256_ASM:
	PUSH RBX
	PUSH R14
	PUSH R15
	
	; RDI puntero al mensaje
	; RSI longitud del mensaje

	MOV R15, RDI; resguardo la direccion del mensaje
	MOV R14, RSI; resguardo la longitud del mensaje	

	; Pido memoria donde almacenar el resultado hasheado (32 bytes)
	MOV RDI, 32
	CALL malloc
	PUSH RAX; Guardo la direccion en el stack para usarla al final de la funcion
	
	; Pido memoria donde almacenar el chunk actual ampliado (se amplia a 64 dwords, es decir 256 bytes)
	MOV RDI, 256
	SUB RSP, 8
	CALL malloc
	ADD RSP, 8

	MOV RDI, R15; seteo en RDI la posicion de memoria del mensaje previamente resguardada
	; Resguardo la posicion de memoria del chunk ampliado en dos registros 
	MOV R15, RAX
	PUSH RAX; Guardo la direccion en el stack para luego hacer el free de la memoria	
	PUSH RDI; Guardo la direccion del mensaje con el padding para luego liberarla	

	; Cargo las constantes iniciales del algoritmo y las guardo en un registro XMM, 
	; la constante E la manejo por separado en un registro de proposito general
	MOVDQU XMM12, [constABCD]
	MOVDQU XMM13, [constEFGH]

	; Preparo los registros para el loop
	MOV RSI, R14
	MOV R8, 0; contador
	SHR RSI, 9; divido la cantidad de bits del mensaje por 512 (tamaño del chunk) para saber cuantos chunks tengo que iterar 
	
	;Hasta aca:
	;Stack: [posicion de memoria para el chunk ampliado ]
	; 	[posicion de memoria para el resultado final]
	;R15: posicion de memoria del chunk ampliado
	;RBX: posicion de memoria del chunk ampliado
	;RDI: posicion de memoria del mensaje
	;RSI: cantidad de iteraciones (cantidad de chunks de 512 bits)
	;R8: contador

	loopChunks:
		cmp R8, RSI
		JE finLoopChunks
		
		MOVDQU XMM0, [RDI]
		MOVDQU XMM1, [RDI+16]
		MOVDQU XMM2, [RDI+16*2]
		MOVDQU XMM3, [RDI+16*3]
		
		MOV RBX, R15

		MOVDQU [RBX], XMM0
		MOVDQU [RBX+16], XMM1
		MOVDQU [RBX+16*2], XMM2
		MOVDQU [RBX+16*3], XMM3
		
		ADD RBX, 64

		MOV R9, 16
		.ampliarChunk:
			CMP R9, 64
			JE .finAmpliarChunk
	
			;voy a armar cuatro dwords por ciclo
			;empiezo por armar las constantes s0 y s1
			
			;cargo en xmm0 las dwords 1-4
			MOVDQU XMM0, [R15+(R9-15)*4]
			;preparo las 4 constantes s0[0..3]
			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 7
			PSLLD XMM3, 25
			POR XMM2, XMM3
			MOVDQU XMM1, XMM2; agrego el resultado rightrotate 7

			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 18
			PSLLD XMM3, 14
			POR XMM2, XMM3
			PXOR XMM1, XMM2; agrego el resultado XOR rightrotate 18
		
			MOVDQU XMM2, XMM0
			PSRLD XMM2, 3
			PXOR XMM1, XMM2; agrego el resultado XOR rightshift 3


			;cargo en xmm0 las dwords 14-17
			MOVDQU XMM0, [R15+(R9-2)*4]
			;quedaria: 17-16-15-14 pero 16 y 17 todavia no estan
			;preparo las 4 constantes s1[0..3]
			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 17
			PSLLD XMM3, 15
			POR XMM2, XMM3
			MOVDQU XMM4, XMM2; agrego el resultado rightrotate 17

			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 19
			PSLLD XMM3, 13
			POR XMM2, XMM3
			PXOR XMM4, XMM2; agrego el resultado XOR rightrotate 19
		
			MOVDQU XMM2, XMM0
			PSRLD XMM2, 10
			PXOR XMM4, XMM2; agrego el resultado XOR rightshift 10
			MOVDQU XMM2, XMM4
			
			;XMM1: S0[0..3]	las constantes que le voy a sumar a cada palabra
			;XMM2: S1[0..3]	las constantes que le voy a sumar a cada palabra
			;borro la parte alta de xmm2 POR si hay basura
			PSLLDQ XMM2, 8; S1: 15-14-0-0
			PSRLDQ XMM2, 8; S1: 0-0-15-14
				
			PADDD XMM1, XMM2; s0[3]+0 - s0[2]+0 - s0[1]+s1[1] - s0[0]+s1[0]
			
			;cargo en XMM0 las dwords (i-16)..(i-16+3)
			MOVDQU XMM0, [R15+(R9-16)*4]
			PADDD XMM1, XMM0
			;cargo en XMM0 las dwords (i-7)..(i-7+3)
			MOVDQU XMM0, [R15+(R9-7)*4]
			PADDD XMM1, XMM0
			;Hasta este punto tengo:
			
			; XMM1: [s0[3]+0+w(i-13)+w(i-4),  s0[2]+0+w(i-14)+w(i-5),  s0[1]+s1[1]+w(i-15)+w(i-6),  s0[0]+s1[0]+w(i-16)+w(i-7)]
			;       |         3            |            2           |             1              |             0              |
			; las posiciones 0 y 1 ya tienen los valores finales correspondientes a w(i) y w(i+1), ahora, esos dos valores son 
			; necesarios para completar los dos valores que le faltaba a s1, los cuales (luego de ser rotados), son los que falta sumar a las posiciones 2 y 3
			
			MOVDQU XMM0, XMM1			
			PSLLDq XMM0, 8; queda: [s0[1]+s1[1]+w(i-15)+w(i-6),  s0[0]+s1[0]+w(i-16)+w(i-7),  0,  0]
			
			;aplico los shifts y XOR correspondientes
			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 17
			PSLLD XMM3, 15
			POR XMM2, XMM3
			MOVDQU XMM4, XMM2; agrego el resultado rightrotate 17

			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLD XMM2, 19
			PSLLD XMM3, 13
			POR XMM2, XMM3
			PXOR XMM4, XMM2; agrego el resultado XOR rightrotate 19
		
			MOVDQU XMM2, XMM0
			PSRLD XMM2, 10
			PXOR XMM4, XMM2; agrego el resultado XOR rightshift 10
			
			PADDD XMM1, XMM4
			; XMM1: [s0[3]+s1[3]+w(i-13)+w(i-4),  s0[2]+s1[2]+w(i-14)+w(i-5),  s0[1]+s1[1]+w(i-15)+w(i-6),  s0[0]+s1[0]+w(i-16)+w(i-7)]
			;       |         3            |            2           |             1              |             0              |
	
			MOVDQU [RBX], XMM1
			ADD RBX, 16 
			ADD R9, 4
			JMP .ampliarChunk
		.finAmpliarChunk:
		
		MOVDQU XMM14, XMM12
		MOVDQU XMM15, XMM13

		; XMM14: [d,  c,  b,  a]
		; XMM15: [h,  g,  f,  e]

		MOV R9, 0
		.calcularHash:
			CMP R9, 64
			JE .finCalcularHash
		
			; quiero calcular (e AND f) XOR ((NOT e) AND g)
			PEXTRD EAX, XMM15, 0; E
			PEXTRD EBX, XMM15, 1; F
			PEXTRD ECX, XMM15, 2; G
			MOV EDX, EAX; E
			NOT EDX; = NOT E
			AND EBX, EAX; F^E
			AND ECX, EDX; G^(NOT E)
			XOR ECX, EBX; F^E XOR G^(NOT E)
			MOV R11, RCX; F^E XOR G^(NOT E)
			
			;right rotate 6
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 6
			SHL ECX, 26
			OR EBX, ECX
			MOV EDX, EBX
			;XOR right rotate 11
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 11
			SHL ECX, 21
			OR EBX, ECX
			XOR EDX, EBX
			;XOR right rotate 25
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 25
			SHL ECX, 7
			OR EBX, ECX
			XOR EDX, EBX

			MOV EAX, EDX
			MOV RBX, R11

			ADD EAX, EBX; (F^E XOR G^(NOT E)) + (e rightrotate 6) XOR (e rightrotate 11) XOR (e rightrotate 25)
			PEXTRD EBX, XMM15, 3; H
			ADD EAX, EBX; (F^E XOR G^(NOT E)) + (e rightrotate 6) XOR (e rightrotate 11) XOR (e rightrotate 25) + H
			MOV EBX, [preCalcConsts+R9*4]
			ADD EAX, EBX; (F^E XOR G^(NOT E)) + (e rightrotate 6) XOR (e rightrotate 11) XOR (e rightrotate 25) + H + K[i]
			MOV EBX, [R15+R9*4]
			ADD EAX, EBX; (F^E XOR G^(NOT E)) + (e rightrotate 6) XOR (e rightrotate 11) XOR (e rightrotate 25) + H + K[i]+ W[i]
			MOV R11, RAX

			; quiero calcular (a AND b) XOR (a AND c) XOR (b AND c)
			PEXTRD EAX, XMM14, 0; A
			PEXTRD EBX, XMM14, 1; B
			PEXTRD ECX, XMM14, 2; C
			MOV EDX, EAX
			AND EAX, EBX; A^B
			AND EDX, ECX; A^C
			AND EBX, ECX; B^C
			XOR EDX, EAX; A^C XOR A^B
			XOR EDX, EBX; EDX: A^B XOR A^C XOR B^C
			MOV R10, RDX

			PEXTRD EAX, XMM14, 0; A
			;right rotate 2
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 2
			SHL ECX, 30
			OR EBX, ECX
			MOV EDX, EBX
			;XOR right rotate 13
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 13
			SHL ECX, 19
			OR EBX, ECX
			XOR EDX, EBX
			;XOR right rotate 22
			MOV EBX, EAX
			MOV ECX, EAX
			SHR EBX, 22
			SHL ECX, 10
			OR EBX, ECX
			XOR EDX, EBX
			
			MOV RAX, R10
			ADD EAX, EDX; EAX temp2=(a AND b) XOR (a AND c) XOR (b AND c) + (a rightrotate 2) XOR (a rightrotate 13) XOR (a rightrotate 22)		
			MOV RBX, R11; EBX temp1=(F^E XOR G^(NOT E)) + (e rightrotate 6) XOR (e rightrotate 11) XOR (e rightrotate 25) + H + K[i]+ W[i]

			PEXTRD EDX, XMM14, 3; D
			PSLLDQ XMM14, 4; [C,  B,  A,  0]
			PSLLDQ XMM15, 4; [G,  F,  E,  0]
			ADD EDX, EBX
			PINSRD XMM15, EDX, 0; [G,  F,  E,  D+temp1]
			ADD EAX, EBX; temp1+temp2
			PINSRD XMM14, EAX, 0; [C,  B,  A,  temp1+temp2]
			
			INC R9
			JMP .calcularHash
		.finCalcularHash:
			
		PADDD XMM12, XMM14
		PADDD XMM13, XMM15

		ADD RDI,64
		INC R8		
		JMP loopChunks
	finLoopChunks:
	POP RDI
	CALL free
	POP RDI
	SUB RSP, 8
	CALL free
	ADD RSP, 8
	POP RDI
	MOVDQU [RDI], XMM12
	MOVDQU [RDI+16], XMM13

	MOV RAX, RDI

	POP R15
	POP R14
	POP RBX
ret
