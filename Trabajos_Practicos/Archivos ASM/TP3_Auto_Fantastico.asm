; Facultad de Ingenieria - UBA
; Laboratorio de Microprocesadores
; auto_fantastico.asm
; Created: 23/5/2020 18:14:53
; Author : Maximiliano Adrian Porta 98800
;

.INCLUDE "m328pdef.inc" 
.EQU TAMANIO = 11
.DEF CONTADOR = R21
.DEF PUERTO_LED = R22
.DEF CERO = R23

.DSEG

	.ORG 0X100

VECTOR: .BYTE TAMANIO

.CSEG							;Escribo el codigo en la Memoria FLASH


	JMP MAIN

.ORG INT_VECTORS_SIZE			;Calcula cuanta memoria deja para los perifericos segun la placa
								;Esa cte esta difinida en m328pdef.inc

MAIN:
;Configuro el Puerto B del Micro

	LDI R16,0xFF			
	OUT	DDRB,R16			    ;Configuro  el puerto b como salida
	LDI CERO,0x00


CICLO_INFINITO:
;Configuro los punteros
	LDI ZL, LOW(TABLA_ROM<<1)
	LDI ZH, HIGH(TABLA_ROM<<1)

	LDI CONTADOR, TAMANIO
CICLO_REPETITIVO:
	
	LPM PUERTO_LED, Z+ 
	OUT PORTB,PUERTO_LED
	RCALL TIEMPO_ESPERA	
	OUT PORTB,R23		
		        

; CHEQUEO SI ES EL ULTIMO VALOR, SI NO VUELVO A LEER
	DEC CONTADOR
	CPI CONTADOR, 0x00
	BRNE CICLO_REPETITIVO
	JMP CICLO_INFINITO
      
TIEMPO_ESPERA:					;configuro el tiempo de espera clock de 16Mhz

	LDI R20, 25
t3: LDI R19, 250
t2: LDI R18, 250			
t1: NOP							; hasta aca son 4 ciclos de maquina por iteracion -> 250ns

	DEC R18					    ; 250 x 250ns = 62.5us
	BRNE t1

	DEC R19
	BRNE t2					    ; 250 x 62.5us = 15.625ms

	DEC R20
	BRNE t3					    ; 32 x 15.625us = 500ms 
								; Con esto logre un retardo de Medio Segundo
	RET							; Avanza a la linea siguiente de codigo que lo llamo

TABLA_ROM: .DB 1,2,4,8,16,32,16,8,4,2,1
