.data

id:			.space 8
write_newline:		.asciiz	";\r\n"
newline:		.asciiz	"\r\n"	
tab:			.asciiz "/"
campo:			.asciiz "Digite: \n1- Novo Registro\n2-Editar Registro\n3-Consultar Registro\n4- Visualizar Registro\n5-Apagar Registro\n6-Sair"
campo1:			.asciiz "Nome Completo:"
campo2:			.asciiz "Nome Curto:"
campo3:			.asciiz "E-mail:"
campo4:			.asciiz "Numero:(99)9999-9999"

error:			.asciiz "Entrada Invalida"
error_caractere:	.asciiz "Caractere Invalido"
error_noData:		.asciiz	"Campo vazio"
error_size_exceeded:	.asciiz	"Tamanho excedido"
comparacao:		.asciiz "Digite a letra do nome completo:"
registro_apaga:		.asciiz "Digite o Id a ser editado:"
escolha:		.space 1
nome_completo: 		.space 200			#Salva o nome completo escrito
nome_curto: 		.space 30			#Salva o nome completo curto
email:			.space 150			#Salva o email escrito
telefone:		.space 14			#Salva o numero escrito
letra_comparacao:	.space 1
registro_comparacao:	.space 8
linha:			.space 398
confirma:		.asciiz "Deseja continuar com a operacao"
file:			.asciiz "db.txt"
lido:			.asciiz ""
.text

#########################CRIA O ARQUIVO, CASO ELE NAO EXISTA##################################
	li $v0, 13			#COLOCA 13 EM $v0 (PARA ABRIR O ARQUIVO)
	la $a0, file			#CARREGA O ENDERECO DE file EM $a0
	li $a1, 9			# Flag - QUANDO FOR 9 - WRITE ONLY WITH CREATE AND APPEND
	li $a2, 0			#MODE (IGNORED)
	syscall				#CHAMADA AO SISTEMA (ABRE file)
	move $s0, $v0			#SALVA O file descriptor EM $s0
	slt $t0, $v0, $0		#COLOCA $t0 em 1 SE A CRIACAO DO file DER ERRO
	beq $t0, 1, openfile		#SE DER ERRO, TENTA CRIAR file DE NOVO
	add $t0, $0, $0			#ZERA $t0
	li $v0, 16			#COLOCA 16 EM $v0 (PARA FECHAR O ARQUIVO)
	move $a0, $s0			#COLOCA $s0 (file descriptor) em $a0
	syscall				#CHAMADA DE SISTEMA (FECHA O ARQUIVO)
j menu
#####################################################################
########################ERROS########################################
invalido:				#MENSAGEM DE ERRO PARA QUANDO UM CARACTERE UM IVALIDO Eh DIGITADO NO MENU
	li $v0, 55			#COLOCA EM $v0  55 (PARA MOSTRAR UMA MESSAGEDIALOG)
	la $a0, error_caractere		#CARREGA EM $a0 O ENDERECO DE error_caractere
	li $a1, 2			#FAZ APARECER O SIMBOLO DE ERRO
	syscall				#FAZ A CHAMADA AO SISTEMA PARA APARECER A MENSAGEM AO USUARIO
	j menu				#VOLTA AO MENU, PARA O USUARIO ESCOLHER A OPCAO DESEJADA
#####################################################################
size_exceeded:				#MENSAGEM DE ERRO PARA QUANDO UM CARACTERE UM IVALIDO Eh DIGITADO NO MENU
	li $v0, 55			#COLOCA EM $v0 55 (PARA MOSTRAR UMA MESSAGEDIALOG)
	la $a0, error_size_exceeded	#CARREGA EM $a0 O ENDERECO DE error_size_exceeded
	li $a1, 2			#FAZ APARECER O SIMBOLO DE ERRO
	syscall				#FAZ A CHAMADA AO SISTEMA PARA APARECER A MENSAGEM AO USUARIO
	beq $s4, '2', testa_edicao	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA EDITANDO UM REGISTRO (VAI PARA cont)
	beq $s4, '3', compara		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA CONSULTANDO UM REGISTRO (VAI PARA compara)
	beq $s4, '5', testa_edicao	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA APAGANDO UM REGISTRO (VAI PARA cont)
	beq $s2, 1, menu		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA ESCOLHENDO UMA OPCAO NO MENU (VAI PARA menu) 
	beq $s2, 2, main_completo	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O NOME COMPLETO (VAI PARA main_completo)
	beq $s2, 3, main_curto		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O NOME CURTO (VAI PARA main_curto)
	beq $s2, 4, main_email		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O EMAIL (VAI PARA main_email)
	beq $s2, 5, main_tel		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O TELEFONE COMPLETO (VAI PARA main_tel)
######################################################################
noData:					#MENSAGEM DE ERRO PARA QUANDO UM CARACTERE UM IVALIDO Eh DIGITADO NO MENU
	li $v0, 55			#COLOCA EM $v0 55 (PARA MOSTRAR UMA MESSAGEDIALOG)
	la $a0, error_noData		#CARREGA EM $a0 O ENDERECO DE error_noData
	li $a1, 2			#FAZ APARECER O SIMBOLO DE ERRO
	syscall				#FAZ A CHAMADA AO SISTEMA PARA APARECER A MENSAGEM AO USUARIO
	beq $s4, '2', testa_edicao	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA EDITANDO UM REGISTRO (VAI PARA cont)
	beq $s4, '3', compara		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA CONSULTANDO UM REGISTRO (VAI PARA compara)
	beq $s4, '5', testa_edicao	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA APAGANDO UM REGISTRO (VAI PARA cont)
	beq $s2, 1, menu		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA ESCOLHENDO UMA OPCAO NO MENU (VAI PARA menu)
	beq $s2, 2, main_completo	#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O NOME COMPLETO (VAI PARA main_completo)
	beq $s2, 3, main_curto		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O NOME CURTO (VAI PARA main_curto)
	beq $s2, 4, main_email		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O EMAIL (VAI PARA main_email)
	beq $s2, 5, main_tel		#SIGNIFICA QUE O ERRO OCORREU QUANDO O USUARIO ESTAVA DIGITANDO O TELEFONE COMPLETO (VAI PARA main_tel)
######################################################################
###########################OPEN FILE##################################
openfile:					#ABRE O ARQUIVO
		li $v0, 13			#COLOCA 13 EM $v0 (PARA ABRIR O ARQUIVO)
		la $a0, file			#CARREGA O ENDERECO DE file EM $a0
		li $a1, 9			# Flag - QUANDO FOR 9 - WRITE ONLY WITH CREATE AND APPEND
		beq $s4, '1', continua		#SE ESTIVERMOS CRIANDO UM NOVO REGISTRO ($s4 = '1') VAI PARA continua
		li $a1, 0			#SENAO, A FLAG VIRA 0 - READ ONLY
		continua:			#DESVIO PARA QUANDO ESTIVER CRIANDO UM NOVO REGISTRO (MANTEM A FLAG EM 9)
		li $a2, 0			#MODE (IGNORED)
		syscall				#SYSTEM CALL
		move $s0, $v0			#SALVA O file descriptor EM $s0
		slt $t0, $v0, $0		#COLOCA $t0 em 1 SE A CRIACAO DO file DER ERRO
		beq $t0, 1, openfile		#SE DER ERRO, TENTA CRIAR file DE NOVO
		add $t0, $0, $0			#ZERA $t0
		beq $s4, '1', novo_registro	#SIGNIFICA QUE UM NOVO REGISTRO ESTA SENDO CRIADO (VAI PARA readfile)
		beq $s4, '2', readfile		#SIGNIFICA QUE UM NOVO REGISTRO ESTA SENDO CRIADO (VAI PARA readfile)
		beq $s4, '3', readfile		#SIGNIFICA QUE UM NOVO REGISTRO ESTA SENDO CRIADO (VAI PARA readfile)
		beq $s4, '4', readfile		#SIGNIFICA QUE UM NOVO REGISTRO ESTA SENDO CRIADO (VAI PARA readfile)
		beq $s4, '5', readfile		#SIGNIFICA QUE UM NOVO REGISTRO ESTA SENDO CRIADO (VAI PARA readfile)
