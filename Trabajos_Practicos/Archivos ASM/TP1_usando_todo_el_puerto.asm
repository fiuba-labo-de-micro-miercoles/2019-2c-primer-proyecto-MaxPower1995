; Trabajo_Practico_1.asm
; Encendido de un LED
; Created: 16/5/2020 10:24:57
; Author : Maximiliano Adrian Porta, 98.800
; University : Facultad de Ingenieria, UBA
;

/*Descripcion:
En este programa lo que se realiza es el parpadeo de un led con un periodo
de aproximadamente de 1 segundo, esto se realiza configurando todo los
pines del puerto B como salida y luego se activaran todos los pines mediante un 1 logico
para que el led encienda.
*/

.include "m328pdef.inc" 

.cseg						;Escribo el codigo en la Memoria FLASH
.org 0x0000

jmp main

.org INT_VECTORS_SIZE		;Calcula cuanta memoria deja para los perifericos segun la placa
							;Esa cte esta difinida en m328pdef.inc

main:

;Configuro el Puerto B del Micro

	ldi R16,0xFF		    ;Carga en el registro 16 todos 1 -> 0b11111111
	ldi R17,0x00
	out	DDRB,R16			;Configuro todo el puerto B como salida

ciclo_infinito:

	out PORTB,R16
	rcall tiempo_espera     ;Espera el tiempo configurado en esa Bandera
	out PORTB,R17
	rcall tiempo_espera
	rjmp ciclo_infinito		; Vuelve a iniciar este loop infinito

tiempo_espera:				; confiro el tiempo de espera

	ldi R20, 32
t3: 	ldi R19, 250
t2: 	ldi R18, 250
t1: 	nop						; hasta aca son 4 ciclos de maquina por iteracion -> 250ns

	dec R18					; 250 x 250ns = 62.5us
	brne t1

	dec R19
	brne t2					; 250 x 50us = 15.625ms

	dec R20
	brne t3					; 32 x 15.625ms = 500ms 
							; Con esto logre un retardo de Medio Segundo
	ret						; Vuelve a la linea siguiente de la que fue llamado
