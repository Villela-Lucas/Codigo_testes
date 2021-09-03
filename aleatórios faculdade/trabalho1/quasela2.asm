.data

Id:			.asciiz "Id:00000000" 
write_newline:		.asciiz	";\r\n"
newline:		.asciiz	"\r\n"	
tab:			.asciiz "/"
campo:			.asciiz "Digite: \n1- Novo Registro\n2-Editar Registro\n3-Consultar Registro\n4- Visualizar Registro\n5-Apagar Registro\n6-Sair"
campo1:			.asciiz "Nome Completo:"
campo2:			.asciiz "Nome Curto:"
campo3:			.asciiz "E-mail:"
campo4:			.asciiz "Numero:(99)9999-9999"

error:			.asciiz "Entrada Invalida"
error_noData:		.asciiz	"Campo vazio"
error_size_exceeded:	.asciiz	"Tamanho excedido"

comparacao:		.asciiz "Digite a letra do nome completo:"
registro_apaga:		.asciiz "Digite o Id a ser apagado:"

escolha:		.space 1
nome_completo: 		.space 200			#Salva o nome completo escrito
nome_curto: 		.space 30			#Salva o nome completo curto
email:			.space 150			#Salva o email escrito
telefone:		.space 14			#Salva o numero escrito
letra_comparacao:	.space 1
linha:			.space 398
confirma:		.asciiz "Deseja continuar com a operacao"
file:			.asciiz "mm.txt"
lido:			.asciiz ""
.text

j menu
######################## ERROS ########################################
size_exceeded:
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	beq $s2, 1, menu		#s2 possui a parte em que estamos no programa (s2=1 => menu; s2=2 =>nome_completo; s2=3 =>nome_curto; s2=4 =>email; s2=5 => telefone) 
	beq $s2, 2, main_completo
	beq $s2, 3, main_curto
	beq $s2, 4, main_email
	beq $s2, 5, main_tel
noData:						
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	beq $s2, 1, menu
	beq $s2, 2, main_completo
	beq $s2, 3, main_curto
	beq $s2, 4, main_email
	beq $s2, 5, main_tel
###########################OPEN FILE##################################
openfile:
		li $v0, 13				# Load open file syscall in $v0
		la $a0, file				# Save in $a0 string containing filename
		li $a1, 9				# Flag
		beq $s4, '1', continua
		li $a1, 0
		continua:
		li $a2, 0				# Mode (ignored)
		syscall					# System call
		move $s0, $v0				# Save file descriptor in $s0
		slt $t0, $v0, $0			# sets $t0 to 1 if file creation error
		beq $t0, 1, openfile			# if error on creation file, try create again
		add $t0, $0, $0
		beq $s4, '1', novo_registro
		beq $s4, '3', readfile
		beq $s4, '4', readfile
		beq $s4, '5', readfile
####################APAGA O ARQUIVO .TXT###########################################
apaga:
openfile1:
		li $v0, 13				# Load open file syscall in $v0
		la $a0, file				# Save in $a0 string containing filename
		li $a1, 1				# Flag
		li $a2, 0				# Mode (ignored)
		syscall					# System call
		move $s0, $v0				# Save file descriptor in $s0
		slt $t0, $v0, $0			# sets $t0 to 1 if file creation error
		beq $t0, 1, openfile1			# if error on creation file, try create again
		add $t0, $0, $0
		
writefile1:
		li $v0, 15				# Load write file syscall
		move $a0, $s0
		la $a1, escolha
		li $a2, 0
		syscall
closefile1:
		li $v0, 16
		move $a0, $s0
		syscall
		j conta_numlinhas
########################################################################################
#################READ FILE##########################
	readfile:
		li $v0, 14
		move $a0, $s0
		la $a1, lido
		li $a2, 398000
		syscall
		li $v0, 16
		move $a0, $s0
		syscall
		beq $s4, '3', conta_numlinhas
		beq $s4, '4', conta_numlinhas
		beq $s4, '5', apaga
