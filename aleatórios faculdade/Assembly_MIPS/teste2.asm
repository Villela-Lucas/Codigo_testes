.data
	ari: .word 0 1 2 3 4 5 6
	space: .asciiz " - "
.text
	la $s0, ari 
	add $s3, $0, $0
	addi $s5, $0, 7
	
loop:
	sll $t1, $s3, 2  # t1= 4*i
	
	add $t1, $t1, $s0 #t1= endereco de save[i]
	lw $t0, 0($t1)    # t0 = save[i]
	
	jal print
	
	slt $t2, $s3, $s5
	bne $t2, 1, exit
	add $s3, $s3, 1 
	j loop 

print:
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	lw $a0, space
	li $v0, 4
	syscall
	
	jr $ra
	
exit:	