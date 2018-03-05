global md5_ASM

extern malloc
extern free

section .data
	constABCD:  
		dd  0x67452301 ;A
	  	dd  0xEFCDAB89 ;B
	  	dd  0x98BADCFE ;C
		dd  0x10325476 ;D

	desp: 	db 7
		db 12
		db 17
		db 22
		db 7
		db 12
		db 17
		db 22
		db 7
		db 12
		db 17
		db 22
		db 7
		db 12
		db 17
		db 22
		db 5
		db 9
		db 14
		db 20
		db 5
		db 9
		db 14
		db 20
		db 5
		db 9
		db 14
		db 20
		db 5
		db 9
		db 14
		db 20
		db 4
		db 11
		db 16
		db 23
		db 4
		db 11
		db 16
		db 23
		db 4
		db 11
		db 16
		db 23
		db 4
		db 11
		db 16
		db 23
		db 6
		db 10
		db 15
		db 21
		db 6
		db 10
		db 15
		db 21
		db 6
		db 10
		db 15
		db 21
		db 6
		db 10
		db 15
		db 21

	consts: ; tabla de constantes precomputada para incrementar la performance
		dd 0xd76aa478
		dd 0xe8c7b756 
		dd 0x242070db 
		dd 0xc1bdceee
		dd 0xf57c0faf 
		dd 0x4787c62a 
		dd 0xa8304613 
		dd 0xfd469501
		dd 0x698098d8 
		dd 0x8b44f7af 
		dd 0xffff5bb1 
		dd 0x895cd7be
		dd 0x6b901122 
		dd 0xfd987193 
		dd 0xa679438e 
		dd 0x49b40821	
		dd 0xf61e2562 
		dd 0xc040b340 
		dd 0x265e5a51 
		dd 0xe9b6c7aa
		dd 0xd62f105d 
		dd 0x02441453 
		dd 0xd8a1e681 
		dd 0xe7d3fbc8	
		dd 0x21e1cde6 
		dd 0xc33707d6 
		dd 0xf4d50d87 
		dd 0x455a14ed	
		dd 0xa9e3e905 
		dd 0xfcefa3f8 
		dd 0x676f02d9 
		dd 0x8d2a4c8a	
		dd 0xfffa3942 
		dd 0x8771f681 
		dd 0x6d9d6122 
		dd 0xfde5380c	
		dd 0xa4beea44 
		dd 0x4bdecfa9 
		dd 0xf6bb4b60 
		dd 0xbebfbc70	
		dd 0x289b7ec6 
		dd 0xeaa127fa 
		dd 0xd4ef3085 
		dd 0x04881d05
		dd 0xd9d4d039 
		dd 0xe6db99e5 
		dd 0x1fa27cf8 
		dd 0xc4ac5665
		dd 0xf4292244 
		dd 0x432aff97 
		dd 0xab9423a7 
		dd 0xfc93a039
		dd 0x655b59c3 
		dd 0x8f0ccc92 
		dd 0xffeff47d 
		dd 0x85845dd1
		dd 0x6fa87e4f 
		dd 0xfe2ce6e0 
		dd 0xa3014314 
		dd 0x4e0811a1
		dd 0xf7537e82 
		dd 0xbd3af235 
		dd 0x2ad7d2bb 
		dd 0xeb86d391

