# Configuração - Bitmap Display:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:		.word	0x10008000
	background_color:	.word	0xebe1ce
	max_grid:		.word 	4096

.text
	.globl inicio
	
	inicio:
	
		lw $t0, displayAddress	# $t0 stores the base address for display
		
		li $t3, 0
		lw $t1, background_color
		lw $t2, max_grid
		jal pinta_background
		
		j   fim			# encerra o programa
	
	pinta_background:
		sw $t1, 0($t0)
		addi $t3, $t3, 4
		addi $t0, $t0, 4  
		
		beq $t2, $t3, pintado
		j pinta_background
		
		pintado:
			lw $t0, displayAddress
			jr $ra		
		
	fim:
		li $v0, 10	# código para encerrar o programa
		syscall		# executa a chamada do SO para encerrar
