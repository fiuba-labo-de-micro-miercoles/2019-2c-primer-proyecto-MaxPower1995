; Facultad de Ingenieria - UBA
; Laboratorio de Microprocesadores
; Pulsador.asm
; Created: 23/5/2020 14:41:40
; Author : Porta, Maximiliano Adrian
;

; Defino constantes
.EQU ENTRADA = PINB
.EQU SALIDA = PORTB
.EQU PULSADOR_ON = 1
.EQU LED = 0

.CSEG

	JMP MAIN
.ORG INT_VECTORS_SIZE

MAIN:
	CLR R20
	LDI R20, 0b11111101 ;pin 0 como salida y pin 1 como entrada y el resto como salidas
	OUT DDRB, R20

CICLO_INFINITO:
	
	SBIC ENTRADA,PULSADOR_ON			; Si NO estoy pulsando no se ejecuta lo de abajo
	SBI  SALIDA,LED						; Enciende el led
	SBIS ENTRADA,PULSADOR_ON			; Si estoy pulsando no ejecuta lo de abajo
	CBI  SALIDA,LED						; Apaga el led
	JMP  CICLO_INFINITO	



