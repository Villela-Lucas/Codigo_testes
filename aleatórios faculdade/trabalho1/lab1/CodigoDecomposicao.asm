.data
tab:	.asciiz "\t"
linha:	.asciiz "\n"
zerod:	.double 0.0
umd: .double 1.0
A:	.space 72
matriz:	.asciiz "Digite os termos de sua matriz (aperte <ENTER> apos cada termo): \n"
sua_matriz:	.asciiz "Sua matriz e: \n"
matriz_l:	.asciiz "A matriz L e: \n"
matriz_u:	.asciiz "A matriz U e: \n"
.text

	.globl inicio
	
	inicio:
		ldc1 $f20, zerod		        #cria um double com valor zero
		ldc1 $f22, umd				#cria uma double com valor um
		addi $t5, $zero, 0			#coloca t5 com valor 5 (para saber quando dar tab ou pular linha)
		li $v0, 4				#chama funcao imprimir string (no caso, matriz)
		la $a0, matriz				#salva o endereco de matriz em a0
		syscall					#printa a0
		jal ler_matriz  			# chama funcao para ler
		li $v0, 4				#chama funcao imprimir string (no caso, sua_matriz)
		la $a0, sua_matriz			#salva o endereco de sua_matriz em a0
		syscall					#printa a0
		jal imprime_double		   	# manda imprimir o numero lido
		jal calcula_matrizes
		li $v0, 4
		la $a0, matriz_l
		syscall
		jal imprime_l
		li $v0, 4
		la $a0, matriz_u
		syscall
		jal imprime_u
		j fim
	ler_matriz:
		addi $t2, $zero, 0	 		#zera o t2
		while:
			beq $t2, 72, voltar 		#condicao para ler os 9 termos da matriz
			li $v0, 7			# codigo para ler um double
			syscall				# executa a chamada do SO para ler (salva o que foi escrito em f0
			sdc1 $f0, A($t2)		#passa conteudo de f0 para a posicao t2 do vetor A
			addi $t2, $t2, 8		#passa para o proximo double
			j while				# volta para o lugar de onde foi chamado (no caso, jal le_inteiro_do_teclado)
		voltar:
			jr $ra
	
	calcula_matrizes:
		ldc1 $f2, A($zero)	#guarda o item A11 no elemento L11 (registrador $f2)
		li $t3, 24
		ldc1 $f4, A($t3) #guarda o item A21 no elemento L21 (registrador $f4)
		li $t3, 48
		ldc1 $f6, A($t3) #guarda o item A31 no elemento L31 (registrador $f6)
		li $t3, 8
		ldc1 $f26, A($t3) #Carrega o item A12 num registrador temporario ($f26) para calcular U12 
		div.d $f16, $f26, $f2 #Calcula o valor de U12 e guarda o no registrador $f16
		li $t3, 16
		ldc1 $f26, A($t3) #Carrega o item A13 para calcular U13
		div.d $f18, $f26, $f2 #calcula o valor de U13 e guarda o no registrador $f18
		li $t3, 32
		ldc1 $f26, A($t3) #Carrega o item A22 para calcular o item L22
		mul.d $f28, $f4, $f16 #calculo intermediario
		sub.d $f8, $f26, $f28 #Calculo final para L22 e guarda no registrador $f8
		li $t3, 56
		ldc1 $f26, A($t3) #Carrega o item A32 para calcular o item L32
		mul.d $f28, $f6, $f16 #calculo intermediario
		sub.d $f10, $f26, $f28 #Calcula o valor de L32 e guarda o no registrador $f10
		li $t3, 40
		ldc1 $f26, A($t3) #Carrega o item A23 para calcular o campo U23
		mul.d $f28, $f4, $f18 #calculo intermediario
		sub.d $f26, $f26, $f28 #calculo intermediario
		div.d $f24, $f26, $f8 #Calculo o campo U23 e guarda o no registrador $f24
		li $t3, 64
		ldc1 $f26, A($t3) #Carrega o item A33 para calcular o elemento L33
		mul.d $f28, $f6, $f18 #calculo intermediario
		sub.d $f26, $f26, $f28 #calculo intermediario
		mul.d $f28, $f10, $f24 #calculo intermediario
		sub.d $f14, $f26, $f28 # Calcula o item L33 e guarda-o no registrador $f14
		jr $ra
	
	imprime_double:				# codigo para imprimir um double
		addi $t4, $zero, 0			#zera t4
		While2:
			beq $t4, 72, fim2		#loop ate imprimir os termos da matriz
			li $v0, 3			#chama a funcao para imprimir double
			l.d $f12,A($t4)			# $f12 e o registrador que ira conter o valor a ser impresso
			syscall				# executa a chamado do SO para imprimir
	
		da_tab:
			condicao:
				beq $t5, 3, pula_linha	# quando estiver em um termo multiplo de 3, vai para pula_linha	
				li $v0, 4		#chama funcao imprimir string (dar um tab)
				la $a0, tab		#salva o endereco de tab em a0
				syscall			#printa a0
				addi $t5, $t5, 1	#passa t5 para o proximo termo
		pula_linha:
			cond2:			
				bne $t5, 3, continua	#quando nao estiver em multiplo de 3, vai para continua
				li, $v0, 4		#chama funcao imprimir string (pula linha)
				la $a0, linha		#salva o endereco de linha em a0
				syscall			#printa a0
				addi $t5, $zero, 0	#volta t5 para primeiro termo
		continua:
			addi $t4, $t4, 8		#passa para o proximo double
			j While2			#volta para while2
		fim2:
			jr $ra	
	imprime_l:				# codigo para imprimir um double		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20, $f2		# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20, $f20			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f20			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f4		# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f8			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f20			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f6		# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f10			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f14			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		jr $ra	
		
	imprime_u:				# codigo para imprimir um double		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f22		# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f16			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f18			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f20		# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f22			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f24			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f20		# $f12 é o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f20			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li $v0, 4		#chama funcao imprimir string (dar um tab)
		la $a0, tab		#salva o endereco de tab em a0
		syscall	
		li $v0, 3			#chama a funcao para imprimir double
		add.d $f12, $f20,$f22			# $f12 e o registrador que ira conter o valor a ser impresso
		syscall	
		li, $v0, 4		#chama funcao imprimir string (pula linha)
		la $a0, linha		#salva o endereco de linha em a0
		syscall			#printa a0
		jr $ra
	fim:
		li $v0, 10				# codigo para encerrar o programa
		syscall					# executa a chamada do SO para encerrar
