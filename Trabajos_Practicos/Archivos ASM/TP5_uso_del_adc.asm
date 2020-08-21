; conversor_analogico_digittal.asm
;
; Created: 19/7/2020 16:33:41
; Author : mapor

.INCLUDE "m328pdef.inc"
.CSEG 
	RJMP MAIN

.ORG ADCCaddr				;0x002A
    RJMP INT_ADC

 .ORG INT_VECTORS_SIZE

MAIN:
	LDI R22, 0xFF
    OUT DDRB, R22			;todo el puerto B como salida
    LDI R22, 0x00           
    OUT DDRC, R22			;el puerto c como entrada(adc2)
    
	LDI R17,0X3F			;constante que multiplica
	
	
    LDI R22, 0xAF		; ADCSRA-> ADC_Activado, Por_Interrupcion, Prescale 128(16Mhz)
    STS ADCSRA,R22
    LDI R22,    0x62	; ADMUX-> Vreferencia=Vcc, Corrimiento a izquierda, ADC2
    STS ADMUX,R22
	LDI R22, 0x00
    STS ADCSRB,R22		;free running

    SEI					;activo las interrupciones

    LDS R22, ADCSRA		; escribo un 1 en adsc y arranca la conversion
    ORI R22, 0x40
    STS ADCSRA, R22
    
    LDS R23, 0

LOOP:						;loop donde queda el programa esperando interrupciones
    OUT PORTB, R23
    RJMP LOOP

/*
haciendo un par de cuentas me di cuenta que siempre al dividir por 63 queda la parte alta 
de la multiplicacion (R1), excepto cuando es 255 que da 63 y con este metodo da 62 asi que hago
esa correccion sola y me ahorro la division sucesiva,lo cual aumenta la velocidad de procesamiento
*/

INT_ADC:
    LDS R23, ADCH
	CPI R23,255
	BREQ ES_255
	MUL R23,R17
	MOV R23,R1
	RETI

ES_255:
	LDI R23,0x3F
	RETI

