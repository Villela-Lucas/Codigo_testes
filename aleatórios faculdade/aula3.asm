.data

.text
	addi $a0, $0, 55
	addi $a1, $0, -34
	jal soma
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
soma:
	add $v0, $a0, $a1
	addi $s0, $s0, 100
	jr $ra
	