#####################NUMERO DE LINHAS####################
conta_numlinhas:
addi $t2, $0, 0
addi $s3, $0, 0						#numero de linhas
nlinha:
	lbu $t1, lido($t2)
	beq $t1, 0, compara
	beq $t1, ';', soma_linha
	add $t2, $t2, 1
	j nlinha
	soma_linha:
		add $s3, $s3, 1
		add $t2, $t2, 1
		j nlinha
###################COMPARACAO#######################
compara:
	bne $s4, '5', cont
	openfile2:
		li $v0, 13				# Load open file syscall in $v0
		la $a0, file				# Save in $a0 string containing filename
		li $a1, 9				# Flag
		li $a2, 0				# Mode (ignored)
		syscall					# System call
		move $s0, $v0				# Save file descriptor in $s0
		slt $t0, $v0, $0			# sets $t0 to 1 if file creation error
		beq $t0, 1, openfile2			# if error on creation file, try create again
		add $t0, $0, $0
	cont:	
	addi $t2, $0, 0
	addi $t3, $0, 0
	addi $t4, $0, 0
	beq $s4, '4', pula
	li $v0, 54
	la $a0, comparacao
	bne $s4, '5', muda
	la $a0, registro_apaga
	muda:
	beq $a1, -2, fim
	la $a1, letra_comparacao
	li $a2, 2
	syscall
	pula:
	lbu $t5, letra_comparacao($0)			#$t5 tem a letra a ser comparada
	loop:
	lbu $t1, lido($t2)
	beq $t1, 0, close_file
	beq $t1, ';', igual
	sb $t1, linha($t4)				#coloca os bytes no vetor linha ate chegar ao caractere ;
	add $t4, $t4, 1
	add $t2, $t2, 1
	j loop						#compara se o primeiro caractere eh o desejado

zerar_linha:
	beq $t4, $0, loop
	sb $0, linha($t4)
	addi $t4, $t4, -1
	j zerar_linha
igual:
	beq $s4, '5', igual1
	sb $t1, linha($t4)
	beq $t3, $s3, close_file
	lbu $t1, linha($0)
	beq $s4, '4', print
	beq $t1, $t5, print
	addi $t3, $t3, 1
	addi $t2, $t2, 3
	j zerar_linha
igual1:
	sb $t1, linha($t4)
	beq $t3, $s3, close_file
	lbu $t1, linha($0)
	bne $t1, $t5, gravar
	addi $t3, $t3, 1
	addi $t2, $t2, 3
	j zerar_linha
#####################################################################################
gravar:
	writefile2:
		li $v0, 15				# Load write file syscall
		move $a0, $s0				# Load a0 with file descriptor
		la $a1, linha
		move $a2, $t4
		syscall
		li $v0, 15				# 
		move $a0, $s0				#
		la $a1, write_newline				#
		li $a2, 3				#
		syscall	
		addi $t2, $t2, 3
		addi $t3, $t3, 1
		j zerar_linha
	closefile2:
		li $v0, 16
		move $a0, $s0
		syscall
##############################PRINT###################################################
print:
	li $v0, 4
	la $a0, linha
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $t3, $t3, 1
	addi $t2, $t2, 3
	j zerar_linha
########################################################################################
###########################OPCAO 1 - NOVO REGISTRO##################################
novo_registro:
	#################PEGA AS INFORMACOES##########################
	main_completo:
		li $v0, 54				#Input Dialog string
		la $a0, campo1				#A mensagem que aparece esta no endereco do campo1
		la $a1, nome_completo			#O que foi digitado vai para o endereco nome_completo
		li $a2, 201				#O tamanho escolhido foi de 201 caracteres (maior do que os 150 determinados no roteiro)
		syscall
		li $s2, 2				#Quando S2 = 2, significa que estamos na parte main_completo
		beq $a1, -2, fim			#Se o usuario cancelar, finaliza o programa
		beq $a1, -3, noData			#Se o usuario nao digitar nada, vai para noData
		beq $a1, -4, size_exceeded		#Se o usuario digitar mais caracteres do que o permitido, vai para size_exceeded
