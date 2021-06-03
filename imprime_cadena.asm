;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			 ;
;							imprime_cadena.asm			   					 ;	
;																			 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.module imprimir_cadena
	pantalla .equ 0xFF00
	.globl imprime_cadena
	
	imprime_cadena:
			;cargamos a con un valor por si esta el \0 acumulado
			lda #1
			recorrer_cadena:
					;si es el caracter \0 se termina de imprimir
					cmpa #'\0
					beq fin_recorrer_cadena
					;cargamos un elemento de la cadena, incrementamos X y lo imprimimos por pantalla
					lda ,x+
					sta pantalla
					;volvemos al principio del bucle
					bra recorrer_cadena
			fin_recorrer_cadena:
			;return
			rts
