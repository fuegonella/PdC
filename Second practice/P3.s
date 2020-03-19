	.data		# directiva que indica la zona de datos
cad1: 	.asciiz	"Evaluacion polinomio f(x) = a x^3  + b x^2 + c x + d  en un intervalo [r,s]\n"
cad2:	.asciiz	"Introduzca los valores de a,b,c y d (separados por retorno de carro): \n"
cad3:	.asciiz	"Introduzca [r,s] (r y s enteros, r <= s)  (separados por retorno de carro): \n"
cad4:	.asciiz	"f("
cad5:	.asciiz	") = "
salto:	.asciiz	"\n"


	.text	# directiva que indica la zona de código
main:

	li	$v0, 4	#4, Función imprimir por consola.
	la	$a0, cad1	# $a0, Dirección de la cadena a imprimir.
	syscall

	li	$v0, 4	#4, Función imprimir por consola.
	la	$a0, cad2	# $a0, Dirección de la cadena a imprimir.
	syscall

	#Introducir valores en las variables flotantes.
	li $v0, 6	#6, Función leer flotante simple presición.
	syscall
	mov.s $f1, $f0	#Almaceno en $f1 el valor de a.

	li $v0, 6	#6, Función leer flotante simple presición.
	syscall
	mov.s $f2, $f0	#Almaceno en $f2 el valor de b.

	li $v0, 6	#6, Función leer flotante simple presición.
	syscall
	mov.s $f3, $f0	#Almaceno en $f3 el valor de c.

	li $v0, 6	#6, Función leer flotante simple presición.
	syscall
	mov.s $f4, $f0	#Almaceno en $f4 el valor de d.

	leerango:
		li	$v0, 4	#4, Función imprimir por consola.
		la	$a0, cad3	# $a0, Dirección de la cadena a imprimir.
		syscall

		#Introducir valores en las variables enteras.
		li $v0, 5	#6, Función leer entero.
		syscall
		move $s0, $v0	#Almaceno en $s0 el valor de r.

		li $v0, 5	#6, Función leer entero.
		syscall
		move $s1, $v0	#Almaceno en $s1 el valor de s.

		bgt $s0, $s1, leerango  #Vuelve a "leerango" si s es mayor que r.

  #x en float
  mtc1 $s0, $f22  #Copia cruda de r a $f22.
  cvt.s.w $f20, $f22  #Almacenar en $f20 el número $f22 bien codificado (IEEE754).
  move $t0, $s0  #Copiar en $t0 el valor de r (r = x)

  li $s2, 1  #Guardo en $s2 el valor 1.
  mtc1 $s2, $f24  #Copia cruda de $s2 a $f24.
  cvt.s.w $f26, $f24  #Almacenar en $f26 el número $f24 bien codificado (IEEE754).

  bucle1:
    mul.s $f10, $f1, $f20  #Guardo en $f10 la multiplicación de $f1 (a), y $f20 (x).
    mul.s $f10, $f10, $f20  #Guardo en $f10 la multiplicación de $f10 (ax), y $f20 (x).
    mul.s $f10, $f10, $f20  #Guardo en $f10 la multiplicación de $f10 (ax x), y $f20 (x).

    mul.s $f11, $f2, $f20  #Guardo en $f11 la multiplicación de $f2 (b), y $f20 (x).
    mul.s $f11, $f11, $f20  #Guardo en $f11 la multiplicación de $f11 (bx), y $f20 (x).

    mul.s $f12, $f3, $f20  #Guardo en $f12 la multiplicación de $f3 (c), y $f20 (x).

    add.s $f10, $f10, $f11  #Guardo en $f10 la la suma de $f10 (ax x x), y $f11 (bx x).
    add.s $f10, $f10, $f12  #Guardo en $f10 la la suma de $f10 (ax x x + bx x), y $f12 (cx).
    add.s $f10, $f10, $f4  #Guardo en $f10 la la suma de $f10 (ax x x + bx x + cx), y $f4 (d).

	  li	$v0, 4	#4, Función imprimir por consola.
	  la	$a0, cad4	#$a0, Dirección de la cadena a imprimir.
	  syscall

    #Imprime x (entero)
    li	$v0, 1  #1, Función imprimir entero por consola.
    move $a0, $t0 #$a0, Dirección del entero a imprimir.
    syscall

    li	$v0, 4	#4, Función imprimir por consola.
	  la	$a0, cad5	#$a0, Dirección de la cadena a imprimir.
	  syscall

    #Imprime el resultado (flotante)
    li	$v0, 2  #1, Función imprimir flotante simple presición por consola.
    mov.s $f12, $f10 # $f12, Dirección del flotante simple presicióna a imprimir.
	  syscall

    li	$v0, 4	#4, Función imprimir por consola.
	  la	$a0, salto	# $a0, Dirección de la cadena a imprimir.
	  syscall

		bge $t0, $s1, salida	#Si se cumple la condicion de (x >= s), sale del bucle.
    add.s $f20, $f20, $f26  #Sumar a $f20 (x flotante) el valor de $f26 (1 flotante).
    add $t0, $t0, 1  #Sumar a $t0 (x entero) 1.
		j bucle1  #Salta a bucle1.

	#Instrucciones que finaliza el programa.
	salida:
		li $v0,10
		syscall