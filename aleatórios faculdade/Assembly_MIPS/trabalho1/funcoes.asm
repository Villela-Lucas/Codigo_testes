.data

file:		.asciiz			"db.txt"
buffer:		.asciiz			"meu pau"
newline:	.asciiz 		"\r\n"		# Needs the "\r" before "\n" to work in Windows. Others SOs the "\r" can be deleted without errors
newfield:	.asciiz 		";"

space:		.space 64

CompleteName:	.asciiz
ShortName:	.asciiz
Email:		.asciiz
Phone:		.asciiz
ID:		.word	

.text

#########################################
#	Menu principal
#########################################


	
	


#########################################
#	Write/create file
#########################################

write:
	# opening file for writing
	li $v0, 13			# Load open file syscall in $v0
	la $a0, file			# Save in $a0 string containing filename
	li $a1, 9			# Flag write only
	li $a2, 0			# Mode (ignored)
	syscall				# System call
	move $s0, $v0			# Save file descriptor in $s0
	slt $t0, $v0, $0		# sets $t0 to 1 if file creation error
	beq $t0, 1, write		# if error on creation file, try create again
	add $t0, $t0, $0		# Clean t0

	# writing
	li $v0, 15			# Load write file syscall
	move $a0, $s0			# Load a0 with file descriptor
	la $a1, buffer			# Load string stored in $s2 ("buffer")
	li $a2, 150			# set the size of string written
	syscall				# System call
	
	# Close the file 
  	li $v0, 16    			# system call for close file
 	move $a0, $s0    		# file descriptor to close
 	syscall           		# close file


#########################################
#	Read file
#########################################

read:
 	#opening file for reading
 	li $v0, 13			# Load open file syscall in $v0
	la $a0, file			# Save in $a0 string containing filename
	li $a1, 0			# Flag read only
	li $a2, 0			# Mode (ignored)
	syscall				# System call
	move $s0, $v0			# Save file descriptor in $s0
	slt $t0, $v0, $0		# sets $t0 to 1 if file reading error
	beq $t0, 1, read		# if error on reading file, try read again
	add $t0, $t0, $0		# Clean t0

	# reading
	li $v0, 14			# Load reading syacall
	move $a0, $s0			# Save in $a0 string containing file descriptor
	la $a1, space			# Address of input buffer in $s3
	li $a2, 150			# Maximum of 150 characters to read
	syscall				# System call
	
	# Close the file 
  	li $v0, 16    			# system call for close file
 	move $a0, $s0    		# file descriptor to close
 	syscall           		# close file

 	
print:
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

#########################################
#	STRING LENGTH
#########################################
str_length:					#Nao coloca os espacos em branco

li $t3, 0 					#conta numero de letras
linha2:
	lbu $t5, 0($a0)
	beq $t5, $zero, sai2
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j linha2
sai2:
	move $v0, $t3
	jr $ra 
