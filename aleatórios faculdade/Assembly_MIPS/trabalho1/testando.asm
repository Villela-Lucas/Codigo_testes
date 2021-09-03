.data

newline:	.asciiz	"\r\n"	
tab:		.asciiz ";"
file:		.asciiz "b.txt"

campo:	.asciiz "Digite: \n1- Novo Registro\n2-Editar Registro\n3-Consultar Registro\n4-Apagar Registro\n5-Sair"
campo1: .asciiz "Id:"
campo2:	.asciiz "Nome Completo:"
campo3:	.asciiz "Nome Curto:"
campo4:	.asciiz "E-mail:"
campo5:	.asciiz "Numero:(99)9999-9999"

error:			.asciiz "Entrada Invalida"
error_noData:		.asciiz	"Campo vazio"
error_size_exceeded:	.asciiz	"Tamanho excedido"

space:		.space 1024

escolha:	.asciiz ""
nome_completo: 	.asciiz ""			#Salva o nome completo escrito
nome_curto: 	.asciiz ""			#Salva o nome completo curto
email:		.asciiz ""			#Salva o email escrito
telefone:	.asciiz	""			#Salva o numero escrito
Id:		.word

.text

menu: 						#Abre a caixa inicial (O usuario escolhe o que quer fazer)
	li $t1, 0
	li $t2, 0
	li $v0, 54
	la $a0, campo
	la $a1, escolha
	li $a2, 16
	syscall
	la $t1, escolha
	lbu $t2, 0($t1)
	beq $t2, '1', novo_registro		#Comparacoes  para saber o que o usuario quer fazer
	beq $t2, '2', read
	beq $t2, '3', consultar_registro
	beq $t2, '4', apagar_registro
	beq $t2, '5', fim
	beq $a1, -2, fim			#Uzuario cancelou o programa
	j erro					#A entrada (o que o usuario digitou) eh diferente das escolhas dadas



erro:						#Foi digitada uma entrada invalida no menu
	li $v0, 55
	la $a0, error
	li $a1, 2
	syscall
	j menu
	
novo_registro:
openfile:
	li $v0, 13				# Load open file syscall in $v0
	la $a0, file				# Save in $a0 string containing filename
	li $a1, 9				# Flag
	li $a2, 0				# Mode (ignored)
	syscall					# System call
	move $s0, $v0				# Save file descriptor in $s0
	slt $t0, $v0, $0			# sets $t0 to 1 if file creation error
	beq $t0, 1, openfile			# if error on creation file, try create again
	add $t0, $0, $0
#####################################################################
main: 						#Abre a caixa Nome Completo
	li $v0, 54
	la $a0, campo2
	la $a1, nome_completo
	li $a2, 150
	syscall
	beq $a1, -2, fim			#Se o usuario cancelar, finaliza o programa
	beq $a1, -3, noData
	beq $a1, -4, size_exceeded
	j letras_completo
#####################################################################
noData:						#Aparece a mensagem de erro quando o usuario deixa o campo vazio
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	j main
size_exceeded:					#Aparece a mensagem de erro quando o usuario ultrapassa o limite
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	j main
######################################################################

letras_completo:				#Nao coloca os espacos em branco
la $t4, nome_completo
li $t3, 0					#conta numero de letras
l:
	lbu $t5, 0($t4)
	beq $t5, $zero, sai
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j l
	
sai:
	
#####################################################################	
writefile:					#Escreve no arquivo o Nome Completo e da um tab
	li $v0, 15				# Load write file syscall
	move $a0, $s0				# Load a0 with file descriptor
	la $a1, nome_completo			# Load string stored in "nome"
	move $a2, $t3				# set the size of string written
	syscall					# System call
	li $v0, 15				# 
	move $a0, $s0				#
	la $a1, tab				#
	li $a2, 1				#
	syscall					#
	add $t0, $t0, 1 			#
	bne $t0, 1, writefile
	add $t0, $zero, $zero
#####################################################################
#####################################################################
main1: 						#Abre a caixa Nome Curto
	li $v0, 54
	la $a0, campo3
	la $a1, nome_curto
	li $a2, 150
	syscall
	beq $a1, -2, fim
	beq $a1, -3, noData1
	beq $a1, -4, size_exceeded1
	j letras_curto
