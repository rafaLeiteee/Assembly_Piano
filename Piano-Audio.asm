.data
	# Endereço de armazenamento do caractere pressionado na ferramenta keyboard and display
	teclado: .word 0xffff0004
	
	# Endereço de verificação da ocorrencia de evento na ferramenta keyboard and display
	evento: .word 0xffff0000 
	
	# Vetor de ajuste do número da tabela ASCII para o valor do tom correspondente
	tons: .word 60,0, 0,64,63,65,67,69, 0,71,72, 0, 0, 0, 0, 0,62, 0,62,66,70, 0,61, 0,68, 0, 0
	      #      0,1,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26

.text
.globl main
main:
	# Carrega o registrador com o valor 4 que sará usado para caminhar pelos indices do vetor
	li $s0, 4

	# Loop de verificação de entrada
	le:
	lw $t0, evento
	lw $t0, ($t0)
	bnez $t0, toca
	j le
	
	# Quando ocorrer uma enteada no teclado a nota devera ser tocada
	toca:
	
	# Extrai o valor ASCII
	lw $t0, teclado
	lw $t0, ($t0)
	
	# Caso seja o valor correspondente a 'x' o programa é encerrado
	beq $t0, 'x', fim
	
	# Subtrai-se 97 para ajustar a entrada ao indice do vetor(de 0 a 26 letras do alfabeto)
	subi $t0, $t0, 97
	# Multiplica por 4(tamanho em bytes de inteiro) para que se encontre a posição no vetor
	mult $t0, $s0
	mflo $t0
	# Extrai o valor do tom e coloca no registrador
	lw $t0, tons($t0)
	
	# Toca-se a nota	
	li $v0, 31 	# Syscall correspondente
	li $a1, 1000	# Tempo em milisegundos
	li $a2, 0	# Instrumento piano
	li $a3 100	# Volume
	syscall
	
	# Retorna para o loop de leitrura e aguarda outra entrada
	j le
	
fim:
	li $v0, 10
	syscall
