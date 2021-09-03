.data

	A: .word 0x00000007
.text

	la $s0, A
	addi $s1, $0, 3  	# i = 3
	addi $s2, $0, 2  	# g = 2
	  
	sll $t0, $s1, 2
	add $t1, $t0, $s0
	lw $t1, 0($t1)  	# t2 = A[i] **********
	
	lw $t3, 0($s0)  	# t3 = A[0]
	
	sub $t4, $t2, $t3 	# A[i] - A[0]
	
	add $t5, $t4, $s2  	# g + A[i] - A[0]
	
	add $t6, $s1, $s2 	# g+i
	sll $t6, $t6, 2  	# 4*(g+i)
	add $t7, $t6, $s0	#
	sw $t7, 0($t7)  	# A[g+i] = soma       *************
	