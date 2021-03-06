;
; Trabajo_Practico_4.asm
;
; Created: 23/6/2020 09:05:47
; Author : Maximiliano Porta
;
; para activar las interrupcions con F10 hay que configutara el atmel
;debug/options/tools/mask interupts while stepping --> false

.INCLUDE "m328pdef.inc"

.CSEG							;COMIENZO ESCRITURA EN ROM
.ORG 0X0000						;INICIO DE LA ROM
	JMP CONFIGURACIONES

.ORG INT0addr					;ES LA POSICION 0X02
	JMP INTERRUPCION

.ORG INT_VECTORS_SIZE			;52 WORDS EN 328P

CONFIGURACIONES:
	LDI R16,0XFF				;CONFIGURO EL PUERTO B
	OUT DDRB,R16				;CONFIGURO EL PUERTO B COMO SALIDA
	LDI R16,0X00	
	OUT PORTB,R16				;PONGO TODO EN CERO

	LDI R16,(1<<ISC01|0<<ISC00) ;CONF INT0 POR FLANCO DESCENDENTE
	STS EICRA,R16				;SETEO INT0 EN 0X69
	CLR R16
	LDI R16,(1<<INT0)			;ACTIVO INT0
	OUT EIMSK,R16				;PASO EL REG A 0X1D
	CLR R16

	SEI							;HABILITO INTERRUPCIONES

MAIN:
	SBI PORTB,0					;ENCIENDE EL LED 0
	JMP MAIN

INTERRUPCION:
	CLI
	CBI PORTB,0					;APAGO EL LED 0
	LDI R17,0x05

PARPADEO:
	DEC R17 
	SBI PORTB,1
	CALL DELAY
	CBI PORTB,1
	CALL DELAY
	CPI R17,0
	BRNE PARPADEO

	SBI PORTB,0
	SEI
	RETI

DELAY:							;CONFIGURO EL DELAY

	LDI R20, 64
t3: LDI R19, 250
t2: LDI R18, 250
t1: NOP							; hasta aca son 4 ciclos de maquina por iteracion -> 250ns

	DEC R18						; 250 x 250ns = 62.5us
	BRNE t1

	DEC R19
	BRNE t2						; 250 x 50us = 15.625ms

	DEC R20
	BRNE t3						; 64 x 15.625ms = 1s = 1Hz
								; Con esto logre un retardo de Medio Segundo
	RET							; Vuelve a la linea siguiente de la que fue llamado



