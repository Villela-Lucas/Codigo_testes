.data
	x: .word 0x00000000
	y: .word 0x0000000A	

.text
	la $s0, y
	la $s1, x
	
	lw $t0, 0($s0)
	lw $t1, 0($s1)
	
	add $t2, $t0, $t1
