.data 
	ari: .word 0 1 2 3 4 5 6
	size: .word 7
	space: .asciiz " - "
.text

	la $t0, size
	lw $t0, 0($t0)
	la $s0, ari      # base do array
	add $t1, $s0, $zero  # t1 = indice
	
loop:
	beq $t0, $zero, FIM
	
	lw $a0, 0($t1)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, -1
	addi $t1, $t1, 4
	j loop
	
FIM: 
	li $v0, 10
	syscall
	
	
