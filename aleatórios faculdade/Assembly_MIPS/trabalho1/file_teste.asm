.data

file:		.asciiz "db.txt"
buffer:		.asciiz	"se fuder"
a1:		.space 128
newline:	.asciiz	"\r\n"		# Needs the "\r" before "\n" to work in Windows. Others SOs the "\r" can be deleted without errors

.text

#########################################
#	Create file
#########################################
openfile:
	li $v0, 13			# Load open file syscall in $v0
	la $a0, file			# Save in $a0 string containing filename
	li $a1, 1			# Flag
	li $a2, 0			# Mode (ignored)
	syscall				# System call
	move $s0, $v0			# Save file descriptor in $s0
	slt $t0, $v0, $0		# sets $t0 to 1 if file creation error
	beq $t0, 1, openfile		# if error on creation file, try create again
	add $t0, $t0, $0		# Clean t0
#########################################
# 	Write in file
#########################################	
writefile:
	li $v0, 15			# Load write file syscall
	move $a0, $s0			# Load a0 with file descriptor
	la $a1, buffer			# Load string stored in "buffer"
	li $a2, 150			# set the size of string written
	syscall				# System call
	li $v0, 15			# 
	move $a0, $s0			#
	la $a1, newline			#
	li $a2, 2			#
	syscall				#
	add $t0, $t0, 1 		#
	bne $t0, 10, writefile		#
#########################################
#	Read file
#########################################
readfile:
	li $v0, 14
	move $a0, $s0
	la $a1, a1
	li $a2, 150
	syscall	
	move $s1, $v0
	
borave:
	lw $t0, ($a1)
	li $v0, 4
	la $a0, ($a1)
	syscall
#########################################
#	End program 
#########################################
end:
	li $v0, 16
	move $a0, $s0
	li $v0, 10
	syscall

