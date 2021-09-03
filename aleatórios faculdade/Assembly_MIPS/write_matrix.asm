.data
	m1: .word 100 200 300 400 500 600 700 800 900
.text

# $a0 ---> i
# $a1---> j
# $a2---> lado 
# $a3---> endereco base
# $s0--> valor

escreve_matriz:
#	addi $sp, $sp, -24	# aloca 6 espacos na pilha
#	sw $a0, 0($sp)		# salva o argumento a0
#	sw $a1, 4($sp)		# salva o argumento a1
#	sw $a2, 8($sp)		# salva o argumento a2
#	sw $a3, 12($sp)		# salva o argumento a3
#	sw $s0, 16($sp)		# salva o argumento extra s0
#	sw $ra, 20($sp)		# salva o endereço de retorno

	li $a0, 1
	li $a1, 1
	li $a2, 3
	la $a3, m1
	li $s0, 666
			
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
	
#	lw $t5, 16($sp)		# t5 recebe valor do argumento s0	
#	lw $a0, 0($sp)		# restaura o argumento a0
#	lw $a1, 4($sp)		# restaura o argumento a1
#	lw $a2, 8($sp)		# restaura o argumento a2
#	lw $a3, 12($sp)		# restaura o argumento a3
#	lw $ra, 20($sp)		# restaura o endereco de retorno
#	addi $sp, $sp, 24	# ajusta o stack pointer para retirar 6 itens
	
	sw $s0, -4($t4)		# Valor de argumento escrito no endereco de memoria apropriado
	
#	jr $ra
	
	
	
