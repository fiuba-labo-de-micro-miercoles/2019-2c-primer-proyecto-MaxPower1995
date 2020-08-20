; Timers-tl6.asm
;
; Created: 9/8/2020 10:47:13
; Author : maporta

.INCLUDE "M328PDEF.INC"
.DEF aux = R16
.CSEG						;COMIENZO ESCRITURA EN ROM
.ORG 0X0000					;INICIO DE LA ROM
	JMP MAIN

.ORG OVF1addr					
	JMP INTERRUPCION

.ORG INT_VECTORS_SIZE		;52 WORDS EN ATMEGA328P

MAIN:
	LDI R16,0XFF
	OUT DDRB,R16
	LDI R16,0X00
	OUT DDRD,R16
	SBI PORTB,0			;ARRANCA CON LED OFF
	LDI R16,0X00
	STS TCCR1A,R16		;CONFIGURO EN MODO NORMAL
	STS TCCR1B,R16
	LDI R16,0X01
	STS TIMSK1,R16		;ACTIVO INTERRUPCION X OVERFLOW
	LDI R16,0X00
	SEI					;ACTIVO INTERRUPCIONES

LOOP:
	IN R17,PIND
	CPI R17,0X00
	BREQ CLK_OFF
	CPI R17,0X01
	BREQ CLK_64
	CPI R17,0X02
	BREQ CLK_256
	CPI R17,0X03
	BREQ CLK_1024
	CALL DELAY			;EVITA REBOTES MECANICOS
	JMP LOOP

CLK_OFF:
	LDI R16,0X00
	STS TCCR1B,R16		;APAGO EL CLOCK
	SBI PORTB,0			;ENCIENDE EL LED
	JMP LOOP

CLK_64:
	LDI R16,0X03
	STS TCCR1B,R20
	JMP LOOP

CLK_256:
	LDI R20,0X04
	STS TCCR1B,R20
	JMP LOOP

CLK_1024:
	LDI R20,0X05
	STS TCCR1B,R20
	JMP LOOP

INTERRUPCION:						
	SBIC PORTB,0					;MIRO EL ESTADO DEL LED
	JMP APAGO
	SBI PORTB,0
	RETI
APAGO:
	CBI PORTB,0
	RETI

DELAY:							;CONFIGURO EL TIEMPO DE ESPERA
	LDI R20, 1
t3: LDI R19, 80
t2: LDI R18, 250			
t1: NOP							

	DEC R18					    ; 250 x 250ns = 62.5us
	BRNE t1

	DEC R19
	BRNE t2					    ; 80 x 62.5us = 5ms

	DEC R20
	BRNE t3					    ; 1 x 5ms = 5ms 
								
	RET							