;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																			 ;
;							sudokus.asm							             ;	
;																			 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	.module sudokus

	.globl 	sudokus
	.globl	sudokus_numero
	.globl	sudokus_tamano

sudokus_tamano:		.byte	4
sudokus_numero:		.byte	5
sudokus:
		.ascii	"  32"
		.ascii	"3 4 "
		.ascii	"2   "
		.ascii	" 32 "

		.ascii	" 24 "
		.ascii	"3  1"
		.ascii	"    "
		.ascii	"23 4"

		.ascii	"   4"
		.ascii	" 432"
		.ascii	"   3"
		.ascii	"432 "

		.ascii	"  3 "
		.ascii	"23  "
		.ascii	"  4 "
		.ascii	"3 2 "

		.ascii	"    "
		.ascii	"234 "
		.ascii	"3 2 "
		.ascii	" 2 3"