####################################################################
	main_curto:
		li $v0, 54				#Input Dialog string
		la $a0, campo2				#A mensagem que aparece esta no endereco do campo2
		la $a1, nome_curto			#O que foi digitado vai para o endereco nome_curto
		li $a2, 31				#O tamanho escolhido foi de 30 caracteres
		syscall
		li $s2, 3				#Quando S2 = 3, significa que estamos na parte main_curto
		beq $a1, -2, fim			#Se o usuario cancelar, finaliza o programa
		beq $a1, -3, noData			#Se o usuario nao digitar nada, vai para noData
		beq $a1, -4, size_exceeded		#Se o usuario digitar mais caracteres do que o permitido, vai para size_exceeded
#####################################################################
	main_email:
		li $v0, 54				#Input Dialog string
		la $a0, campo3				#A mensagem que aparece esta no endereco do campo3
		la $a1, email				#O que foi digitado vai para o endereco email
		li $a2, 151				#O tamanho escolhido foi de 151 caracteres (maior do que os 100 determinados no roteiro)
		syscall
		li $s2, 4				#Quando S2 = 3, significa que estamos na parte main_curto
		beq $a1, -2, fim			#Se o usuario cancelar, finaliza o programa
		beq $a1, -3, noData			#Se o usuario nao digitar nada, vai para noData
		beq $a1, -4, size_exceeded		#Se o usuario digitar mais caracteres do que o permitido, vai para size_exceeded
######################################################################
	main_tel:
		li $v0, 54				#Input Dialog string
		la $a0, campo4				#A mensagem que aparece esta no endereco do campo4
		la $a1, telefone			#O que foi digitado vai para o endereco telefone
		li $a2, 15				#O tamanho escolhido foi de 14 caracteres (numero determinado no roteiro)
		syscall
		li $s2, 5				#Quando S2 = 3, significa que estamos na parte main_curto
		beq $a1, -2, fim			#Se o usuario cancelar, finaliza o programa
		beq $a1, -3, noData			#Se o usuario nao digitar nada, vai para noData
		beq $a1, -4, size_exceeded		#Se o usuario digitar mais caracteres do que o permitido, vai para size_exceeded
		j conta_numletras
####################CONTA O NUMERO DE LETRAS############################
conta_numletras:	
li $s2, 2
	letras:						#Nao coloca os espacos em branco
		beq $s2, 2, l_completo			#Se s2 = 2, conta o numero de letras do nome_completo
		beq $s2, 3, l_curto			#Se s2 = 3, conta o numero de letras do nome_curto
		beq $s2, 4, l_email			#Se s2 = 4, conta o numero de letras do email
		beq $s2, 5, l_tel			#Se s2 = 5, conta o numero de letras do telefone
		beq $s2, 6, close_file			#Se s2 = 6, ja contou o numero de letras de todos os campos, assim vai para close_file
		
		l_completo:				#conta o numero de letras do nome_completo
			la $t4, nome_completo		#carrega em $t4 o endereço de nome_completo
			li $t3, 0			#zera $t3 para contar numero de letras
			j l				#vai para l
			
		l_curto:				#conta o numero de letras do nome_curto
			la $t4, nome_curto		#carrega em $t4 o endereço de nome_curto
			li $t3, 0			#zera $t3 para contar numero de letras
			j l				#vai para l
			
		l_email:				#conta o numero de letras do email
			la $t4, email			#carrega em $t4 o endereço de email
			li $t3, 0			#zera $t3 para contar numero de letras
			j l				#vai para l
			
		l_tel:					#conta o numero de letras do email
			la $t4, telefone		#carrega em $t4 o endereço de telefone
			li $t3, 0			#zera $t3 para contar numero de letras
			j lo				#vai para l
			
	l:						#loop que conta o numero de letras
		lbu $t5, 0($t4)				#carrega em $t5, o caractere no endereço $t4
		beq $t5, 0xa, writefile			#compara o caractere com 0xa (LF - line feed); se for igual, vai para sai
		addi $t4, $t4, 1			#soma 1 no endereço $t4 (para carregar o proximo caractere)
		addi $t3, $t3, 1			#soma 1 no somatorio do total de letras
		j l					#volta para l
	lo:						#loop que conta o numero de letras
		lbu $t5, 0($t4)				#carrega em $t5, o caractere no endereço $t4
		beq $t5, 0xa, writefile
		beq $t5, 0, writefile			#compara o caractere com 0xa (LF - line feed); se for igual, vai para sai
		addi $t4, $t4, 1			#soma 1 no endereço $t4 (para carregar o proximo caractere)
		addi $t3, $t3, 1			#soma 1 no somatorio do total de letras
		j lo
