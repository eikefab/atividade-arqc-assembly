.data
	new_line: .asciiz "\n"
	opcoes: .asciiz "\nSelecione uma op��o: \n1 - Fahrenheit -> Celsius\n2 - Fibonacci\n3 - En�simo par\n4 - Sair\n-> "
	resultado: .asciiz "Resultado = "
	encerrado: .asciiz "\n\nPrograma encerrado."
	
	temperatura: .asciiz "\nDigite a temperatura em �F para ser convertida �C -> "
	
	termo: .asciiz "\nDigite a posi��o desejada -> "
	termo_resultado: .asciiz "� termo da sequ�ncia � -> "
	termo_nao_suportado: .asciiz " n�o � uma posi��o poss�vel sequ�ncia.\n"
	
	par: .asciiz "� par � -> "
	par_nao_suportado: .asciiz " n�o � suportado.\n"
.text

menu:
	la $a0, opcoes
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	beq $t0, 1, fahrenheit
	beq $t0, 2, fibonacci
	beq $t0, 3, enesimo_par
	beq $t0, 4, saida
	
	j menu

fahrenheit:
	la $a0, temperatura
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	mov.d $f12, $f0
	
	la $a0, resultado
	li $v0, 4
	syscall
	
	li $t0, 32
	mtc1 $t0, $f0 # Move para o coprocessador usado para c�lculo de ponto-flutuante
	cvt.s.w $f0, $f0 # Converte palavras (ex.: 1.4E-44) para n�mero de precis�o simples (1.4)

	sub.s $f12, $f12, $f0 # Subtraindo o valor recebido por 32

	li $t0, 5
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0

	li $t0, 9
	mtc1 $t0, $f1
	cvt.s.w $f1, $f1

	div.s $f0, $f0, $f1 # Dividindo 5 por 9

	# $f12 � o registrador padr�o que � usado ao chamar a syscall
	mul.s $f12, $f12, $f0 # Multiplicando (valor) - 32 por 5/9
	
	li $v0, 2
	syscall
	
	la $a0, new_line
	li $v0, 4
	syscall
	
	j menu

fibonacci:
	la $a0, termo
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	blez $v0, fibonacci_erro
		
	move $t0, $v0
	
	li $t1, 0
	li $t2, -1
	li $t3, 1

fibonacci_loop:
	bgt $t1, $t0, fibonacci_resultado
	add $t1, $t1, 1
	
	move $t4, $t3 # Termo anterior � soma
    	add $t3, $t3, $t2 # Soma o termo atual com o anterior (1 + (-1) = 0, 1 + 0 = 1, 0 + 1 = 1, 1 + 1 = 2, 2 + 1 = 3, ...)
    	move $t2, $t4 # Copia o termo anterior ao registrador
	
	j fibonacci_loop

fibonacci_resultado:
	move $a0, $t0
	li $v0, 1
	syscall

	la $a0, termo_resultado
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	la $a0, new_line
	li $v0, 4
	syscall
	
	j menu

enesimo_par:
	la $a0, termo
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	
	move $t0, $v0
	
	blez $v0, enesimo_par_erro
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	mul $t0, $t0, 2
	
	la $a0, par
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	j menu
	
enesimo_par_erro:
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, par_nao_suportado
	li $v0, 4
	syscall
	
	j menu

fibonacci_erro:
	move $a0, $v0
	li $v0, 1
	syscall

	la $a0, termo_nao_suportado
	li $v0, 4
	syscall
	
	j menu
	
saida:
	la $a0, encerrado
	li $v0, 4
	syscall
	