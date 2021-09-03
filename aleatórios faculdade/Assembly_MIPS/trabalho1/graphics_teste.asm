.data 

	campo1:	.asciiz "Nome:"
	campo2:	.asciiz "Numero:"
	campo3:	.asciiz "E-mail:"
	
	error_noData:		.asciiz	"Campo vazio"
	error_size_exceeded:	.asciiz	"Tamanho excedido"
	
	nome: 	.asciiz	"empty"
	email:	.asciiz	"empty"
	numero:	.word	0

.text

main:
	li $v0, 54
	la $a0, campo1
	la $a1, nome
	li $a2, 150
	syscall
	beq $a1, -3, noData
	beq $a1, -4, size_exceeded
	li $v0, 10
	syscall
	
noData:
	li $v0, 55
	la $a0, error_noData
	li $a1, 2
	syscall
	j main
	
size_exceeded:
	li $v0, 55
	la $a0, error_size_exceeded
	li $a1, 2
	syscall
	j main
	
	
	li $v0, 10
	syscall
	
