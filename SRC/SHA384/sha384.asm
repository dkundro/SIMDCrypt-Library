global sha384_ASM

extern malloc
extern free

section .data

	constAB:  
		dq  0xcbbb9d5dc1059ed8 ;A
	  	dq  0x629a292a367cd507 ;B
	constCD:
	  	dq  0x9159015a3070dd17 ;C
		dq  0x152fecd8f70e5939 ;D
	constEF:  
	  	dq  0x67332667ffc00b31 ;E
		dq  0x8eb44a8768581511 ;F
	constGH:
		dq  0xdb0c2e0d64f98fa7 ;G
		dq  0x47b5481dbefa4fa4 ;H

	preCalcConsts:
		dq  0x428a2f98d728ae22
		dq  0x7137449123ef65cd
		dq  0xb5c0fbcfec4d3b2f
		dq  0xe9b5dba58189dbbc
		dq  0x3956c25bf348b538
		dq  0x59f111f1b605d019
		dq  0x923f82a4af194f9b
		dq  0xab1c5ed5da6d8118
		dq  0xd807aa98a3030242
		dq  0x12835b0145706fbe
		dq  0x243185be4ee4b28c
		dq  0x550c7dc3d5ffb4e2
		dq  0x72be5d74f27b896f
		dq  0x80deb1fe3b1696b1
		dq  0x9bdc06a725c71235
		dq  0xc19bf174cf692694
		dq  0xe49b69c19ef14ad2
		dq  0xefbe4786384f25e3
		dq  0x0fc19dc68b8cd5b5
		dq  0x240ca1cc77ac9c65
		dq  0x2de92c6f592b0275
		dq  0x4a7484aa6ea6e483
		dq  0x5cb0a9dcbd41fbd4
		dq  0x76f988da831153b5
		dq  0x983e5152ee66dfab
		dq  0xa831c66d2db43210
		dq  0xb00327c898fb213f
		dq  0xbf597fc7beef0ee4
		dq  0xc6e00bf33da88fc2
		dq  0xd5a79147930aa725
		dq  0x06ca6351e003826f
		dq  0x142929670a0e6e70	
		dq  0x27b70a8546d22ffc
		dq  0x2e1b21385c26c926
		dq  0x4d2c6dfc5ac42aed
		dq  0x53380d139d95b3df
		dq  0x650a73548baf63de
		dq  0x766a0abb3c77b2a8
		dq  0x81c2c92e47edaee6
		dq  0x92722c851482353b
		dq  0xa2bfe8a14cf10364
		dq  0xa81a664bbc423001
		dq  0xc24b8b70d0f89791
		dq  0xc76c51a30654be30
		dq  0xd192e819d6ef5218
		dq  0xd69906245565a910
		dq  0xf40e35855771202a
		dq  0x106aa07032bbd1b8
		dq  0x19a4c116b8d2d0c8
		dq  0x1e376c085141ab53
		dq  0x2748774cdf8eeb99
		dq  0x34b0bcb5e19b48a8
		dq  0x391c0cb3c5c95a63
		dq  0x4ed8aa4ae3418acb
		dq  0x5b9cca4f7763e373
		dq  0x682e6ff3d6b2b8a3
		dq  0x748f82ee5defb2fc
		dq  0x78a5636f43172f60
		dq  0x84c87814a1f0ab72
		dq  0x8cc702081a6439ec
		dq  0x90befffa23631e28
		dq  0xa4506cebde82bde9
		dq  0xbef9a3f7b2c67915
		dq  0xc67178f2e372532b
		dq  0xca273eceea26619c
		dq  0xd186b8c721c0c207
		dq  0xeada7dd6cde0eb1e
		dq  0xf57d4f7fee6ed178
		dq  0x06f067aa72176fba
		dq  0x0a637dc5a2c898a6
		dq  0x113f9804bef90dae	
		dq  0x1b710b35131c471b	
		dq  0x28db77f523047d84	
		dq  0x32caab7b40c72493	
		dq  0x3c9ebe0a15c9bebc	
		dq  0x431d67c49c100d4c	
		dq  0x4cc5d4becb3e42b6	
		dq  0x597f299cfc657e2a	
		dq  0x5fcb6fab3ad6faec	
		dq  0x6c44198c4a475817	

section .text
sha384_ASM:
	PUSH RBX
	PUSH R14
	PUSH R15

	; RDI puntero al mensaje
	; RSI longitud del mensaje

	MOV R15, RDI; resguardo la direccion del mensaje
	MOV R14, RSI; resguardo la longitud del mensaje	

	; Pido memoria donde almacenar el resultado hasheado (48 bytes)
	MOV RDI, 48
	CALL malloc
	PUSH RAX; Guardo la direccion en el stack para usarla al final de la funcion
	
	; Pido memoria donde almacenar el chunk actual ampliado (se amplia a 80 quad words, es decir 640 bytes)
	MOV RDI, 640
	SUB RSP, 8
	CALL malloc
	ADD RSP, 8

	MOV RDI, R15; seteo en RDI la posicion de memoria del mensaje previamente resguardada
	; Resguardo la posicion de memoria del chunk ampliado en dos registros 
	MOV R15, RAX
	PUSH RAX; Guardo la direccion en el stack para luego hacer el free de la memoria	
	PUSH RDI; Guardo la direccion del mensaje con el padding para luego liberarla	

	; Cargo las constantes iniciales del algoritmo y las guardo en un registro XMM, 
	; la constante E la manejo POR separado en un registro de proposito general
	MOVDQU XMM8, [constAB]
	MOVDQU XMM9, [constCD]
	MOVDQU XMM10, [constEF]
	MOVDQU XMM11, [constGH]

	; Preparo los registros para el loop
	MOV RSI, R14
	MOV R8, 0; contador
	SHR RSI, 10; divido la cantidad de bits del mensaje por 1024 (tamaño del chunk) para saber cuantos chunks tengo que iterar 
	
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
		MOVDQU XMM4, [RDI+16*4]
		MOVDQU XMM5, [RDI+16*5]
		MOVDQU XMM6, [RDI+16*6]
		MOVDQU XMM7, [RDI+16*7]
		
		MOV RBX, R15

		MOVDQU [RBX], XMM0
		MOVDQU [RBX+16], XMM1
		MOVDQU [RBX+16*2], XMM2
		MOVDQU [RBX+16*3], XMM3
		MOVDQU [RBX+16*4], XMM4
		MOVDQU [RBX+16*5], XMM5
		MOVDQU [RBX+16*6], XMM6
		MOVDQU [RBX+16*7], XMM7
		
		ADD RBX, 128

		MOV R9, 16
		.ampliarChunk:
			CMP R9, 80
			JE .finAmpliarChunk
	
			;voy a armar dos quad words por ciclo
			;empiezo por armar las constantes s0 y s1
			
			;cargo en xmm0 las dwords i-15 y i-14
			MOVDQU XMM0, [R15+(R9-15)*8]
			
			;preparo las 2 constantes s0[0, 1]
			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLQ XMM2, 1
			PSLLQ XMM3, 63
			POR XMM2, XMM3
			MOVDQU XMM1, XMM2; agrego el resultado rightrotate 1

			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLQ XMM2, 8
			PSLLQ XMM3, 56
			POR XMM2, XMM3
			PXOR XMM1, XMM2; agrego el resultado XOR rightrotate 8
		
			MOVDQU XMM2, XMM0
			PSRLQ XMM2, 7
			PXOR XMM1, XMM2; agrego el resultado XOR rightshift 7
			
			;cargo en xmm0 las dwords i-2 y i-1
			MOVDQU XMM0, [R15+(R9-2)*8]
			;preparo las 2 constantes s1[0, 1]
			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLQ XMM2, 19
			PSLLQ XMM3, 45
			POR XMM2, XMM3
			MOVDQU XMM4, XMM2; agrego el resultado rightrotate 19

			MOVDQU XMM2, XMM0
			MOVDQU XMM3, XMM0
			PSRLQ XMM2, 61
			PSLLQ XMM3, 3
			POR XMM2, XMM3
			PXOR XMM4, XMM2; agrego el resultado XOR rightrotate 61
		
			MOVDQU XMM2, XMM0
			PSRLQ XMM2, 6
			PXOR XMM4, XMM2; agrego el resultado XOR rightshift 6
			MOVDQU XMM2, XMM4
			
			;XMM1: S0[0, 1]	las constantes que le voy a sumar a cada palabra
			;XMM2: S1[0, 1]	las constantes que le voy a sumar a cada palabra

			PADDQ XMM1, XMM2; s0[1]+s1[1] - s0[0]+s1[0]
			
			;cargo en XMM0 las dwords (i-16), (i-16+3)
			MOVDQU XMM0, [R15+(R9-16)*8]
			PADDQ XMM1, XMM0
			;cargo en XMM0 las dwords (i-7), (i-7+3)
			MOVDQU XMM0, [R15+(R9-7)*8]
			PADDQ XMM1, XMM0			

			; XMM1: [s0[1]+s1[1]+w(i-15)+w(i-6),  s0[0]+s1[0]+w(i-16)+w(i-7)]
			;       |           1              |             0              |
		
			MOVDQU [RBX], XMM1
			ADD RBX, 16 
			ADD R9, 2
			JMP .ampliarChunk
		.finAmpliarChunk:
		MOVDQU XMM12, XMM8
		MOVDQU XMM13, XMM9
		MOVDQU XMM14, XMM10
		MOVDQU XMM15, XMM11

		; XMM12: [b,  a]
		; XMM13: [d,  c]
		; XMM14: [f,  e]
		; XMM15: [h,  g]

		MOV R9, 0
		.calcularHash:
			CMP R9, 80
			JE .finCalcularHash
		
			; quiero calcular (e and f) XOR ((not e) and g)
			PEXTRQ RAX, XMM14, 0; E
			PEXTRQ RBX, XMM14, 1; F
			PEXTRQ RCX, XMM15, 0; G
			MOV RDX, RAX; E
			not RDX; = not E
			AND RBX, RAX; F^E
			AND RCX, RDX; G^(not E)
			XOR RCX, RBX; F^E XOR G^(not E)
			MOV R11, RCX; F^E XOR G^(not E)
			
			;right rotate 14
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 14
			SHL RCX, 50
			OR RBX, RCX
			MOV RDX, RBX
			;XOR right rotate 18
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 18
			SHL RCX, 46
			OR RBX, RCX
			XOR RDX, RBX
			;XOR right rotate 41
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 41
			SHL RCX, 23
			OR RBX, RCX
			XOR RDX, RBX

			MOV RAX, RDX
			MOV RBX, R11

			ADD RAX, RBX; (F^E XOR G^(not E)) + (e rightrotate 14) XOR (e rightrotate 18) XOR (e rightrotate 41)
			PEXTRQ RBX, XMM15, 1; H
			ADD RAX, RBX; (F^E XOR G^(not E)) + (e rightrotate 14) XOR (e rightrotate 18) XOR (e rightrotate 41) + H
			MOV RBX, [preCalcConsts+R9*8]
			ADD RAX, RBX; (F^E XOR G^(not E)) + (e rightrotate 14) XOR (e rightrotate 18) XOR (e rightrotate 41) + H + K[i]
			MOV RBX, [R15+R9*8]
			ADD RAX, RBX; (F^E XOR G^(not E)) + (e rightrotate 14) XOR (e rightrotate 18) XOR (e rightrotate 41) + H + K[i]+ W[i]
			MOV R11, RAX

			; quiero calcular (a and b) XOR (a and c) XOR (b and c)
			PEXTRQ RAX, XMM12, 0; A
			PEXTRQ RBX, XMM12, 1; B
			PEXTRQ RCX, XMM13, 0; C
			MOV RDX, RAX
			AND RAX, RBX; A^B
			AND RDX, RCX; A^C
			AND RBX, RCX; B^C
			XOR RDX, RAX; A^C XOR A^B
			XOR RDX, RBX; RDX: A^B XOR A^C XOR B^C
			MOV R10, RDX

			PEXTRQ RAX, XMM12, 0; A
			;right rotate 28
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 28
			SHL RCX, 36
			OR RBX, RCX
			MOV RDX, RBX
			;XOR right rotate 34
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 34
			SHL RCX, 30
			OR RBX, RCX
			XOR RDX, RBX
			;XOR right rotate 39
			MOV RBX, RAX
			MOV RCX, RAX
			SHR RBX, 39
			SHL RCX, 25
			OR RBX, RCX
			XOR RDX, RBX
			
			MOV RAX, R10
			ADD RAX, RDX; RAX temp2=(a and b) XOR (a and c) XOR (b and c) + (a rightrotate 28) XOR (a rightrotate 34) XOR (a rightrotate 39)		
			MOV RBX, R11; RBX temp1=(F^E XOR G^(not E)) + (e rightrotate 14) XOR (e rightrotate 18) XOR (e rightrotate 41) + H + K[i]+ W[i]

			PEXTRQ RDX, XMM14, 1; F
			PSLLDQ XMM15, 8; [G,  0]
			PINSRQ XMM15, RDX, 0; [G, F]
			
			PEXTRQ RDX, XMM13, 1; D
			PSLLDQ XMM14, 8; [E,  0]
			ADD RDX, RBX
			PINSRQ XMM14, RDX, 0; [E, D+temp 1]
			
			PEXTRQ RDX, XMM12, 1; B
			PSLLDQ XMM13, 8; [C,  0]
			PINSRQ XMM13, RDX, 0; [C, B]
		
			PSLLDQ XMM12, 8; [A,  0]

			ADD RAX, RBX; temp1+temp2
			PINSRQ XMM12, RAX, 0; [A,  temp1+temp2]
			
			INC R9
			JMP .calcularHash
		.finCalcularHash:

		PADDQ XMM8, XMM12
		PADDQ XMM9, XMM13
		PADDQ XMM10, XMM14
		PADDQ XMM11, XMM15

		ADD RDI, 128
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
	MOVDQU [RDI], XMM8
	MOVDQU [RDI+16], XMM9
	MOVDQU [RDI+16*2], XMM10

	MOV RAX, RDI

	POP R15
	POP R14
	POP RBX
ret