##################################################################################
####################APAGA O ARQUIVO .TXT###########################################
apaga:						#APAGA O ARQUIVO
###################################################################################
openfile1:
		li $v0, 13			#COLOCA 13 EM $v0 (PARA ABRIR O ARQUIVO)
		la $a0, file			#CARREGA O ENDERECO DE file EM $a0
		li $a1, 1			#Flag 1 - WRITE-ONLY WITH CREATE
		li $a2, 0			#MODE (IGNORED)
		syscall				#SYSTEM CALL
		move $s0, $v0			#SALVA O file descriptor EM $s0
		slt $t0, $v0, $0		#COLOCA $t0 em 1 SE A CRIACAO DO file DER ERRO
		beq $t0, 1, openfile1		#SE DER ERRO, TENTA CRIAR file DE NOVO
		add $t0, $0, $0			#ZERA $t0
		
writefile1:
		li $v0, 15			#COLOCA 15 EM $v0 (PARA ESCREVER O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) em $a0
		la $a1, escolha			#COLOCA EM $a1 O ENDERECO DE escolha
		li $a2, 0			#COLOCA 0 EM $a2 (NUMERO DE CARACTERES SENDO ESCRITOS)
		syscall				#CHAMADA DE SISTEMA (ESCREVE (APAGA) EM file)
closefile1:					
		li $v0, 16			#COLOCA 16 EM $v0 (PARA FECHAR O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) em $a0
		syscall				#CHAMADA DE SISTEMA (FECHA O ARQUIVO)
		j conta_numlinhas		#VAI PARA conta_numlinhas
########################################################################################
#################READ FILE##########################
	readfile:				#LE O ARQUIVO
		li $v0, 14			#COLOCA 14 EM $v0 (PARA LER O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) em $a0
		la $a1, lido			#COLOCA EM $a1 O ENDERECO DE lido
		li $a2, 398000			#COLOCA 398000 EM $a2 (NUMERO DE CARACTERES SENDO ESCRITOS)
		syscall				#CHAMADA DE SISTEMA (LE O ARQUIVO)
		li $v0, 16			#COLOCA 16 EM $v0 (PARA FECHAR O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) em $a0
		syscall				#CHAMADA DE SISTEMA (FECHA O ARQUIVO)
		beq $s4, '2', testa_edicao	#SE $s4 FOR '2' (O USUARIO ESTA EDITANDO UM REGISTRO), VAI PARA apaga
		beq $s4, '3', conta_numlinhas	#SE $s4 FOR '3' (O USUARIO ESTA CONSULTANDO UM REGISTRO), VAI PARA conta_numlinhas
		beq $s4, '4', conta_numlinhas	#SE $s4 FOR '4' (O USUARIO ESTA VISUALIZANDO REGISTROS), VAI PARA conta_numlinhas
		beq $s4, '5', testa_edicao	#SE $s4 FOR '5' (O USUARIO ESTA APAGANDO UM REGISTRO), VAI PARA apaga
#####################NUMERO DE LINHAS####################
conta_numlinhas:				#CONTA O NUMERO DE LINHAS EM lido (NUMERO DE REGISTROS EM lido)
addi $t2, $0, 0					#ZERA $t2 (POSICAO NO ENDERECO)
addi $s3, $0, 0					#ZERA $s3 (NUMERO DE LINHAS)
nlinha:						#LOOP PARA CONTAR O NUMERO DE LINHAS
	lbu $t1, lido($t2)			#CARREGA O BYTE (CARACTERE) DA POSICAO $t2 DO ENDERECO lido E COLOCA EM $t1
	beq $t1, 0, compara			#COMPARA $t1 COM 0 (VAZIO), SE FOR IGUAL VAI PARA compara
	beq $t1, ';', soma_linha		#COMPARA $t1 COM ';' (FINAL DA LINHA), SE FOR IGUAL VAI PARA soma_linha
	add $t2, $t2, 1				#ADICIONA 1 EM $t2 (PROXIMA POSICAO NO ENDERECO)
	j nlinha				#VOLTA PARA nlinha
	soma_linha:				#SIGNIFICA  QUE CHEGOU AO FINAL DA LINHA (REGISTRO)
		add $s3, $s3, 1			#ADICIONA 1 EM $s3
		add $t2, $t2, 1			#ADICIONA 1 EM $t2
		j nlinha			#VOLTA PARA nlinha
###################COMPARACAO#######################
compara:					
	
	beq $s4, '3', cont			#SE $s4 FOR '3' (O USUARIO ESTA CONSULTANDO UM REGISTRO), VAI PARA cont
	beq $s4, '4', cont			#SE $s4 FOR '3' (O USUARIO ESTA VISUALIZANDO REGISTROS), VAI PARA cont
	openfile2:				
		li $v0, 13			# Load open file syscall in $v0
		la $a0, file			# Save in $a0 string containing filename
		li $a1, 9			# Flag
		li $a2, 0			# Mode (ignored)
		syscall				# System call
		move $s0, $v0			# Save file descriptor in $s0
		slt $t0, $v0, $0		# sets $t0 to 1 if file creation error
		beq $t0, 1, openfile2		# if error on creation file, try create again
		add $t0, $0, $0			
	
	cont:					
	addi $t2, $0, 0				#ZERA $t2 (PARA NAO TRAZER UM VALOR ANTERIOR)
	addi $t3, $0, 0				#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $s7 (NUMERO DE  CARACTERES NA LINHA)
	addi $s7, $0, 0				#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $t3 (LINHA ATUAL)
	beq $s4, '2', loop			#SE $s4 FOR '2' (O USUARIO ESTA EDITANDO UM REGISTRO), VAI PARA loop
	beq $s4, '5', loop			#SE $s4 FOR '5' (O USUARIO ESTA APAGANDO UM REGISTRO), VAI PARA loop
	beq $s4, '4', pula			#SE O USUARIO ESTIVER VISUALIZANDO REGISTROS, VAI PARA pula
	li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
	la $a0, comparacao			#COLOCA O ENDERECO DE comparacao EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
	beq $s4, '3', muda			#SE O USUARIO ESTIVER CONSULTANDO UM REGISTRO, VAI PARA muda
	muda:					
	beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim
	la $a1, letra_comparacao		#COLOCA O ENDERECO DE letra_comparacao EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
	li $a2, 2				#COLOCA O TAMANHO A SER SALVO
	syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
	beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim
	beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
	beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
	li $v0, 50				#COLOCA 50 EM $v0 (PARA APARECER UMA MENSAGEM DE CONFIRMACAO)
	la $a0, confirma			#COLOCA EM $a0 O ENDERECO DE confirma
	syscall					#CHAMADA DE SISTEMA (MENSAGEM DE CONFIRMACAO)
	pula:					
	lbu $t5, letra_comparacao($0)		#COLOCA EM $t5 O BYTE QUE ESTA EM letra_comparacao (LETRA SER COMPARADA)
	loop:					
	lbu $t1, lido($t2)			#CARREGA O BYTE (CARACTERE) DA POSICAO $t2 DO ENDERECO lido E COLOCA EM $t1
	beq $t1, 0, close_file			#COMPARA $t1 COM 0 (VAZIO), SE FOR IGUAL VAI PARA close_file
	beq $t1, ';', igual			#COMPARA $t1 COM ';' (FINAL DA LINHA), SE FOR IGUAL VAI PARA igual
	sb $t1, linha($s7)			#COLOCA O BYTE $t1 NA POSICAO $s7 DO ENDERECO linha
	add $s7, $s7, 1				#ADICIONA 1 A $s7
	add $t2, $t2, 1				#ADICIONA 1 A $s7
	j loop					#VOLTA PARA loop