#####################################################################
noData1:					#Aparece a mensagem de erro quando o usuario deixa o campo vazio
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	j main1
size_exceeded1:					#Aparece a mensagem de erro quando o usuario ultrapassa o limite
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	j main1
#####################################################################
						#Nao coloca os espacos em branco
letras_curto:
la $t4, nome_curto
li $t3, 0					#conta numero de letras
linha1:
	lbu $t5, 0($t4)
	beq $t5, $zero, sai1
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j linha1
sai1:	
#####################################################################	
writefile1:					#Escreve no arquivo Nome_curto e da um tab
	li $v0, 15				# Load write file syscall
	move $a0, $s0				# Load a0 with file descriptor
	la $a1, nome_curto			# Load string stored in "nome_curto"
	move $a2, $t3				# set the size of string written
	syscall					# System call
	li $v0, 15				# 
	move $a0, $s0				#
	la $a1, tab				#
	li $a2, 1				#
	syscall					#
	add $t0, $t0, 1 			#
	bne $t0, 1, writefile1
	add $t0, $zero, $zero
#####################################################################
#####################################################################
main2:						 #Abre a caixa Email
	li $v0, 54
	la $a0, campo4
	la $a1, email
	li $a2, 150
	syscall
	beq $a1, -2, fim
	beq $a1, -3, noData2
	beq $a1, -4, size_exceeded2
	j letras_email
#####################################################################	
noData2:					#Aparece a mensagem de erro quando o usuario deixa o campo vazio
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	j main2
size_exceeded2:					#Aparece a mensagem de erro quando o usuario ultrapassa o limite
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	j main2
######################################################################
letras_email:					#Nao coloca os espacos em branco
la $t4, email
li $t3, 0 					#conta numero de letras
linha2:
	lbu $t5, 0($t4)
	beq $t5, $zero, sai2
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j linha2
sai2:	
#####################################################################	
writefile2:					#Escreve no arquivo e-mail e da um tab
	li $v0, 15				# Load write file syscall
	move $a0, $s0				# Load a0 with file descriptor
	la $a1, email				# Load string stored in "email"
	move $a2, $t3				# set the size of string written
	syscall					# System call
	li $v0, 15				# 
	move $a0, $s0				#
	la $a1, tab				#
	li $a2, 1				#
	syscall					#
	add $t0, $t0, 1 			#
	bne $t0, 1, writefile2
	add $t0, $zero, $zero

#####################################################################
#####################################################################
main3: 						#Abre a caixa Telefone
	li $v0, 54
	la $a0, campo5
	la $a1, telefone
	li $a2, 150
	syscall
	beq $a1, -2, fim
	beq $a1, -3, noData3
	beq $a1, -4, size_exceeded3
	j letras_telefone
#####################################################################	
noData3:					#Aparece a mensagem de erro quando o usuario deixa o campo vazio
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	j main3
size_exceeded3:					#Aparece a mensagem de erro quando o usuario ultrapassa o limite
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	j main3
######################################################################
letras_telefone:				#Nao coloca os espacos em branco
la $t4, telefone
li $t3, 0					#conta numero de letras
linha3:
	lbu $t5, 0($t4)
	beq $t5, $zero, sai3
	addi $t4, $t4, 1
	addi $t3, $t3, 1
	j linha3
sai3:	
#####################################################################	
writefile3:					#Escreve no arquivo o Telefone e pula a linha
	li $v0, 15				# Load write file syscall
	move $a0, $s0				# Load a0 with file descriptor
	la $a1, telefone			# Load string stored in "telefone"
	move $a2, $t3				# set the size of string written
	syscall					# System call
	li $v0, 15				# 
	move $a0, $s0				#
	la $a1, newline				#
	li $a2, 2				#
	syscall					#
	add $t0, $t0, 1 			#
	bne $t0, 1, writefile3
	add $t0, $zero, $zero
	j fim
#####################################################################


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
 	
 	
editar_registro:
consultar_registro:
apagar_registro:
fim:
	li $v0, 4
 	la $a0, ($a1) 
 	syscall
	li $v0, 10
	syscall
