;
; Trabajo_practico_1(PIN).asm
;
; Created: 17/5/2020 11:34:25
; Author : mapor
;
/*Descripcion: En este codigo se realiza el parpadeo de un led en un periodo
de 1 segundo y configurando un unico pin como salida del puerto b, y activando
con un 1 logico ese pin para que encienda y con un 0 logico para que apague el led
*/

.include "m328pdef.inc" 

.cseg							;Escribo el codigo en la Memoria FLASH
.org 0x0000

jmp main

.org INT_VECTORS_SIZE			;Calcula cuanta memoria deja para los perifericos segun la placa
								;Esa cte esta difinida en m328pdef.inc

main:

;Configuro el Puerto B del Micro

	ldi R16,0b00000001			;Carga en el registro 16 -> 0b00000001
	out	DDRB,R16			    ;Configuro solo el pin 0 del puerto b como salida

ciclo_infinito:

	sbi PORTB,0					;Configura un valor alto en P0 -> Enciende el LED
	rcall tiempo_espera		    ;Espera el tiempo configurado en esa Bandera
	cbi PORTB,0			        ;Configura un valor bajo en el P0 -> Apaga el LED
	rcall tiempo_espera
	rjmp ciclo_infinito         ;Vuelve a iniciar este loop infinito

tiempo_espera:					;configuro el tiempo de espera clock de 16Mhz

	ldi R20, 32
t3: ldi R19, 250
t2: ldi R18, 250			
t1: nop							; hasta aca son 4 ciclos de maquina por iteracion -> 250ns

	dec R18					    ; 250 x 250ns = 62.5us
	brne t1

	dec R19
	brne t2					    ; 250 x 62.5us = 15.625ms

	dec R20
	brne t3					    ; 32 x 15.625us = 500ms 
								; Con esto logre un retardo de Medio Segundo
	ret							; Avanza a la linea siguiente de codigo que lo llamo
