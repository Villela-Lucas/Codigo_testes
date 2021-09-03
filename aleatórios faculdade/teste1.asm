.data
	save: .word 5 5 5 5 5 5 5 5 6 7 8
.text

	add $s3, $0, $0  # i = 0
	addi $s5, $0, 5  # k = 5
	la $s6, save 
	
Loop:
	sll $t1, $s3, 2  # t1= 4*i
	
	add $t1, $t1, $s6 #t1= endereco de save[i]
	lw $t0, 0($t1)    # t0 = save[i]
	
	bne $s5, $t0, Exit # if save[i]=!5 então Exit
	add $s3, $s3, 1 
	j Loop 
	
	
	
Exit:	
