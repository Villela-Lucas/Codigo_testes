.data
	m1: .word 10 20 30 40 50 60 70 80 90
	i: .word 2
	jota: .word 2
	lado: .word 3
.text

# $a0 ---> i
# $a1---> j
# $a2---> lado 
# $a3---> endereco base

	

ler_matriz:	
#	addi $sp, $sp, -20	# aloca 5 itens na pilha
#	sw $a0, 0($sp)		# salva o argumento a0
#	sw $a1, 4($sp)		# salva o argumento a1
#	sw $a2, 8($sp)		# salva o argumento a2
#	sw $a3, 12($sp)		# salva o argumento a3
#	sw $ra, 16($sp)		# salva o endereco de retorno

	
	li $a0, 1
	li $a1, 2
	la $a2, 3
	la $a3, m1
	
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
	
#	lw $a0, 0($sp)		# restaura o argumento a0
#	lw $a1, 4($sp)		# restaura o argumento a1
#	lw $a2, 8($sp)		# restaura o argumento a2
#	lw $a3, 12($sp)		# restaura o argumento a3
#	lw $ra, 16($sp)		# restaura o endereco de retorno
#	addi $sp, $sp, 20	#ajusta o stack pointer para liberar 5 itens 
	
# 	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	