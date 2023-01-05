# Configuração - Bitmap Display:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:		.word	0x10008000
	keyboardAddress:	.word	0xffff0004
	eventAddress:		.word	0xffff0000 
	
	background_color:	.word	0xebe1ce
	black_color:		.word	0x1e1e1e
	white_color:		.word	0xe8e8e8
	gray_color:		.word	0x919191
	click_color:		.word	0x595959
	
	max_grid:		.word 	4096
	
	inicio_do1:		.word 	1024
	inicio_do1S:		.word	1032
	
	inicio_re1:		.word	1036
	inicio_re1S:		.word	1044
	
	inicio_mi1:		.word	1048
	
	inicio_fa1:		.word	1056
	inicio_fa1S:		.word	1064
	
	inicio_sol1:		.word	1068
	inicio_sol1S:		.word	1076
	
	inicio_la1:		.word	1080
	inicio_la1S:		.word	1088
	
	inicio_si1:		.word	1092

.text
	.globl inicio
	
	inicio:
		le:
			lw $t4, eventAddress
			lw $t4, ($t4)
			bnez $t4, identifica
			
			j le
			
		identifica:
			lw $t4, keyboardAddress
			lw $t4, ($t4)
			
			li $t5, 0
			
			beq $t4, 'x', fim

			beq $t4, 'a', do1
			beq $t4, 'w', doS1
			
			beq $t4, 's', re1
			beq $t4, 'e', reS1
			
			beq $t4, 'd', mi1
			
			beq $t4, 'f', fa1
			beq $t4, 't', faS1
			
			beq $t4, 'g', sol1
			beq $t4, 'y', solS1
			
			beq $t4, 'h', la1
			beq $t4, 'u', laS1
			
			beq $t4, 'j', si1
			
			j inicio
			
			do1:
				lw $t4, inicio_do1
				j pinta_tela
			doS1:
				lw $t4, inicio_do1S
				li $t5, 1
				j pinta_tela
				
			re1:
				lw $t4, inicio_re1
				j pinta_tela
			reS1:
				lw $t4, inicio_re1S
				li $t5, 1
				j pinta_tela
				
			mi1:
				lw $t4, inicio_mi1
				j pinta_tela
			
			fa1:
				lw $t4, inicio_fa1
				j pinta_tela
			faS1:
				lw $t4, inicio_fa1S
				li $t5, 1
				j pinta_tela
				
			sol1:
				lw $t4, inicio_sol1
				j pinta_tela
			solS1:
				lw $t4, inicio_sol1S
				li $t5, 1
				j pinta_tela
				
			la1:
				lw $t4, inicio_la1
				j pinta_tela
			laS1:
				lw $t4, inicio_la1S
				li $t5, 1
				j pinta_tela
				
			si1:
				lw $t4, inicio_si1
				j pinta_tela
		
		pinta_tela:
		
			lw $t0, displayAddress	# $t0 stores the base address for display
			
			#Pinta o fundo da imagem
			li $t3, 0
			lw $t1, background_color
			lw $t2, max_grid
			jal pinta_bitmap
			
			li $t3, 1024
			add $t0, $t0, $t3
			lw $t1 gray_color
			lw $t2, max_grid
			sub $t2, $t2, $t3
			jal pinta_bitmap
			
			#Pinta as teclas brancas
			lw $t1, white_color
			
			lw $t3, inicio_do1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_re1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_mi1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_fa1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_sol1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_la1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			lw $t3, inicio_si1
			add $t0, $t0, $t3
			addi $t2, $t3, 64
			jal pinta_coluna_dupla_bitmap
			
			#Pinta as teclas pretas
			lw $t1, black_color
			
			lw $t3, inicio_do1S
			add $t0, $t0, $t3
			addi $t2, $t3, 44
			jal pinta_coluna_simples_bitmap
			
			lw $t3, inicio_re1S
			add $t0, $t0, $t3
			addi $t2, $t3, 44
			jal pinta_coluna_simples_bitmap
			
			lw $t3, inicio_fa1S
			add $t0, $t0, $t3
			addi $t2, $t3, 44
			jal pinta_coluna_simples_bitmap
			
			lw $t3, inicio_sol1S
			add $t0, $t0, $t3
			addi $t2, $t3, 44
			jal pinta_coluna_simples_bitmap
			
			lw $t3, inicio_la1S
			add $t0, $t0, $t3
			addi $t2, $t3, 44
			jal pinta_coluna_simples_bitmap
			
			#Pinta a tecla selecionada
			
			lw $t1, click_color
			
			move $t3, $t4
			add $t0, $t0, $t3
			
			beq $t5, 1, sustenido
			beq $t5, 0, normal
			
			j inicio
			
			normal:
				addi $t2, $t3, 64
				jal pinta_coluna_dupla_bitmap
				j inicio
			
			sustenido:
				addi $t2, $t3, 44
				jal pinta_coluna_simples_bitmap
				j inicio
	
		pinta_bitmap:
			sw $t1, 0($t0)
			addi $t3, $t3, 4
			addi $t0, $t0, 4  
			
			beq $t2, $t3, pintado
			j pinta_bitmap
				
		pinta_coluna_dupla_bitmap:
			sw $t1, 0($t0)
			addi $t0, $t0, 4
			sw $t1, 0($t0)
			
			addi $t3, $t3, 4
			addi $t0, $t0, 124
			
			beq $t2, $t3, pintado
			
			j pinta_coluna_dupla_bitmap
		
		pinta_coluna_simples_bitmap:
			sw $t1, 0($t0)
			addi $t3, $t3, 4
			addi $t0, $t0, 128
			
			beq $t2, $t3, pintado
			
			j pinta_coluna_simples_bitmap
			
		pintado:
			lw $t0, displayAddress
			jr $ra
			
	fim:
		li $v0, 10	# código para encerrar o programa
		syscall		# executa a chamada do SO para encerrar