zerar_linha:					#ZERA TODO O CONTEUDO PRESENTE NA LINHA
	beq $s7, $0, loop			#SE $s7 FOR 0 (JA ZEROU A LINHA), VAI PARA loop
	sb $0, linha($s7)			#COLOCA 0 NA POSICAO $s7 DO ENDERECO DE linha
	addi $s7, $s7, -1			#SUBTRAI 1 DE $s7 (VOLTA UM CARACTERE)
	j zerar_linha				#VOLTA PARA zerar_linha
	
igual:						
	beq $s4, '2', igual1			#SE O USUARIO ESTIVER EDITANDO UM CONTATO, VAI PARA igual1
	beq $s4, '5', igual1			#SE O USUARIO ESTIVER APAGANDO UM CONTATO, VAI PARA igual1
	sb $t1, linha($s7)			#COLOCA O BYTE $t1 NA POSICAO $s7 DO ENDERECO linha
	beq $t3, $s3, close_file		#SE A LINHA FOR IGUAL A $s3 (ULTIMA LINHA) VAI PARA close_file
	addi $t8, $0, 9				#COLOCA 9 EM $t8 (A PRIMEIRA LETRA DO NOME Eh O NONO BYTE DE linha
	lbu $t1, linha($t8)			#CARREGA O BYTE (CARACTERE) DA POSICAO $t8 DO ENDERECO lido E COLOCA EM $t1
	beq $s4, '4', print			#SE O USUARIO ESTIVER VISUALIZANDO REGISTROS, VAI PARA print
	beq $t1, $t5, print			#SE $t1 FOR IGUAL A $t5 (A PRIMEIRA LETRA DO NOME Eh A QUE O USUARIO DIGITOU), VAI PARA print
	addi $t3, $t3, 1			#ADICIONA 1 A $t3
	addi $t2, $t2, 3			#ADICIONA 3 A $t2 (PRIMEIRA LETRA DO PROXIMO REGISTRO)
	addi $s7, $s7, 1			#ADICIONA 1 A $s7
	j zerar_linha				#VOLTA PARA zerar_linha
