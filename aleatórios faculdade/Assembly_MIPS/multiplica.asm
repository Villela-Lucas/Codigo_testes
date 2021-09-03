.data
	m1: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
	m2: .word 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
	mr: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	
.text
# $a0 ---> m1
# $a1---> m2
# $a2---> mr 
# $a3---> lado

	la $a0, m1
	la $a1, m2
	la $a2, mr
	li $a3, 4
	


multiplicar_matriz:	
	
	
	li $t0, 0		# inicializa contador 1,  i = 0

ler_matriz_loop_1:
	bgt $t0, $a3, fim_ler_matriz_loop_1
	li $t1, 0		#inicializa contador 2, j = 0
	add $t0, $t0, 1		#incrementa contador 1
	
ler_matriz_loop_2:
	bgt $t1, $a3, fim_ler_matriz_loop_2
	li $t2, 0		#inicializa contador 3, k = 0
	add $t1, $t1, 1		# incrementa contador 2
	
	
ler_matriz_loop_3:
	add $t2, $t2, 1		# incrementa contador 3
	bgt $t2, $a3, fim_ler_matriz_loop_3

	add $a0, $0, $t0	# a0 = i
	add $a1, $0, $t2	# a1 = k
	add $a2, $0, $a3	# a2 = lado
	la $a3, m1		# $a3 = endereco base de m1
	jal ler_matriz		# ler_matriz(i, k, lado, endereco base)
	add $s6, $v0, $0		# s6 recebe retorno da funcao ler_matriz
	
	add $a0, $0, $t2	# a0 = k
	add $a1, $0, $t1	# a1 = j
	add $a2, $0, $a3	# a2 = lado
	la $a3, m2		# $a3 = endereco base de m2
	jal ler_matriz		# ler_matriz(k, j, lado, endereco base)
	add $s7, $v0, $0		# s7 recebe retorno da funcao ler_matriz
	lw $a3, 12($sp)	
	
	mul $s6, $s6, $s7	# s6 = m1[i][k]*m2[k][j]
	
	add $a0, $0, $t0	# a0 = i
	add $a1, $0, $t1	# a1 = j
	add $a2, $0, $a3	# a2 = lado
	la $a3, mr		# $a3 = endereco base de mr
	jal ler_matriz		# ler_matriz(i, j, lado, endereco base)
	add $s5, $v0, $0	# s5 recebe retorno da funcao ler_matriz
	lw $a3, 12($sp)
	
	add $s6, $s6, $s5	# s6 = m1[i][k]*m2[k][j] + mr[i][j]
	
	add $a0, $0, $t1	# a0 = j
	add $a1, $0, $t0	# a1 = i
	add $a2, $0, $a3	# a2 = lado
	lw $a3, 8($sp)		# $a3 = endereco base de m1
	add $s0, $0, $t3	# $s0 = t3 --> Valor a ser escrito (s0 sera tambem argumento de escreve_matriz)
	jal escreve_matriz	# escreve_matriz(j, i, lado, endereco base, valor)
	
	
	j ler_matriz_loop_3

fim_ler_matriz_loop_3:
	
	j ler_matriz_loop_2

fim_ler_matriz_loop_2:
	
	j ler_matriz_loop_1
	
fim_ler_matriz_loop_1:

	li $v0, 10
	syscall
	
################
ler_matriz:	
	addi $sp, $sp, -16	# aloca 5 itens na pilha
	sw $a0, 0($sp)		# salva o argumento a0
	sw $a1, 4($sp)		# salva o argumento a1
	sw $a2, 8($sp)		# salva o argumento a2
	sw $a3, 12($sp)		# salva o argumento a3
	
	li $t0, 0		# inicializa contador externo,  i = 0

ler_matriz_loop_externo:
	bge $t0, $a0, fim_ler_matriz_loop_externo
	
	li $t1, 0		#inicializa contador interno, j = 0
	
ler_matriz_loop_interno:
	bge $t1, $a1, fim_ler_matriz_loop_interno
	add $t1, $t1, 1		# incrementa contador interno
	j ler_matriz_loop_interno

fim_ler_matriz_loop_interno:
	add $t0, $t0, 1		#incrementa contador externo
	
	j ler_matriz_loop_externo
	
fim_ler_matriz_loop_externo:
	
	mul $t2, $a2, $t0	# t2 = lado*i
	sub $t3, $a2, $t1	# t3 = lado - j
	sub $t4, $t2, $t3	#  (lado*i)+(lado-j)
	sll $t4, $t4, 2		#  4*(lado*i)+(lado-j)
	add $t4, $t4, $a3	#  endereco base + 4*(lado*i)+(lado-j)
	lw $v0, -4($t4)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16	# aloca 5 itens na pilha

	jr $ra
	
################

escreve_matriz:
	addi $sp, $sp, -16	# aloca 5 itens na pilha
	sw $a0, 0($sp)		# salva o argumento a0
	sw $a1, 4($sp)		# salva o argumento a1
	sw $a2, 8($sp)		# salva o argumento a2
	sw $a3, 12($sp)		# salva o argumento a3
			
andar_matriz:
	li $t0, 0		# inicializa contador externo,  i = 0

andar_matriz_loop_externo:
	bge $t0, $a0, fim_andar_matriz_loop_externo
	
	li $t1, 0		#inicializa contador interno, j = 0
	
andar_matriz_loop_interno:
	bge $t1, $a1, fim_andar_matriz_loop_interno
	
	add $t1, $t1, 1		# incrementa contador interno
	
	j andar_matriz_loop_interno

fim_andar_matriz_loop_interno:
	add $t0, $t0, 1		#incrementa contador externo
	
	j andar_matriz_loop_externo
	
fim_andar_matriz_loop_externo:
	mul $t2, $a2, $t0	# t2 = lado*i
	sub $t3, $a2, $t1	# t3 = lado - j
	sub $t4, $t2, $t3	# v0 = (lado*i)+(lado-j)
	sll $t4, $t4, 2		# v0 = 4*(lado*i)+(lado-j)
	add $t4, $t4, $a3	# v0 = endereco base + 4*(lado*i)+(lado-j)
	
	sw $s0, -4($t4)		# Valor de argumento escrito no endereco de memoria apropriado
	
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16	# libera 5 itens da pilha
	
	jr $ra
