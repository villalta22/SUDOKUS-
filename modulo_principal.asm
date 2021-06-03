;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			 ;
;							modulo_principal.asm							 ;	
;	  ensambla modulo_principal imprime_cadena sudokus imprime_sudoku		 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.module modulo_principal
	;Constantes
	fin      .equ 0xFF01
	pantalla .equ 0xFF00
	teclado  .equ 0xFF02
	pilaU	 .equ 0xF000
	pilaS	 .equ 0xE000			
	
	;los .globl para acceder a las subrutinas necesarias
	.globl imprime_cadena
	.globl sudokus
	.globl	sudokus_numero
	.globl	sudokus_tamano


	;texto de presentacion:
			limpiar_pantalla:
					.asciz "\33[2J"
					
			titulo:
					.ascii "\33[36m\33[1m\n"
					.ascii "  _______ \n"
					.ascii " |       |_____________  ______ ___  __ _______  \n"
					.ascii " |    ___|   |   |     \/      \| | / /|   |   | \n"
					.ascii " |       |   |   |  |   \   |   | |/ / |   |   | \n"
					.ascii " |___    |   |   |      /   |   |    \ |   |   | \n"
					.asciz " |_______|_______|_____/\______/|_|\__\|_______| \n\n\33[37m\33[0m\n"
			
			menu_imprimir:
					.ascii "\n0)Instrucciones"
					.ascii "\n1)Elegir sudoku"
					.ascii "\n2)Jugar al sudoku"
					.ascii "\33[31m\n3)Salir\33[37m"
					
			menu_seleccion_imprimir:
					.asciz "\n\nSeleccione opcion: "
					
			error_seleccion_imprimir:
					.asciz "\33[33m\nError: Valor no permitido\33[37m"
			
			instrucciones_imprimir:
					.ascii "\n\n\33[1m\33[33m\nINSTRUCCIONES:\33[0m\33[37m\n"
					.ascii "\t Hay que completar las casillas vacias con un   \n"
					.ascii "\t solo numero del 1 al 4. En una misma fila      \n"
					.ascii "\t no puede haber numeros repetidos. En una misma \n"
					.ascii "\t columna no puede haber numeros repetidos.      \n"
					.asciz "\t La solucion del sudoku es unica.               \n"
			
			imprimir_menu_sudoku:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tSeleccione opcion: "
			imprimir_menu_sudoku_1:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tOpcion seleccionada: 1"
			imprimir_menu_sudoku_2:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tOpcion seleccionada: 2"
			imprimir_menu_sudoku_3:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tOpcion seleccionada: 3"
			imprimir_menu_sudoku_4:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tOpcion seleccionada: 4"
			imprimir_menu_sudoku_5:
			.ascii "\n\n\33[1m\33[33m\nELEGIR SUDOKU:\33[0m\33[37m"
			.ascii "\n\tNumero de sudokus disponibles: 5"
			.asciz "\n\tOpcion seleccionada: 5"
			
			sudoku_a_jugar:
			.asciz "\nSudoku numero: "
			
			
			pausa:
					.asciz "\33[7m\nPulse cualquier tecla para continuar...\33[0m"
					

	;variables
			mapa:
			.ascii "\n\t ---------"
			.ascii "\n\t | | | | |"
			.ascii "\n\t ---------"
			.ascii "\n\t | | | | |"
			.ascii "\n\t ---------"
			.ascii "\n\t | | | | |"
			.ascii "\n\t ---------"
			.ascii "\n\t | | | | |"
			.ascii "\n\t ---------"
			.ascii "\n\t  1 2 3 4 "
			.ascii "\n\t  5 6 7 8 "
			.ascii "\n\t  9 A B C "
			.asciz "\n\t  D E F G \n" 
			sud: 
			.byte 0
			salto_cuatro:
			.byte 0
			mapa_duplica:
			.asciz "                "
	programa:
			;cargamos las pilas en direcciones seguras
			ldu #pilaU
			lds #pilaS
			;Se imprime el menu y se actua segun el valor recibido
	
	menu_seleccion:
			ldx #limpiar_pantalla			
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #mapa
			jsr imprime_cadena
			ldx #menu_imprimir
			jsr imprime_cadena
			
			lda teclado ;cargamos el valor de teclado
			suba #'0
			
			cmpa #0     ;si el valor es 0, mostramos las instrucciones
				beq instrucciones
			cmpa #1     ;si el valor es 1, mostramos elegir sudoku
				beq elegir_sudoku
			cmpa #2     ;si el valor es 2, se comienza la partida
				lbeq iniciar_partida
			cmpa #3
				lbeq acabar
			
			error_menu_seleccion:
				ldx #error_seleccion_imprimir ;.asciz"\nError:Valor no permitido\n"
				jsr imprime_cadena
				ldx #pausa
				jsr imprime_cadena
				lda teclado
				
				bra menu_seleccion	;si no es ninguno de los anteriores se repite la instruccion
				
;;;;;;;;;;;;;;;;;;;;;
;   INSTRUCCIONES	;
;;;;;;;;;;;;;;;;;;;;;
			
	instrucciones:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #instrucciones_imprimir
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado ;como el system pause de c
			bra menu_seleccion
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	ELEGIR SUDOKU				     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
	elegir_sudoku:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku
			jsr imprime_cadena
			
			lda teclado
			sta sud
			suba #'0

			cmpa #1
			;switch 1	;si el valor es 1 cargamos el sudoku 1
				beq elegir_sudoku_1
				
			cmpa #2
			;switch 2	;si el valor es 2 cargamos el sudoku 2
				beq elegir_sudoku_2
				
			cmpa #3
			;switch 3	;si el valor es 3 cargamos el sudoku 3
				beq elegir_sudoku_3
				
			cmpa #4
			;switch 4	;si el valor es 4 cargamos el sudoku 4
				beq elegir_sudoku_4
				
			cmpa #5
			;switch 5	;si el valor es 5 cargamos el sudoku 5
				lbeq elegir_sudoku_5
				
			
				error_sudoku_seleccion:
				ldx #error_seleccion_imprimir ;.asciz"\nError:Valor no permitido\n"
				jsr imprime_cadena
				ldx #pausa
				jsr imprime_cadena
				lda teclado
				
				bra elegir_sudoku	;si no es ninguno de los anteriores se repite la instruccion
				
	elegir_sudoku_1:

			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku_1
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado 
			lbra menu_seleccion
	elegir_sudoku_2:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku_2
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado 
			lbra menu_seleccion
	elegir_sudoku_3:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku_3
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado 
			lbra menu_seleccion
	elegir_sudoku_4:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku_4
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado 
			lbra menu_seleccion
	elegir_sudoku_5:
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #imprimir_menu_sudoku_5
			jsr imprime_cadena
			ldx #pausa
			jsr imprime_cadena
			lda teclado 
			lbra menu_seleccion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		JUGAR PARTIDA		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	iniciar_partida:
		;presentacion del juego
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
			ldx #sudoku_a_jugar
			jsr imprime_cadena
			lda sud
			sta pantalla
			ldb #'\n
			stb pantalla
			cargar_sudoku:
					ldy #mapa_duplica
					ldx #sudokus
					lda sud
					suba #'0
					deca 
					ldb #16
					mul 
					;D=(sud-1)*16 
					leax b,x
					;bucle carga
					lda #0
					b_for: cmpa #16
						 		beq f_seguir
						 				ldb ,x+
						 				stb ,y+
						 				adda #1
						 		bra b_for
						f_seguir:
					ldx #mapa_duplica
					ldb #4
					stb salto_cuatro
					lda #18
					f_for: cmpa #0
							beq fseguir
								ldb ,x+
								stb pantalla
								deca 
									ldb salto_cuatro
									subb #1
									stb salto_cuatro
									cmpb #0
									beq retorno_fila
									bra f_for
									retorno_fila:
										pshs a
										lda #'\n
										sta pantalla
										ldb #4
										stb salto_cuatro
										puls a
						;			cmpa #4
						;				lda #'\n
						;				sta pantalla
								bra f_for
										
					fseguir:
			
			
			ldx #pausa
			lda teclado
			jsr imprime_cadena 
			lbra menu_seleccion	
		;;;;;;;;;;;;;;;	
		;cargamos el sudoku		
	  
				
				

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		SALIR DEL JUEGO		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	acabar:
			clra
			sta fin
			.area FIJA(ABS)
			.org 0xFFFE ;vector de RESET
			.word programa 	
	
