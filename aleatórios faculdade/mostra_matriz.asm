.data
	space: .asciiz "  "
	line: .asciiz "\n"
.text

	li $t0, 0		# inicializa contador externo,  i = 0

navegar_matriz_loop_externo:
	bge $t0, $a0, fim_navegar_matriz_loop_externo
	li $t1, 0		#inicializa contador interno, j = 0
	
navegar_matriz_loop_interno:
	bge $t1, $a1, fim_navegar_matriz_loop_interno
	
	add $a0, $0, $t0	# a0 = i
	add $a1, $0, $t1	# a1 = j
	lw $a3, 0($sp)		# $a3 = endereco base de m1
	jal ler_matriz		# ler_matriz(i, j, lado, endereco base)
	add $t2, $v0, $0	# t4 recebe retorno da funcao ler_matriz
	
	lw $a0, 0($t2)		#
	li $v0, 1		# 
	syscall			# imprime os numeros
	
	lw $a0, space		#
	li $v0, 4		#
	syscall			# coloca um espaco entre os numeros
	
	
	add $t1, $t1, 1		# incrementa contador interno
	j navegar_matriz_loop_interno

fim_navegar_matriz_loop_interno:
	add $t0, $t0, 1		#incrementa contador externo
	
	lw $a0, line		#
	li $v0, 4		#
	syscall			# pula a linha
	
	j navegar_matriz_loop_externo
	
fim_navegar_matriz_loop_externo:


