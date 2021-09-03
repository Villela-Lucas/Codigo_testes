.data 
	m1 .word 1 2 3 4 5 6 7 8 9
	m2 .word 2 2 2 2 2 2 2 2 2
	mr .word 0 0 0 0 0 0 0 0 0 
	lado .word 3
.text

soma:	 	 
#	addi $sp, $sp, -20	# aloca 5 itens na pilha
#	sw $a0, 0($sp)		# salva o argumento a0
#	sw $a1, 4($sp)		# salva o argumento a1
#	sw $a2, 8($sp)		# salva o argumento a2
#	sw $a3, 12($sp)		# salva o argumento a3
#	sw $ra, 16($sp)		# salva o endereco de retorno

	la $a0, m1
	la $a1, m2
	la $a2, mr
	la $a3, lado
	
 	 add $t9, $0, 1		# i = 1
 	 mul $s0, $a3, $a3	# s0 = lado*lado
 	 j loop_soma
 	 
 loop_soma: 
 
 	 sll $t0, $t9, 2	# t0 = 4*i
 	 
 	 add $t1, $t0, $a0	# t1 = endereço de m1[i]
 	 add $t2, $t0, $a1	# t2 = endereço de m2[i]
 	 add $t3, $t0, $a2	# t3 = endereço de mr[i]
 	 lw $t4, 0($t1)		# t4 = m1[i]
 	 lw $t5, 0($t2)		# t5 = m2[i]
 	 lw $t6, 0($t3)		# t6 = mr[i]
 	 
 	 add $t6, $t4, $t5	# 
 	 sw $t6, 0($t3)		# mr[i] = m1[i] + m2[i]
 	 
 	 slt $t7, $t9, $s0	#
 	 bne $t7, 1, exit_soma	# 
 	 add $t9, $t9, 1	# i++
 	 j loop_soma		#
 	 
	
exit_soma:	
#	lw $a0, 0($sp)		# restaura o argumento a0
#	lw $a1, 4($sp)		# restaura o argumento a1
#	lw $a2, 8($sp)		# restaura o argumento a2
#	lw $a3, 12($sp)		# restaura o argumento a3
#	lw $ra, 16($sp)		# restaura o endereco de retorno
#	addi $sp, $sp, 20	#ajusta o stack pointer para liberar 5 itens
	
#	jr $ra
	 
 	 
 	 
 	 