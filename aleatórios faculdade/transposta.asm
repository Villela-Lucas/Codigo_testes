.data
	m1: .word 10000 50000 90000 130000 20000 60000 100000 140000 30000 70000 110000 150000 40000 80000 120000 160000
	mr: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.text

# a0 = matriz 1
# a1 = matriz destino
# a2 = lado

	la $a0, m1
	la $a1, mr
	li $a2, 4

transposta:
	addi $sp, $sp, -16	# aloca 4 espacos na pilha
	sw $a0, 0($sp)		# salva o argumento a0
	sw $a1, 4($sp)		# salva o argumento a1
	sw $a2, 8($sp)		# salva o argumento a2
	sw $ra, 12($sp)		# salva o endereco de retorno
		
percorrer_matriz:
	li $t0, 0		# inicializa contador externo,  i = 0

percorrer_matriz_loop_externo:
	bgt $t0, $a2, fim_percorrer_matriz_loop_externo
	add $t0, $t0, 1		#incrementa contador externo
	li $t1, 1		#inicializa contador interno, j = 1
	
percorrer_matriz_loop_interno:

	add $t1, $t1, 1		# incrementa contador interno	
	bgt $t1, $a2, fim_percorrer_matriz_loop_interno
	
	beq $t0, $t1, L1	# se i==j entao escreve valora da diagonal em mr
	slt $t2, $t0, $t1	# testa se i < j
	bne $t2, 1, L1		# se i > j entao permanece como estava
	
	add $a0, $0, $t1	# a0 = j
	add $a1, $0, $t0	# a1 = i
	lw $a3, 0($sp)		# $a3 = endereco base de m1
	jal ler_matriz		# ler_matriz(j, i, lado, endereco base)
	add $s6, $v0, $0	# s6 recebe retorno da funcao ler_matriz
	
	add $a0, $0, $t1	# a0 = i
	add $a1, $0, $t0	# a1 = j
	lw $a3, 0($sp)		# $a3 = endereco base de m1
	jal ler_matriz		# ler_matriz(i, j, lado, endereco base)
	add $s7, $v0, $0	# s7 recebe retorno da funcao ler_matriz
	
	add $a0, $0, $t1	# a0 = j
	add $a1, $0, $t0	# a1 = i
	lw $a3, 0($sp)		# $a3 = endereco base de m1
	add $s0, $0, $s7	# $s0 = s7 --> Valor a ser escrito (s0 sera tambem argumento de escreve_matriz)
	jal escreve_matriz	# escreve_matriz(j, i, lado, endereco base, valor)
	
	add $a0, $0, $t1	# a0 = i
	add $a1, $0, $t0	# a1 = j
	lw $a3, 0($sp)		# $a3 = endereco base de m1
	add $s0, $0, $s6	# $s0 = s6 --> Valor a ser escrito (s0 sera tambem argumento de escreve_matriz)
	jal escreve_matriz	# escreve_matriz(j, i, lado, endereco base, valor)
	
	
L1:	j percorrer_matriz_loop_interno

fim_percorrer_matriz_loop_interno:
	#add $t0, $t0, 1		#incrementa contador externo
	
	j percorrer_matriz_loop_externo
	
fim_percorrer_matriz_loop_externo:

	li $v0, 10
	syscall
	
#	lw $a0, 0($sp)		# restaura o argumento a0
#	lw $a1, 4($sp)		# restaura o argumento a1
#	lw $a2, 8($sp)		# restaura o argumento a2
#	lw $ra, 12($sp)		# restaura o endereco de retorno
#	addi $sp, $sp, 16	#ajusta o stack poiter para retirar 4 itens
	
#	jr $ra


################
ler_matriz:	
	
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

	jr $ra
################

escreve_matriz:
			
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
	
	jr $ra
