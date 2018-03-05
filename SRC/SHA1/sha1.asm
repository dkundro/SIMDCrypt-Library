global sha1_ASM

extern malloc
extern free

section .data

	constABCD:  
		dd  0x67452301 ;A
	  	dd  0xEFCDAB89 ;B
	  	dd  0x98BADCFE ;C
		dd  0x10325476 ;D
	E:  	dd  0xC3D2E1F0

	finalOrdShufMask: dq 0x0405060700010203
		          dq 0x0C0D0E0F08090A0B

	asciiConvShuf: dq 0xFF03FF02FF01FF00
		       dq 0xFF07FF06FF05FF04
	asciiLetterOffsetMask: dq 0x4141414141414141
			       dq 0x4141414141414141
	asciiNumberOffsetMask: dq 0x3030303030303030
			       dq 0x3030303030303030
	nineMask: dq 0x0909090909090909
		  dq 0x0909090909090909

section .text
sha1_ASM:
	PUSH RBX
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15

	; RDI puntero al mensaje
	; RSI longitud del mensaje

	MOV R15, RDI; resguardo la direccion del mensaje
	MOV R14, RSI; resguardo la longitud del mensaje	

	; Pido memoria donde almacenar el resultado hasheado (20 bytes)
	MOV RDI, 20
	CALL malloc
	PUSH RAX; Guardo la direccion en el stack para usarla al final de la funcion
	
	; Pido memoria donde almacenar el chunk actual ampliado (se amplia a 80 dwords, es decir 320 bytes)
	MOV RDI, 320
	SUB RSP, 8; alineo el stack
	CALL malloc
	ADD RSP, 8
	MOV RDI, R15; seteo en RDI la posicion de memoria del mensaje previamente resguardada
	; Resguardo la posicion de memoria del chunk ampliado en dos registros 
	MOV R15, RAX
	MOV RBX, RAX
	PUSH RAX; Guardo la direccion en el stack para luego hacer el free de la memoria
	PUSH RDI; Guardo la direccion del mensaje con el padding para luego liberarla		

	; Cargo las constantes iniciales del algoritmo y las guardo en un registro XMM, 
	; la constante E la manejo por separado en un registro de proposito general
	MOVDQU XMM14, [constABCD]
	MOV R12, [E]
	SHL R12, 32; limpio la parte alta del registro
	SHR R12, 32

	; Preparo los registros para el loop
	MOV RSI, R14
	MOV R8, 0; contador
	SHR RSI, 9; divido la cantidad de bits del mensaje por 512 (tamaño del chunk) para saber cuantos chunks tengo que iterar 
	
	;Hasta aca:
	;Stack: posicion de memoria para el resultado final
	;R15: posicion de memoria para el chunk ampliado
	;RBX: posicion de memoria para el chunk ampliado
	;RDI: posicion de memoria del mensaje
	;RSI: cantidad de iteraciones (cantidad de chunks de 512 bits)
	;R8: contador

	.loopChunks:
		CMP R8, RSI
		JE .finLoopChunks
		PUSH RDI
		PUSH RBX
		PUSH RSI
		.extenderChunk:
			MOVDQU XMM0, [RDI]
			MOVDQU XMM1, [RDI+16]
			MOVDQU XMM2, [RDI+16*2]
			MOVDQU XMM3, [RDI+16*3]

			MOVDQU [RBX], XMM0
			MOVDQU [RBX+16], XMM1
			MOVDQU [RBX+32], XMM2
			MOVDQU [RBX+48], XMM3

			ADD RBX, 64
			MOV RCX, 0; contador de iteraciones
			.cicloAmpChunk:
				CMP RCX, 16
				JE .calcularValoresIndividuales
		
				;Utilizo SIMD para ampliar el chunk actual de 16 dwords a 80 dwords

				MOVDQU XMM4, XMM0; 3  -  2  -  1  -  0
				MOVDQU XMM5, XMM1; 7  -  6  -  5  -  4
					    ;XMM2  11 - 10  -  9  -  8 
				MOVDQU XMM7, XMM3; 15 - 14  - 13  - 12
		
				PSRLDQ XMM7, 4; 0  - 15  - 14  - 13
				PSLLDQ XMM5, 8; 5  -  4  -  0  -  0
				PSRLDQ XMM4, 8; 0  -  0  -  3  -  2
				POR XMM4, XMM5; 5  -  4  -  3  -  2    
			
				PXOR XMM7, XMM0
				PXOR XMM7, XMM4
				PXOR XMM7, XMM2
			
				MOVDQU XMM0, XMM7
				CALL leftRotateXMMD
				MOVDQU XMM7, XMM0

				PEXTRD EDX, XMM7, 3
				PEXTRD EDI, XMM7, 0
				MOV ESI, 1
				CALL leftRotate
				XOR EAX, EDX
				PINSRD XMM7, EAX, 3

			
						
				MOVDQU [RBX], XMM7
				ADD RBX, 16
				MOVDQU XMM0, XMM1
				MOVDQU XMM1, XMM2
				MOVDQU XMM2, XMM3
				MOVDQU XMM3, XMM7
			
				INC RCX
				JMP .cicloAmpChunk
		
		.calcularValoresIndividuales:
		MOV R14, 0
		MOVDQU XMM15, XMM14
		MOV R13, R12
			  
		.hash:			
			CMP R14, 80
			JE .finHash

			XOR RDX, RDX
			XOR RCX, RCX
			XOR RBX, RBX
			XOR RAX, RAX

			; R13: E
			PEXTRD EDX, XMM15, 3 ; D
			PEXTRD ECX, XMM15, 2 ; C
			PEXTRD EBX, XMM15, 1 ; B
			PEXTRD EAX, XMM15, 0 ; A	
	

			CMP R14, 19
			JBE .F1
			CMP R14, 39
			JBE .F2
			CMP R14, 59
			JBE .F3
			CMP R14, 79
			JBE .F4

			.F1:
				MOV R10, RBX
				MOV R11, RBX
				NOT R11
				SHL R11, 32
				SHR R11, 32
				and R10, RCX
				and R11, RDX
				OR R10, R11
				MOV R9, 0x5A827999
				JMP .cont
			.F2:
				MOV R10, RBX
				XOR R10, RCX
				XOR R10, RDX
				MOV R9, 0x6ED9EBA1
				JMP .cont
			.F3:
				MOV R10, RBX
				MOV R11, RBX
				and R10, RCX
				and R11, RDX
				OR R10, R11
				MOV R11, RCX
				and R11, RDX
				OR R10, R11
				MOV R9, 0x8F1BBCDC
				JMP .cont
			.F4:
				MOV R10, RBX
				XOR R10, RCX
				XOR R10, RDX
				MOV R9, 0xCA62C1D6
				JMP .cont
			.cont:
		
			ADD R10, R9; K+ F
			ADD R10, R13; K+F+E
			MOV EDI, EAX
			MOV ESI, 5
			CALL leftRotate
			SHL RAX, 32
			SHR RAX, 32
			ADD R10, RAX; K+F+E+(lR(A,5))
			MOV EAX, [R15+R14*4]; M[i]
			SHL RAX, 32
			SHR RAX, 32
			ADD R10, RAX; K+F+E+(lR(A,5))+ M[i]
		
			MOV R13, RDX; E=D
			PSLLDQ XMM15, 4; D=C, C=B, B=A, A=0
			MOV EDI, EBX
			MOV ESI, 30
			CALL leftRotate
			SHL RAX, 32
			SHR RAX, 32
		
			PINSRD XMM15, EAX, 2; D=C, C=lR(B, 30), B=A, A=0
			MOV RAX, R10
			SHL RAX, 32
			SHR RAX, 32
			PINSRD XMM15, EAX, 0; D=C, C=lR(B, 30), B=A, A=K+F+E+(lR(A,5))+ M[i]

			INC R14	
			JMP .hash
		.finHash:
		
		PADDD XMM14, XMM15
		ADD R12, R13
		POP RSI
		POP RBX
		POP RDI
		ADD RDI, 64
		INC R8
		JMP .loopChunks
	.finLoopChunks:
	POP RDI
	CALL free
	POP RDI
	SUB RSP, 8
	CALL free
	ADD RSP, 8
	POP RDI

	;Reacomodo el resultado
	
	PEXTRD ECX, XMM14, 0
	MOV RAX, R12
	PINSRD XMM14, EAX, 0
	BSWAP ECX
	PSHUFD XMM14, XMM14, 0x39 
	MOVDQU XMM15, [finalOrdShufMask]
	PSHUFB XMM14, XMM15

	MOV [RDI], ECX
	MOVDQU [RDI+4], XMM14
	
	MOV RAX, RDI

	POP R15
	POP R14
	POP R13
	POP R12
	POP RBX	
ret

leftRotate:
	;EDI numero a rotar
	;ESI rotaciones
	PUSH RCX
	MOV ECX, ESI 
	MOV EAX, EDI
	SHL EDI, CL
	neg CL
	ADD CL, 32
	SHR EAX, CL
	OR EAX, EDI
	POP RCX
ret

leftRotateXMMD:; rota cada dowrd del registro una posicion a la izquierda
	;XMM0 numero a rotar
	SUB RSP, 16
	MOVDQU [RSP], XMM1
	MOVDQU XMM1, XMM0
	PSRLD XMM1, 31
	PSLLD XMM0, 1
	POR XMM0, XMM1
	MOVDQU XMM1, [RSP]
	ADD RSP, 16
ret