igual1:
	sb $t1, linha($s7)			#COLOCA O BYTE $t1 NA POSICAO $s7 DO ENDERECO linha
	beq $t3, $s3, close_file		#SE A LINHA FOR IGUAL A $s3 (ULTIMA LINHA) VAI PARA close_file
	lbu $t5, registro_comparacao($0)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $0 DE registro_comparacao (PRIMEIRO BYTE DOO REGISTRO)
	lbu $t1, linha($0)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $0 DE linha (PRIMEIRO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	li $s6, 1				#CARREGA 1 EM $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (SEGUNDO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (SEGUNDO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (TERCEIRO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (TERCEIRO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (QUARTO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (QUARTO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (QUINTO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (QUINTO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (SEXTO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (SEXTO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (SETIMO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (SETIMO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	addi $s6, $s6, 1			#ADICIONA 1 A $s6 (PARA PEGAR O PROXIMO BYTE)
	lbu $t5, registro_comparacao($s6)	#COLOCA EM $t5 O BYTE QUE ESTA NA POSICAO $S6 DE registro_comparacao (OITAVO BYTE DOO REGISTRO)
	lbu $t1, linha($s6)			#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $s6 DE linha (OITAVO BYTE DOO REGISTRO)
	bne $t1, $t5, gravar			#SE $t1 E $t5 FOREM DIFERENTES, VAI PARA gravar
	beq $s4, '2', editar			#SE O USUARIO ESTIVER EDITANDO UM REGISTRO VAI PARA editar
	addi $t3, $t3, 1			#ADICIONA 1 A $t3
	addi $t2, $t2, 3			#ADICIONA 3 A $t2
	j zerar_linha				#VOLTA PARA zerar_linha
#####################################################################################
gravar:
	writefile2:
		li $v0, 15			#COLOCA 15 EM $v0 (PARA ABRIR O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) EM $a0
		la $a1, linha			#COLOCA O ENDERECO DE linha EM $a1
		move $a2, $s7			#COLOCA $s7 EM $a2
		syscall				#CHAMADA DE SISTEMA (ESCREVE EM file)
		li $v0, 15			#COLOCA 15 EM $v0 (PARA ABRIR O ARQUIVO) 
		move $a0, $s0			#COLOCA $s0 (file descriptor) EM $a0
		la $a1, write_newline		#COLOCA O ENDERECO DE write_newline EM $a1
		li $a2, 3			#COLOCA 3 EM $a2
		syscall				#CHAMADA DE SISTEMA (ESCREVE EM file)
		addi $t2, $t2, 3		#ADICIONA 3 A $t2
		addi $t3, $t3, 1		#ADICIONA 1 A $t3
		j zerar_linha			#VOLTA PARA zerar_linha
	closefile2:
		li $v0, 16			#COLOCA 16 EM $v0 (PARA FECHAR O ARQUIVO)
		move $a0, $s0			#COLOCA $s0 (file descriptor) EM $a0
		syscall				#CHAMADA DE SISTEMA (FECHA O ARQUIVO)
##############################PRINT###################################################
print:
	li $v0, 4				#COLOCA 4 EM $v0 (PARA PRINTAR O STRING)
	la $a0, linha				#COLOCA O ENDERECO DE linha EM $a1
	syscall					#CHAMADA DE SISTEMA (PRINTA O CONTEUDO DE linha)
	li $v0, 4				#COLOCA 4 EM $v0 (PARA PRINTAR O STRING)
	la $a0, newline				#COLOCA O ENDERECO DE newline EM $a1
	syscall					#CHAMADA DE SISTEMA (PRINTA O CONTEUDO DE newline)
	addi $t3, $t3, 1			#ADICIONA 1 A $t3
	addi $t2, $t2, 3			#ADICIONA 3 A $t2
	j zerar_linha				#VOLTA PARA zerar_linha
########################################################################################
##################################################################################################
editar:							#PARA PROSSEGUIR, Eh NECESSARIO FECHAR O ARQUIVO (OPCAO 2)
#################FINALIZA O ARQUIVO .TXT QUE ESTAVA ABERTO#################################################
		li $v0, 16				#COLOCA 16 $v0 (PARA FECHAR O ARQUIVO QUE ESTAVA ABERTO)
		move $a0, $s0				#COLOCA EM $a0 o file descriptor EM $a0
		syscall					#CHAMADA AO SISTEMA (PARA FECHAR O ARQUIVO
################################################################################
	openfile_ed:					#ABRE O ARQUIVO NOVAMENTE - PARA EDITAR O REGISTRO
		li $v0, 13				#COLOCA 13 EM $v0 (PARA ABRIR O ARQUIVO QUE ESTAVA ABERTO
		la $a0, file				#COLOCA O ENDERECO DE file EM $a0
		li $a1, 9				# Flag - WRITE ONLY 
		li $a2, 0				# Mode (ignored)
		syscall					#CHAMADA AO SISTEMA (PARA ABRIR O ARQUIVO)
		move $s0, $v0				#SALVA EM $s0 O file descriptor
		slt $t0, $v0, $0			#COLOCA $t0 em 1 SE A CRIACAO DO file DER ERRO
		beq $t0, 1, openfile_ed			#SE DER ERRO, TENTA CRIAR file DE NOVO
		add $t0, $0, $0				# ZERA $t0
############################################################################################
novo_registro:						#CRIAR NOVO UM NOVO REGISTRO (OPCAO 1 E 2)
	##########################################
	main_completo:					#PEGA AS INFORMACOES DO NOME COMPLETO
		li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
		la $a0, campo1				#COLOCA O ENDERECO DE campo1 EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
		la $a1, nome_completo			#COLOCA O ENDERECO DE nome_completo EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
		li $a2, 201				#COLOCA O TAMANHO A SER SALVO EM nome_completo (201 - MAIOR DO QUE 150 DEFINIDOS NO ROTEIRO)
		syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
		li $s2, 2				#COLOCA 2 EM $s2 (SIGNIFICA QUE ESTAMOS DIGITANDO O NOME COMPLETO)
		beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
		beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
		beq $s4, '2', loop_ed 			#SE $s4 FOR '2' (USUARIO ESTA EDITANDO UM REGISTRO) VAI PARA loop_ed
		beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim		
		j main_curto				#SIGNIFICA QUE O USUARIO ESTA CRIANDO UM NOVO REGISTRO E NAO CANCELOU A ACAO
		loop_ed:				#SIGNIFICA QUE O USUARIO ESTA EDITANDO UM REGISTRO
		beq $a1, -2, main_completo		#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VOLTA PARA main_completo (O USUARIO Eh OBRIGADO A ESCREVER NO CAMPO)
		
####################################################################
	main_curto:					#PEGA AS INFORMACOES DO NOME CURTO
		li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
		la $a0, campo2				#COLOCA O ENDERECO DE campo2 EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
		la $a1, nome_curto			#COLOCA O ENDERECO DE nome_curto EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
		li $a2, 31				#COLOCA O TAMANHO A SER SALVO EM nome_curto (OS 30 CARACTERES ESPECIFICADOS NO ROTEIRO MAIS O ENTER)
		syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
		li $s2, 3				#COLOCA 3 EM $s2 (SIGNIFICA QUE ESTAMOS DIGITANDO O NOME CURTO)
		beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
		beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
		beq $s4, '2', loop_ed1 			#SE $s4 FOR '2' (USUARIO ESTA EDITANDO UM REGISTRO) VAI PARA loop_ed1
		beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim		
		j main_email				#SIGNIFICA QUE O USUARIO ESTA CRIANDO UM NOVO REGISTRO E NAO CANCELOU A ACAO
		loop_ed1:				#SIGNIFICA QUE O USUARIO ESTA EDITANDO UM REGISTRO
		beq $a1, -2, main_curto			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VOLTA PARA main_curto (O USUARIO Eh OBRIGADO A ESCREVER NO CAMPO)
#####################################################################
	main_email:					#PEGA AS INFORMACOES DO NOME CURTO
		li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
		la $a0, campo3				#COLOCA O ENDERECO DE campo3 EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
		la $a1, email				#COLOCA O ENDERECO DE nome_email EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
		li $a2, 151				#COLOCA O TAMANHO A SER SALVO EM nome_email (151 - MAIOR DO QUE 100 DEFINIDOS NO ROTEIRO)
		syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
		li $s2, 4				#COLOCA 4 EM $s2 (SIGNIFICA QUE ESTAMOS DIGITANDO O EMAIL)
		beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
		beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
		beq $s4, '2', loop_ed2 			#SE $s4 FOR '2' (USUARIO ESTA EDITANDO UM REGISTRO) VAI PARA loop_ed2
		beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim		
		j main_tel				#SIGNIFICA QUE O USUARIO ESTA CRIANDO UM NOVO REGISTRO E NAO CANCELOU A ACAO
		loop_ed2:				#SIGNIFICA QUE O USUARIO ESTA EDITANDO UM REGISTRO
		beq $a1, -2, main_email		#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VOLTA PARA main_email (O USUARIO Eh OBRIGADO A ESCREVER NO CAMPO)
######################################################################
	main_tel:					#PEGA AS INFORMACOES DO NOME CURTO
		li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
		la $a0, campo4				#COLOCA O ENDERECO DE campo4 EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
		la $a1, telefone			#COLOCA O ENDERECO DE nome_telefone EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
		li $a2, 15				#COLOCA O TAMANHO A SER SALVO EM telefone (OS 15 CARACTERES ESPECIFICADOS NO ROTEIRO MAIS O ENTER)
		syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
		li $s2, 5				#COLOCA 4 EM $s2 (SIGNIFICA QUE ESTAMOS DIGITANDO O TELEFONE)
		beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
		beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
		j conta_numletras			#JUMP conta_numletras - VAI CONTAR O NUMERO DE CARACTERES DIGITADOS PELO USUARIO 
		beq $s4, '2', loop_ed3 			#SE $s4 FOR '2' (USUARIO ESTA EDITANDO UM REGISTRO) VAI PARA loop_ed3
		beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim		
		j conta_numletras				#SIGNIFICA QUE O USUARIO ESTA CRIANDO UM NOVO REGISTRO E NAO CANCELOU A ACAO
		loop_ed3:				#SIGNIFICA QUE O USUARIO ESTA EDITANDO UM REGISTRO
		beq $a1, -2, main_tel			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VOLTA PARA main_tel (O USUARIO Eh OBRIGADO A ESCREVER NO CAMPO)
########################################################################
########################################################################
conta_numletras:					#CONTA O NUMERO DE LETRAS
li $s2, 2						#CONTA PRIMEIRO O NUMERO DE LETRAS EM nome_completo
	letras:						#RETIRA OS ESPACOS EM BRANCO
		beq $s2, 2, l_completo			#SE $s2 FOR 2, VAI PARA l_completo (PARA CONTAR O NUMERO DE CARACTERES EM nome_completo)
		beq $s2, 3, l_curto			#SE $s2 FOR 3, VAI PARA l_curto (PARA CONTAR O NUMERO DE CARACTERES EM nome_curto)
		beq $s2, 4, l_email			#SE $s2 FOR 4, VAI PARA l_email (PARA CONTAR O NUMERO DE CARACTERES EM email)
		beq $s2, 5, l_tel			#SE $s2 FOR 2, VAI PARA l_telefone (PARA CONTAR O NUMERO DE CARACTERES EM telefone)
		beq $s4, '2', close_file_ed		#SE $s4 FOR '2' (ESTAMOS EDITANDO), VAI PARA close_file_ed
		beq $s2, 6, close_file			#SE $s2 FOR 6 (JA CONTOU AS LETRAS DE TODOS OS CAMPOS UTILIZADOS), VAI PARA close_file
		
		l_completo:				#CONTA O NUMERO DE LETRAS EM nome_completo
			la $t4, nome_completo		#COLOCA EM $t4 O ENDERECO DE nome_completo
			li $t3, 0			#ZERA $t3 (CONTADOR DE LETRAS)
			j l				#VAI PARA l
			
		l_curto:				#CONTA O NUMERO DE LETRAS EM nome_curto
			la $t4, nome_curto		#COLOCA EM $t4 O ENDERECO DE nome_curto
			li $t3, 0			#ZERA $t3 (CONTADOR DE LETRAS)
			j l				#VAI PARA l
			
		l_email:				#CONTA O NUMERO DE LETRAS EM email
			la $t4, email			#COLOCA EM $t4 O ENDERECO DE email
			li $t3, 0			#ZERA $t3 (CONTADOR DE LETRAS)
			j l				#VAI PARA l
			
		l_tel:					#CONTA O NUMERO DE LETRAS EM telefone
			la $t4, telefone		#COLOCA EM $t4 O ENDERECO DE telefone
			li $t3, 0			#ZERA $t3 (CONTADOR DE LETRAS)
			j lo				#VAI PARA lo
			
	l:						#LOOP QUE CONTA O NUMERO DE LETRAS
		lbu $t5, 0($t4)				#COLOCA EM $t5 O BYTE (CARACTERE) NO ENDERECO $t4
		beq $t5, 0xa, writefile			#COMPARA O CARACTERE COM 0xa (LF - line feed); SE FOR IGUAL, VAI PARA writefile
		addi $t4, $t4, 1			#SOMA 1 EM $t4 ($t4 PASSA A SER O ENDERECO DO PROXIMO CARACTERE)
		addi $t3, $t3, 1			#SOMA 1 (O CARACTERE LIDO) NO SOMATORIO DE LETRAS DA LINHA
		j l					#VOLTA PARA l
	lo:						#LOOP QUE CONTA O NUMERO DE LETRAS EM TELEFONE
		lbu $t5, 0($t4)				#COLOCA EM $t5 O BYTE (CARACTERE) NO ENDERECO $t4
		beq $t5, 0xa, writefile			#COMPARA O CARACTERE COM 0xa (LF - line feed); SE FOR IGUAL, VAI PARA writefile
		beq $t5, 0, writefile			#COMPARA O CARACTERE COM 0 (VAZIO); SE FOR IGUAL, VAI PARA writefile
		addi $t4, $t4, 1			#SOMA 1 EM $t4 ($t4 PASSA A SER O ENDERECO DO PROXIMO CARACTERE)
		addi $t3, $t3, 1			#SOMA 1 (O CARACTERE LIDO) NO SOMATORIO DE LETRAS DA LINHA
		j lo					#VOLTA PARA l
#################WRITE FILE############################################
	writefile:					#ESCREVE NO ARQUIO
		beq $s2, 2, w_completo			#SE $s2 FOR '2',  VAI PARA w_completo (PARA ESCREVER O CONTEUDO DE nome_completo)
		beq $s2, 3, w_curto			#SE $s2 FOR '3',  VAI PARA w_curto (PARA ESCREVER O CONTEUDO DE nome_curto)
		beq $s2, 4, w_email			#SE $s2 FOR '4',  VAI PARA w_email (PARA ESCREVER O CONTEUDO DE email)
		beq $s2, 5, w_tel			#SE $s2 FOR '5',  VAI PARA w_tel (PARA ESCREVER O CONTEUDO DE telefone)
		w_completo:				#PREPARA O CONTEUDO DE nome_completo PARA ESCREVER NO ARQUIVO
			j salva_id			#VAI PARA salva_id (PARA ESCREVER O id DO REGISTRO)
			depois_id:			#VOLTA DE salva_id
			li $v0, 15			#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
			move $a0, $s0			#COLOCA EM $a0 $s0(file descriptor)
			addi $s2, $s2, 1		#SOMA 1 EM $s2 (NA PROXIMA REPETICAO DE writefile, IR PARA w_curto)
			la $a1, nome_completo		#COLOCA O ENDERECO DE nome_completo EM $a1
			j write				#VAI PARA write
		w_curto:				#PREPARA O CONTEUDO DE nome_curto PARA ESCREVER NO ARQUIVO
			li $v0, 15			#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
			move $a0, $s0			#COLOCA EM $a0 $s0(file descriptor)
			addi $s2, $s2, 1		#SOMA 1 EM $s2 (NA PROXIMA REPETICAO DE writefile, IR PARA w_email)
			la $a1, nome_curto		#COLOCA O ENDERECO DE nome_curto EM $a1
			j write				#VAI PARA write
		w_email:				#PREPARA O CONTEUDO DE email PARA ESCREVER NO ARQUIVO
			li $v0, 15			#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
			move $a0, $s0			#COLOCA EM $a0 $s0(file descriptor)
			addi $s2, $s2, 1		#SOMA 1 EM $s2 (NA PROXIMA REPETICAO DE writefile, IR PARA w_tel)
			la $a1, email			#COLOCA O ENDERECO DE nome_curto EM $a1
			j write				#VAI PARA write
		w_tel:					#PREPARA O CONTEUDO DE telefone PARA ESCREVER NO ARQUIVO
			li $v0, 15			#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
			move $a0, $s0			#COLOCA EM $a0 $s0(file descriptor)
			addi $s2, $s2, 1		#SOMA 1 EM $s2 (NA PROXIMA REPETICAO DE writefile, SAIR DE letras)
			la $a1, telefone		#COLOCA O ENDERECO DE nome_curto EM $a1
			j write				#VAI PARA write
		write:					#ESCRE NO ARQUIVO
		move $a2, $t3				#COLOCA EM $a2 $t3 (NUMERO DE CARACTERES NO ENDERECO CARREGADO EM writefile)
		syscall					#CHAMADA DE SISTEMA (ESCREVE EM file O CONTEUDO DO ENDERECO  $a1)
		beq $s2, 6, newl			#SE $s2 FOR 6 VAI PARA newl (SIGNIFICA QUE JA ESCREVEU TODOS OS CAMPOS DO REGISTRO NO ARQUIVO)
		li $v0, 15				#($S2 Eh DIFERENTE DE 6) COLOCA 15 EM $v0 (PARA ESCREVER EM file)
		move $a0, $s0				#COLOCA EM $a0 $s0 (file descriptor)
		la $a1, tab				#CARREGA EM $a1 O ENDERECO DE tab 
		li $a2, 1				#COLOCA 1 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS EM file) 
		syscall					#CHAMADA DE SISTEMA (ESCREVE EM file O CONTEUDO DO ENDERECO $a1 - '/') 
		j cont1					#VAI PARA contl (DESVIA DE newl)
		newl:					#$s2 Eh IGUAL A 6 (TODOS OS CAMPOS JA FORAM ESCRITOS EM file)
			li $v0, 15			# COLOCA 15 EM $v0 (PARA ESCREVER EM file)
			move $a0, $s0			#COLOCA EM $a0 $s0 (file descriptor)
			la $a1, write_newline		#CARREGA EM $a1 O ENDERECO DE write_newline
			li $a2, 3			#COLOCA 3 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS EM file)
			syscall				#CHAMADA DE SISTEMA (ESCREVE EM file O CONTEUDO DO ENDERECO  $a1 - ';' E PULA LINHA)
		cont1:					#DESVIO PARA PULAR newl
		add $t0, $t0, 1 			#SOMA 1 EM $t0
		bne $t0, 1, writefile			#SE $t0 FOR DIFERENTE DE 1, VAI PARA writefile
		add $t0, $zero, $zero			#ZERA $t0
		j letras				#VOLTA PARA letras (RETIRAR OS ESPACOS EM BRANCO DO PROXIMO CAMPO
close_file_ed:						
	addi $t3, $t3, 1				#CONTA O NUMERO DE LINHAS
	addi $t2, $t2, 3				#SOMA 3 PARA IR PARA O PRIMEIRO ELEMENTO DA PROXIMA LINHA
	j zerar_linha
##################################################################
#########################FIM######################################
close_file:						#FECHA file (ESTAVA SENDO ESCRITO EM file)
	li $v0, 16					#COLOCA 16 EM $v0 (PARA FECHAR file)
	move $a0, $s0					#COLOCA $s0 (file descriptor) EM $a0
	syscall						#CHAMADA AO SISTEMA (FECHA file)
	bne $s4, '1', prox_opcao			#SE A ESCOLHA NAO FOI CRIAR UM NOVO REGISTRO ($s4 Eh DIFERENTE '1'), VAI PARA prox_opcao
	addi $s4, $s4, 3				#ADICIONA 3 A $s4 (PARA $s4 SER IGUAL A '4')
	j openfile
	prox_opcao:
	beq $s4, '2', fim				#SE A ESCOLHA FOI EDITAR UM REGISTRO ($s4 Eh '2'), VAI PARA fim
	beq $s4, '3', menu				#SE A ESCOLHA FOI CONSULTAR UM REGISTRO ($s4 Eh '3'), VAI PARA menu
	beq $s4, '4', menu				#SE A ESCOLHA FOI VISUALIZAR REGISTROS ($s4 Eh '4'), VAI PARA menu
	beq $s4 '5', fim				#SE A ESCOLHA FOI APAGAR UM REGISTRO ($s4 Eh '5'), VAI PARA fim
	j fim						#VAI PARA fim
###################################################################
#####################MENU##########################################
menu:
	li $s2, 1					#s2 = 1, significa que estamos no menu
	li $t0, 0					#ZERA $t0 (PARA O VALOR ARMAZENADO ANTERIORMENTE NAO ALTERAR NOVOS VALORES)
	li $t1, 0					#ZERA $t1 (PARA O VALOR ARMAZENADO ANTERIORMENTE NAO ALTERAR NOVOS VALORES)
	li $v0, 54					#COLOCA 54 EM $v0 (PARA APARECER O MENU DE NAVEGACAO)
	la $a0, campo					#COLOCA O ENDERECO DE campo EM $a0
	la $a1, escolha					#COLOCA EM $a1 O ENDERECO DE escolha (ENDERECO EM QUE VAI FICAR A ESCOLHA DO USUARIO)
	li $a2, 2					#COLOCA 2 E $a2 (CARACTERES LIDOS)
	syscall						#CHAMADA AO SISTEMA (MESSAGE DIALOG STRING)
	beq $a1, -4, size_exceeded			#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
	beq $a1, -3, noData				#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
	beq $a1, -2, fim				#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim
	la $t1, escolha					#COLOCA O ENDERECO DE escolha EM $t1
	lb $s4, escolha					#COLOCA O PRIMEIRO BYTE DO CONTEUDO DE escolha (A ESCOLHA DO USUARIO NO MENU) EM $S4
	li $v0, 50					#COLOCA 50 EM $v0 (PARA APARECER UMA MENSAGEM DE CONFIRMACAO)
	la $a0, confirma				#COLOCA EM $a0 O ENDERECO DE confirma
	syscall						#CHAMADA DE SISTEMA (MENSAGEM DE CONFIRMACAO)
	bne $a0, 0, menu				#SE $a0 FOR DIFERENTE DE 0 (O USUARIO CANCELOU/NEGOU A CONFIRMACAO), VOLTA PARA menu; SENAO, CONTINUA
	beq $s4, '1', openfile_id			#SE $S4 FOR IGUAL A '1' (USUARIO ESCOLHEU FAZER UM NOVO REGISTRO) VAI PARA openfile_id
	beq $s4, '2', openfile				#SE $S4 FOR IGUAL A '2' (USUARIO ESCOLHEU FAZER EDITAR UM REGISTRO) VAI PARA openfile
	beq $s4, '3', openfile				#SE $S4 FOR IGUAL A '3' (USUARIO ESCOLHEU CONSULTAR UM REGISTRO) VAI PARA openfile
	beq $s4, '4', openfile				#SE $S4 FOR IGUAL A '4' (USUARIO ESCOLHEU VISUALIZAR REGISTROS) VAI PARA openfile
	beq $s4, '5', openfile				#SE $S4 FOR IGUAL A '5' (USUARIO ESCOLHEU APAGAR UM REGISTRO) VAI PARA openfile
	beq $s4, '6', fim				#SE $S4 FOR IGUAL A '6' (USUARIO ESCOLHEU FINALIZAR O PROGRAMA) VAI PARA fim
	j invalido					#SE PASSOU PELOS COMPARADORES ACIMA (LINHAS 492-497), O USUARIO  DIGITOU UMA OPCAO INVALIDA - VAI PARA invalido
##############################################################################
#################################PEGA O ULTIMO ID#############################

openfile_id:						#ABRE file PARA ENCONTRAR O Id
	
	li $v0, 13					#COLOCA 13 EM $v0 (PARA ABRIR O ARQUIVO)
	la $a0, file					#CARREGA O ENDERECO DE file EM $a0
	li $a1, 0					#Flag 0 - READ ONLY
	li $a2, 0					#MODE (IGNORED)
	syscall						#CHAMADA AO SISTEMA (ABRE file)
	move $s0, $v0					#SALVA O file descriptor EM $s0
	slt $t0, $v0, $0				#COLOCA $t0 em 1 SE A CRIACAO DO file DER ERRO
	beq $t0, 1, openfile_id				#SE DER ERRO, TENTA CRIAR file DE NOVO (VOLTA PARA openfile_id)
	add $t0, $0, $0					#ZERA $t0
readfile_id:						#LE file PARA ENCONTRAR O Id
	li $v0, 14					#COLOCA 14 EM $v0 (PARA LER O ARQUIVO)
	move $a0, $s0					#COLOCA $s0 (file descriptor) EM $a0
	la $a1, lido					#COLOCA O ENDERECO DE lido EM $a1 (O CONTEUDO DE file VAI PARA O ENDERECO DE lido)
	li $a2, 398000					#COLOCA NUMERO DE CARACTERES LIDO EM $a2 (398000 - EQUIVALENTE A 1000 LINNAS SEM ESPACOS EM BRANCO)
	syscall						#CHAMADA AO SISTEMA (LE file E COLOCA EM lido)
	li $v0, 16					#COLOCA 16 EM $v0 (PARA FECHAR file)
	move $a0, $s0					#COLOCA $s0 (file descriptor) EM $a0
	syscall						#CHAMADA AO SISTEMA (FECHA file)
#####################NUMERO DE LINHAS####################
conta_numlinhas_id:					#CONTA O NUMERO DE LINHAS EM lido (NUMERO DE REGISTROS EM lido) PARA SALVAR O ULTIMO Id
addi $t2, $0, 0						#ZERA $t2 (POSICAO NO ENDERECO)
addi $s3, $0, 0						#ZERA $s3 (NUMERO DE LINHAS)
nlinha_id:						#LOOP PARA CONTAR O NUMERO DE LINHAS
	lbu $t1, lido($t2)				#CARREGA O BYTE (CARACTERE) DA POSICAO $t2 DO ENDERECO lido E COLOCA EM $t1
	beq $t1, 0, pega_id_id				#COMPARA $t1 COM 0 (VAZIO), SE FOR IGUAL VAI PARA pega_id_id
	beq $t1, ';', prox_linha_id			#COMPARA $t1 COM ';' (FINAL DA LINHA), SE FOR IGUAL VAI PARA proxima_linha_id
	add $t2, $t2, 1					#ADICIONA 1 EM $t2 (PROXIMA POSICAO NO ENDERECO)
	j nlinha_id					#VOLTA PARA nlinha_id
	prox_linha_id:					#SIGNIFICA  QUE CHEGOU AO FINAL DA LINHA (REGISTRO)
		add $s3, $s3, 1				#ADICIONA 1 EM $s3
		add $t2, $t2, 1				#ADICIONA 1 EM $t2
		j nlinha_id				#VOLTA PARA nlinha_id
		
pega_id_id:						#SIGNIFICA QUE CHEGOU NO FINAL DE lido
	
	addi $t2, $0, 0					#ZERA $t2 (PARA NAO TRAZER UM VALOR ANTERIOR)
	addi $s7, $0, 0					#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $s7 (NUMERO DE  CARACTERES NA LINHA) 
	addi $t3, $0, 0					#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $t3 (LINHA ATUAL)  
	loop_id:					#LOOP
	lbu $t1, lido($t2)				#CARREGA O BYTE (CARACTERE) DA POSICAO $t2 DO ENDERECO lido E COLOCA EM $t1
	beq $t1, 0, ultima_linha_id			#COMPARA $t1 COM 0 (VAZIO), SE FOR IGUAL VAI PARA ultima_linha_id
	beq $t1, ';', proxima_linha_id			#COMPARA $t1 COM ';' (FINAL DA LINHA), SE FOR IGUAL VAI PARA proxima_linha_id
	sb $t1, linha($s7)				#COLOCA O BYTE $t1 NA POSICAO $s7 DO ENDERECO linha
	add $s7, $s7, 1					#ADICIONA 1 A $s7
	add $t2, $t2, 1					#ADICIONA 1 A $s7
	j loop_id					#VOLTA PARA loop_id	
	
	
proxima_linha_id:					#SIGNIFICA QUE A LINHA LIDA NAO Eh A ULTIMA DO ARQUIVO
	
	sb $t1, linha($s7)				#COLOCA O BYTE $t1 (QUE Eh ';') NA POSICAO $s7 DO ENDERECO linha
	addi $t2, $t2, 3				#SOMA 3 PARA IR PARA O PRIMEIRO ELEMENTO DA PROXIMA LINHA
	addi $t3, $t3, 1				#ADICIONA 1 A $t3 (PASSA PARA A PROXIMA LINHA)
	addi $s7, $s7, 1				#ADICIONA 1 A $s7
	j zerar_linha_id				#VAI PARA zerar_linha_id
	
zerar_linha_id:						#ZERA TODO O CONTEUDO PRESENTE NA LINHA
	beq $t3, $s3, ultima_linha_id			#SE A LINHA FOR IGUAL A $s3 (ULTIMA LINHA) VAI PARA ultima_linha_id
	beq $s7, $0, loop_id				#SE $s7 FOR 0 (JA ZEROU A LINHA), VAI PARA loop_id
	sb $0, linha($s7)				#COLOCA 0 NA POSICAO $s7 DO ENDERECO DE linha
	addi $s7, $s7, -1				#SUBTRAI 1 DE $s7 (VOLTA UM CARACTERE)
	j zerar_linha_id				#VOLTA PARA zerar_linha_id
	
ultima_linha_id:					#SIGNIFICA QUE A LINHA ATUAL Eh A ULTIMA LINHA (E POSSUI O ULTIMO Id)
	addi $s5, $0, 0					#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $s5 (METADE MAIS SIGNIFICATIVA DOS NUMEROS DO Id) 
	addi $s6, $0, 0					#ZERA (PARA NAO TRAZER UM VALOR ANTERIOR) $s6 (METADE MENOS SIGNIFICATIVA DOS NUMEROS DO Id)
	addi $t7, $0, 7					#COLOCA 7 (POSICAO DO ALGARISMO MENOS SIGNIFICATIVO DE Id) EM $t7 (REGISTRADOR AUXILIAR PARA ENCONTRAR O VALOR DO PROXIMO Id)
	s6_id:						#LOOP PARA COLOCAR EM $s6 METADE DOS NUMEROS DE Id
	beq $t7, 4, ult_s6_id				#SE $t7 FOR 4, VAI PARA ult_s6_id
	lb $t1, linha($t7)				#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $t7 DO ENDERECO DE linha
	add $s6, $s6, $t1				#ADICIONA $t1 EM $s6
	sll $s6, $s6, 8					#DESLOCA $s6 DE 8 BITS (PARA COLOCAR COLOCAR EM $s6 A METADE DOS ALGARISMOS DE Id SEM SOBRESCREVE-LOS)
	addi $t7, $t7, -1				#SUBTRAI 1 DE $t7 (PARA, NA PROXIMA REPETICAO, PEGAR O ALGARISMO IMEDIATAMENTE MAIS SIGNIFICATIVO DO QUE ELE) 
	j s6_id						#VOLTA PARA s6_id
	ult_s6_id:					#DESVIO PARA  QUANDO $t7 FOR 4
	lb $t1, linha($t7)				#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $t7 DO ENDERECO DE linha
	add $s6, $s6, $t1				#ADICIONA $t1 EM $s6
	##################
	addi $t7, $0, 3					#COLOCA 3 EM $t7 (PARA PEGAR  O PRIMEIRO ALGARISMO QUE DEVE SER COLOCADO EM $s5)
	s5_id:						#LOOP PARA COLOCAR EM $s6 METADE DOS NUMEROS DE Id
	beq $t7, 0, ult_s5_id				#SE $t7 FOR 0, VAI PARA ult_s5_id
	lb $t1, linha($t7)				#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $t7 DO ENDERECO DE linha
	add $s5, $s5, $t1				#ADICIONA $t1 EM $s%
	sll $s5, $s5, 8					#DESLOCA $s5 DE 8 BITS (PARA COLOCAR COLOCAR EM $s5 A METADE DOS ALGARISMOS DE Id SEM SOBRESCREVE-LOS)
	addi $t7, $t7, -1				#SUBTRAI 1 DE $t7 (PARA, NA PROXIMA REPETICAO, PEGAR O ALGARISMO IMEDIATAMENTE MAIS SIGNIFICATIVO DO QUE ELE)
	j s5_id						#VOLTA PARA s5_id
	ult_s5_id:					#DESVIO PARA  QUANDO $t7 FOR 0
	lb $t1, linha($t7)				#COLOCA EM $t1 O BYTE QUE ESTA NA POSICAO $t7 DO ENDERECO DE linha
	add $s5, $s5, $t1				#ADICIONA $t1 EM $s6
	addi $t7, $t7, 1				#ADICIONA 1 A $t7
	j zera_ultima_linha_id				#VAI PARA zera_ultima_linha_id

zera_ultima_linha_id:					#ZERA O CONTEUDO DA ULTIMA LINHA
	beq $s7, $0, fim_id				#SE $s7 FOR IGUAL A 0 (TERMINOU DE ZERAR A LINHA), VAI PARA fim_id
	sb $0, linha($s7)				#COLOCA 0 NA POSICAO $s7 DO ENDERECO DE linha
	addi $s7, $s7, -1				#SUBTRAI 1 DE $s7 (PARA PEGAR POSICAO ANTERIOR)
	j zera_ultima_linha_id				#VOLTA PARA zera_ultima_linha_id
	
fim_id:							#TERMINOU DE  ZERAR linha
	sw $s5, id					#COLOCA $s5 NOS 4 BYTES MENOS SIGNIFICATIVOS DE id
	li $t7, 4					#COLOCA 4 EM $t7
	sw $s6, id($t7)					#COLOCA $s5 NOS 4 BYTES MAIS SIGNIFICATIVOS DE id
	bnez $s3, soma_id_id				#SE $S3 FOR DIFERENTE DE 0 (EXISTE PELO MENOS UM REGISTRO EM file), VAI PARA soma_id_id
	li $s5, 0x30303030				#COLOCA 0X30303030 (SIMBOLOS EM ASCII PARA 0000) EM $s5
	li $s6, 0x30303030				#COLOCA 0X30303030 (SIMBOLOS EM ASCII PARA 0000) EM $s6
	sw $s5, id					#COLOCA $s5 NOS 4 BYTES MENOS SIGNIFICATIVOS DE id
	sw $s6, id($t7)					#COLOCA $s5 NOS 4 BYTES MAIS SIGNIFICATIVOS DE id
	j soma_id_id					#VAI PARA soma_id_id
	
soma_id_id:						#SOMA 1 NO Id (PARA O Id DO NOVO REGISTRO SER O Id MAIS 1 DO REGISTRO DA ULTIMA LINHA)
	addi $t7, $0, 7					#COLOCA 7 EM $s7 (PARA AUXILIAR NA SOMA)
	conta_id_id:					#LOOP PARA FAZER A SOMA EM ASCII
	beq $t7, 8, openfile				#SE $t7 FOR 8, VAI PARA openfile
	lbu $t9, id($t7)				#CARREGA O VALOR DA POSICAO $t7 DO ENDERECO id
	beq $t9, '9', soma_um_id			#SE $t9 FOR '9', VAI PARA soma_um_id
	addi $t9, $t9, 1				#ADICIONA 1 A $t9
	sb $t9, id($t7)					#COLOCA $t9 NA POSICAO $t7 DO ENDERECO id
	j openfile					#VAI PARA openfile
	soma_um_id:					#COMO A SOMA ESTA SENDO FEITA COM OS NUMEROS EM ASCII (CADA NUMERO OCUPA UM BYTE), ASSIM QUANDO O CARACTERE FOR '9', TEM QUE MUDAR O CARACTERE EM QUESTAO PARA '0' E ADICIONAR 1 PROXIMO CARACTERE 
	addi $t9, $t9, -9				#SUBTRAI 9 DE $t9 (MUDA O CONTEUDO DE '9' PARA '0')
	sb $t9, id($t7)					#COLOCA O VALOR DE $t9 NA POSICAO $t7 DO ENDERECO DE id
	addi $t7, $t7, -1				#SUBTRAI 1 DE $t7
	j conta_id_id					#VAI PARA conta_id_id
	
############################################################################
############SALVA O NOVO ID NO ARQUIVO#################################################
salva_id:					#SALVA O Id
	beq $s4, '2', nmuda_id			#SE $s4 FOR '2' (O USUARIO ESTA EDITANDO), VAI PARA nmuda_id
	li $v0, 15				#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
	move $a0, $s0				#COLOCA $s0 (file descriptor) em $a0
	li $t9, 4				#COLOCA 4 EM $t9
	la  $a1, id($0)				#COLOCA O ENDERECO DE id EM $a1
	li $a2, 8				#COLOCA 8 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS)
	syscall					#CAHAMADA AO SISTEMA (ESCREVE O Id NO file)
	li $v0, 15				#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
	move $a0, $s0				#COLOCA $s0 (file descriptor) em $a0
	la  $a1, tab				#COLOCA O ENDERECO DE tab EM $a1
	li $a2, 1				#COLOCA 1 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS)
	syscall					#CAHAMADA AO SISTEMA (ESCREVE '/' NO file)
	j depois_id				#VAI PARA depois_id
	nmuda_id:				#(O USUARIO ESTA EDITANDO, ENTAO MANTEM O ULTIMO Id) 
	li $v0, 15				#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
	move $a0, $s0				#COLOCA $s0 (file descriptor) em $a0
	li $t9, 4				#COLOCA 4 EM $t9
	la  $a1, registro_comparacao($0)	#COLOCA O ENDERECO DE registro_comparacao EM $a1
	li $a2, 8				#COLOCA 8 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS)
	syscall					#CAHAMADA AO SISTEMA (ESCREVE O Id NO file)
	li $v0, 15				#COLOCA 15 EM $v0 (PARA ESCREVER EM file)
	move $a0, $s0				#COLOCA $s0 (file descriptor) em $a0
	la  $a1, tab				#COLOCA 1 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS)
	li $a2, 1				#COLOCA 1 EM $a2 (NUMERO DE CARACTERES A SEREM ESCRITOS)
	syscall					#CAHAMADA AO SISTEMA (ESCREVE '/' NO file)
	j depois_id				#VAI PARA depois_id
######################################################################################################
testa_edicao:
	li $v0, 54				#COLOCA 54 EM $v0 (PARA APARECER CAIXA DE DIALOGO - STRING)
	la $a0, registro_apaga			#COLOCA O ENDERECO DE registro_apaga EM $a0 (PARA APARECER O TEXTO NA MENSAGEM)
	la $a1, registro_comparacao		#COLOCA O ENDERECO DE letra_comparacao EM $a1 (ONDE VAI O QUE O USUARIO DIGITAR)
	li $a2, 9				#COLOCA O TAMANHO A SER SALVO
	syscall					#CHAMADA AO SISTEMA (CAIXA DE DIALOGO - STRING)
	beq $a1, -2, fim			#SE $a1 FOR -2, O USUARIO CANCELOU A ACAO - VAI PARA fim
	beq $a1, -3, noData			#NADA FOI ESCRITO PELO USUARIO - VAI PARA noData
	beq $a1, -4, size_exceeded		#FORAM ESCRITOS MAIS CARACTERES DO QUE O PERMITIDO - VAI PARA size_exceeded
	li $v0, 50				#COLOCA 50 EM $v0 (PARA APARECER UMA MENSAGEM DE CONFIRMACAO)
	la $a0, confirma			#COLOCA EM $a0 O ENDERECO DE confirma
	syscall					#CHAMADA DE SISTEMA (MENSAGEM DE CONFIRMACAO)
	beq $a0, 0, apaga			#SE $a1 FOR 2, O USUARIO CANCELOU A ACAO - VAI PARA fim
	j testa_edicao
######################################################################################################
fim:						#FINALIZA O PROGRAMA
	li $v0, 16				#COLOCA 16 EM $v0 (PARA FECHAR file)
	move $a0, $s0				#COLOCA $s0 (file descriptor) em $a0
	syscall					#CAHAMADA AO SISTEMA (FECHAR file)
	li $v0, 10				#COLOCA 10 EM $v0 (PARA SAIR DO PROGRAMA)
	syscall					#CAHAMADA AO SISTEMA (SAI DO PROGRAMA)
