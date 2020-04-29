#3 eval 2019) Escriba un programa en lenguaje ensamblador RV32IM del RISC-V que reciba la dirección de
#una cadena de caracteres en el registro a0, que vaya imprimiendo uno a uno los caracteres
#de la misma hasta encontrar el valor cero, y en ese momento finalice mostrando por consola
#en una linea separada la longitud de la cadena.

.data
	cad: .word 'e','l',' ','c','e','r','o','o','o','o', 0,'n','o','l','l','e','g','a'
    cad1: .asciiz "Cadena hasta encontrar el cero: "
    cad2: .asciiz "Longitud cadena: "
    
.text
.globl main

mostrar:
	LW t0,0(a3)
    BEQZ t0, finaliza
    LI a0,11			# Selección del servicio: mostrar un ASCII por pantalla
    MV a1,t0		# Cargamos el valor que queremos mostrar
	ECALL
    JR ra
    

#a2 = Direcc base
#a3 = Aux base
#s2 = contador
#t0 = elem
main:
	LA a2,cad
    MV a3,a2   #Auxiliar para desplazarme
    LI s2,0		#Contador caracteres
    LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
    LA a1,cad1 		# Apuntamos al inicio de la cadena a imprimir
	ECALL

lazo:
    JAL mostrar
    ADDI s2, s2, 1
    ADDI a3, a3, 4
    J lazo

finaliza:
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad2 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s2		# Cargamos el valor que queremos mostrar
	ECALL
finalposta:
	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 			# Termina el programa y retorna al sistema operativo
