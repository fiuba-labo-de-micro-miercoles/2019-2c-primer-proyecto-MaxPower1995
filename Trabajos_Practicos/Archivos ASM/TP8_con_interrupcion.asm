;
; TP8_por_interrupciones.asm
;
; Created: 16/8/2020 10:40:45
; Author : mapor
;
.INCLUDE "M328PDEF.INC"

.MACRO LED
	SBIC PORTB,@0		;MIRO EL ESTADO DEL LED
	JMP APAGO
	SBI PORTB,@0
	RETI
APAGO:
	CBI PORTB,@0
	RETI
.ENDM

.CSEG
.ORG 0X0000
	JMP MAIN

.ORG URXCaddr		;0x0024
	JMP RECIBE

.ORG INT_VECTORS_SIZE

MAIN:
	LDI R16,0X00
	OUT DDRD,R16			;PUERTO D COMO ENTRAD
	LDI R16,0XFF
	OUT DDRB,R16			;PUERTO B COMO SALIDA

	LDI R16,1<<RXEN0|1<<TXEN0|1<<RXCIE0		
	STS	UCSR0B,R16	;HABILITO INTERRUPCIONES 
	LDI R16,1<<UCSZ01|1<<UCSZ00|0<<UMSEL00
	STS UCSR0C,R16	;8-BIT,SIN PARIDAD,1 BIT DE STOP,ASINCRONICO
	LDI R16,0X00
	STS UBRR0H,R16	;9600 BAUD RATE-->UBRR 0X68
	LDI R16,0X68
	STS UBRR0L,R16
	LDI R16,0X00
	CALL PUNTEROS

	SEI

TR:
	LPM R18,Z+
	CPI R18,0
	BREQ LOOP_PRINCIPAL
	CALL TRANSMITIR
	JMP TR		

LOOP_PRINCIPAL:
	NOP
	JMP LOOP_PRINCIPAL

RECIBE:
	LDS R17,UDR0		;PASO EL DATO AL REG
	CPI R17,'1'
	BREQ ES_UNO
	CPI R17,'2'
	BREQ ES_DOS
	CPI R17,'3'
	BREQ ES_TRES
	CPI R17,'4'
	BREQ ES_CUATRO
	RETI
	
ES_UNO:
	LED 0
ES_DOS:
	LED 1
ES_TRES:
	LED 2
ES_CUATRO:
	LED 3


TRANSMITIR:
	LDS R17,UCSR0A
	SBRS R17,UDRE0
	JMP TRANSMITIR
	STS UDR0,R18		;TRANSMITO EL DATO 
	RET



PUNTEROS:	;INICIALIZA LOS PUNTEROS EN ROM 
	LDI ZL,LOW(TABLA_ROM<<1)
	LDI ZH,HIGH(TABLA_ROM<<1)
	RET

TABLA_ROM: .db "*** Hola Labo de Micro ***", 10, 13,"Escriba 1, 2, 3 o 4 para controlar los LEDs", 10, 13, 0