section .text
md5_ASM:
	PUSH RBX
	PUSH R13
	PUSH R14
	PUSH R15

	; RDI puntero al mensaje
	; RSI longitud del mensaje

	MOV R15, RDI; resguardo la direccion del mensaje
	MOV R14, RSI; resguardo la longitud del mensaje	

	; Pido memoria donde almacenar el resultado hasheado (16 bytes)
	MOV RDI, 16
	SUB RSP, 8; alineo el stack
	CALL malloc
	ADD RSP, 8
	PUSH RAX; Guardo la direccion en el stack para usarla al final de la funcion
	
	; Preparo los registros para el loop
	MOVDQU XMM14, [constABCD]; Cargo las constantes iniciales del algoritmo y las guardo en un registro XMM
	MOV RDI, R15
	PUSH RDI; Guardo la direccion del mensaje con el padding para luego liberarla	
	MOV RSI, R14
	MOV R8, 0; contador
	SHR RSI, 9; divido la cantidad de bits del mensaje por 512 (tamaño del chunk) para saber cuantos chunks tengo que iterar 

	;Hasta aca:
	;Stack: posicion de memoria para el resultado final
	;RDI: posicion de memoria del mensaje
	;RSI: cantidad de iteraciones (cantidad de chunks de 512 bits)
	;R8: contador

	.loopChunks:
		CMP RSI, R8
		je .finLoopChunks

		MOVDQU XMM15, XMM14

		;Primera parte
		MOV R9, 0
		.F1:
			CMP R9, 16
			JE .finF1

			PEXTRD EAX, XMM15, 0; A
			PEXTRD EBX, XMM15, 1; B
			PEXTRD ECX, XMM15, 2; C
			PEXTRD EDX, XMM15, 3; D

			XOR ECX, EDX
			and ECX, EBX
			XOR ECX, EDX

			;calculo F
			ADD ECX, EAX; F=F+A
			MOV EDX, [consts+R9*4]
			ADD ECX, EDX; F=F+A+K[i]

			;calculo G	
			MOV RAX, R9

			;sigo calculANDo F
			MOV EDX, [RDI+RAX*4]
			ADD ECX, EDX; F=F+A+K[i]+M[g]
				
			PSHUFD xmm15, xmm15, 0x93 
			
			MOV EAX, ECX
			MOV RCX, R9
			ADD RCX, desp
			MOV CL, [RCX]; CL= constante de desplazamiento
			MOV EDX, EAX
			SHL EAX, CL
			NEG CL
			ADD CL, 32
			SHR EDX, CL
			or EAX, EDX
			ADD EBX, EAX
			PINSRD XMM15, EBX, 1
 			
			INC R9
			JMP .F1
		.finF1: 
		;Segunda parte
		.F2:
			CMP R9, 32
			JE .finF2

			PEXTRD EAX, XMM15, 0; A
			PEXTRD EBX, XMM15, 1; B
			PEXTRD ECX, XMM15, 2; C
			PEXTRD EDX, XMM15, 3; D

			MOV R13, RCX
			XOR ECX, EBX
			AND ECX, EDX
			MOV RDX, R13
			XOR ECX, EDX

			;calculo F
			ADD ECX, EAX; F=F+A
			MOV EDX, [consts+R9*4]
			ADD ECX, EDX; F=F+A+K[i]

			;calculo G	
			MOV RAX, R9
			MOV DL, 5
			MUL DL
			INC AX
			MOV DL, 16
			DIV DL
			XOR RDX, RDX
			MOV DL, AH

			;sigo calculando F
			MOV EDX, [RDI+RDX*4]
			ADD ECX, EDX; F=F+A+K[i]+M[g]
				
			PSHUFD xmm15, xmm15,  0x93 
			
			MOV EAX, ECX
			MOV RCX, R9
			ADD RCX, desp
			MOV CL, [RCX]; CL= constante de desplazamiento
			MOV EDX, EAX
			SHL EAX, CL
			NEG CL
			ADD CL, 32
			SHR EDX, CL
			OR EAX, EDX
			ADD EBX, EAX
			PINSRD XMM15, EBX, 1
		
			INC R9
			JMP .F2
		.finF2: 
		;Tercera parte
		.F3:
			CMP R9, 48
			JE .finF3

			PEXTRD EAX, XMM15, 0; A
			PEXTRD EBX, XMM15, 1; B
			PEXTRD ECX, XMM15, 2; C
			PEXTRD EDX, XMM15, 3; D

			XOR ECX, EBX
			XOR ECX, EDX

			;calculo F
			ADD ECX, EAX; F=F+A
			MOV EDX, [consts+R9*4]
			ADD ECX, EDX; F=F+A+K[i]

			;calculo G	
			MOV RAX, R9
			MOV DL, 3
			MUL DL
			ADD AX, 5
			MOV DL, 16
			DIV DL
			XOR RDX, RDX
			MOV DL, AH

			;sigo calculando F
			MOV EDX, [RDI+RDX*4]
			ADD ECX, EDX; F=F+A+K[i]+M[g]
				
			PSHUFD XMM15, XMM15, 0x93 
			
			MOV EAX, ECX
			MOV RCX, R9
			ADD RCX, desp
			MOV CL, [RCX]; CL= constante de desplazamiento
			MOV EDX, EAX
			SHL EAX, CL
			NEG CL
			ADD CL, 32
			SHR EDX, CL
			OR EAX, EDX
			ADD EBX, EAX
			PINSRD XMM15, EBX, 1

			INC R9
			JMP .F3
		.finF3: 
		;Cuarta parte
		.F4:
			CMP R9, 64
			JE .finF4

			PEXTRD EAX, XMM15, 0; A
			PEXTRD EBX, XMM15, 1; B
			PEXTRD ECX, XMM15, 2; C
			PEXTRD EDX, XMM15, 3; D

			not EDX
			OR EDX, EBX
			XOR ECX, EDX

			;calculo F
			ADD ECX, EAX; F=F+A
			MOV EDX, [consts+R9*4]
			ADD ECX, EDX; F=F+A+K[i]

			;calculo G	
			MOV RAX, R9
			MOV DL, 7
			MUL DL
			MOV DL, 16
			DIV DL
			XOR RDX, RDX
			MOV DL, AH

			;sigo calculando F
			MOV EDX, [RDI+RDX*4]
			ADD ECX, EDX; F=F+A+K[i]+M[g]
				
			PSHUFD XMM15, XMM15, 0x93 
			
			MOV EAX, ECX
			MOV RCX, R9
			ADD RCX, desp
			MOV CL, [RCX]; CL= constante de desplazamiento
			MOV EDX, EAX
			SHL EAX, CL
			NEG CL
			ADD CL, 32
			SHR EDX, CL
			OR EAX, EDX
			ADD EBX, EAX
			PINSRD XMM15, EBX, 1
		
			INC R9
			JMP .F4
		.finF4: 
		PADDD XMM14, XMM15
		ADD RDI, 64	
		INC R8
                JMP .loopChunks
	.finLoopChunks:
	POP RDI
	CALL free
	POP RAX
	MOVDQU [RAX], XMM14

	POP R15
	POP R14
	POP R13
	POP RBX
ret
