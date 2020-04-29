#Escriba una subrutina en lenguaje ensamblador RV32IM que reciba la dirección de un vector
#de enteros en el registro a0, lea todos los elementos del vector hasta encontrar el valor cero,
#y en ese momento finalice indicando la cantidad de números pares e impares que contiene
#dicho vector.

.data
	cad: .word 1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,0
    cad1: .asciiz "Cadena hasta encontrar el cero: "
    cad2: .asciiz "Pares: "
    cad3: .asciiz "Impares: "
    
.text
.globl main
sumopar:
	ADDI s2, s2, 1 #Si entro es par
    J vuelvo

mostrar:
	LW t0,0(a3)  #Traigo el elemento del vector
    BEQZ t0, finaliza  #Si el elemento es 0 finaliza
    LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,t0		# Cargamos el valor que queremos mostrar
    ECALL
    LI a0,11			# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,32			# Espacio en ascii
    ECALL
    LI t1, 2 #Para ver si es par o impar
    REMU t0,t0,t1 #Obtengo el residuo de la division
    BEQZ t0, sumopar
    ADDI s3,s3, 1 #Si no se fue al salto es impar
vuelvo:
    JR ra
    

#a2 = Direcc base
#a3 = Aux base
#s2 = contador pares
#s3 = contador impares
#t0 = elem
main:
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
    LA a1,cad1 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
    LA a2,cad
    MV a3,a2   #Auxiliar para desplazarme
    LI s2,0		#Contador pares
    LI s3,0     #Contador impares
    
lazo:
    JAL mostrar
    ADDI a3, a3, 4
    J lazo

finaliza:
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
    #Pares
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad2 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
    LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s2		# Cargamos el valor que queremos mostrar
    ECALL
 	
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
	#Impares
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad3 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s3		# Cargamos el valor que queremos mostrar
    ECALL
	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 			# Termina el programa y retorna al sistema operativo