#################WRITE FILE############################################
	writefile:
		li $v0, 15				# Load write file syscall
		move $a0, $s0				# Load a0 with file descriptor
		beq $s2, 2, w_completo			#Se s2 = 2, vai para w_completo
		beq $s2, 3, w_curto			#Se s2 = 3, vai para w_curto
		beq $s2, 4, w_email			#Se s2 = 4, vai para w_email
		beq $s2, 5, w_tel			#Se s2 = 5, vai para w_tel
		w_completo:				#Escreve o conteudo de nome_completo
			addi $s2, $s2, 1		#Soma 1 em $s2 (para na proxima repeticao, ir para w_curto)
			la $a1, nome_completo		#carrega o endereço de nome_completo em $a1
			j write				#vai pra write
		w_curto:				#Escreve o conteudo de nome_curto
			addi $s2, $s2, 1		#Soma 1 em $s2 (para na proxima repeticao, ir para w_email)
			la $a1, nome_curto		#carrega o endereço de nome_curto em $a1
			j write				#vai para write
		w_email:				#Escreve o conteudo de email
			addi $s2, $s2, 1		#Soma 1 em $s2 (para na proxima repeticao, ir para w_tel)
			la $a1, email			#carrega o endereço de email em $a1
			j write				#vai para write
		w_tel:					#Escreve o conteudo de telefone
			addi $s2, $s2, 1		#Soma 1 em $s2 (para sair do loop)
			la $a1, telefone		#carrega o endereço de email em $a1
			j write				#vai para write
		write:
		move $a2, $t3				#Coloca em $a2 o numero total de letras
		syscall					# System call
		beq $s2, 6, newl			#decide se coloca ponto e virgula ou pula para a proxima linha
		li $v0, 15				# 
		move $a0, $s0				#
		la $a1, tab				#
		li $a2, 1				#
		syscall
		j cont1
		newl:				
			li $v0, 15			# 
			move $a0, $s0			#
			la $a1, write_newline		#
			li $a2, 3			#
			syscall				#
		cont1:
		add $t0, $t0, 1 			#
		bne $t0, 1, writefile
		add $t0, $zero, $zero
		j letras
#########################FIM######################################
close_file:
	li $v0, 16
	move $a0, $s0
	syscall
	beq $s4, '1', menu
	beq $s4, '3', menu
	beq $s4, '4', menu
	beq $s4 '5', menu
	j fim
###################################################################
#####################MENU##########################################
menu:
	li $s2, 1			#s2 = 1, significa que estamos no menu
	li $t0, 0
	li $t1, 0
	li $v0, 54
	la $a0, campo
	la $a1, escolha
	li $a2, 2
	syscall
	beq $a1, -4, size_exceeded
	beq $a1, -3, noData
	beq $a1, -2, fim
	la $t1, escolha
	lb $s4, escolha
	li $v0, 50
	la $a0, confirma
	syscall
	bne $a0, 0, menu
	beq $s4, '1', openfile
	beq $s4, '3', openfile
	beq $s4, '4', openfile
	beq $s4, '5', openfile
	beq $s4, '6', fim
	j fim
fim:
	li $v0, 10
	syscall
