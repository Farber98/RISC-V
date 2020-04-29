#3 eval 2019) Escriba un programa en lenguaje ensamblador RV32IM del RISC-V que reciba la dirección de
#una cadena de caracteres en el registro a0, que vaya imprimiendo uno a uno los caracteres
#de la misma hasta encontrar el valor cero, y en ese momento finalice mostrando por consola
#en una linea separada la longitud de la cadena.

.data
    cad: .word 'p','a','u','l',' ','p','l','a','n','t','s',0
    
.text
.globl main

esmayusc:
    LI t1,90  # 90 es la ultima mayuscula del asci --> Z
	BGTU a4,t1,mayusc #Se fija si es mayus, sino sale y va a noesmayus
    BGTU s3, zero, noesmayus2 #En caso de evaluar el apellido se va a noesmayus2, usando la bandera de apellido.
    j noesmayus

mayusc:
    ADDI a4, a4, -32 #Todas las mayus estan a -32 de distancia de su minusc. Hago mayus
    BGTU s3, zero, noesmayus2 #En caso de evaluar el apellido, se va a noesmayus 2, usando la bandera de apellido.
    j noesmayus 

mostrarn:
	LW a4,0(a3) #Traigo el elemento
    LI t3,32 # Cargo el 32 (espacio en ascii) para evaluar condicion
    BEQ a4, t3, apellido # Finalizo nombre con el espacio.
    BEQ s2,zero, esmayusc #Si la bandera de primera mayuscula esta en 0, voy a evaluar el primer caracter.
noesmayus:    
    LI a0,11			# Selección del servicio: mostrar un ASCII por pantalla
    MV a1,a4		# Cargamos el valor que queremos mostrar
	ECALL
    JR ra
    

#a2 = Direcc base
#a3 = Aux base para desplazamiento
#a4 = Caracteres
#s2 = Bandera para la primera minus.
#s3 = Cuando trabajo con apellido, una bandera.
main:
	LA a2,cad
    MV a3,a2   #Auxiliar para desplazarme
	LI s2, 0   #Bandera primera minus en 0
    LI s3, 0   #Bandera apellido en 0

lazonombre:
    JAL mostrarn
    ADDI a3, a3, 4	 #Desplazamiento de caracteres
    ADDI s2,s2,1 	#Bandera seteada 
    J lazonombre

mostrarap:
	LW a4,0(a3)
    BEQ a4,zero,finaliza
	J esmayusc
noesmayus2:
    LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    MV a1,a4		# Cargamos el valor que queremos mostrar
	ECALL
    JR ra

apellido:
	    ADDI s3, s3, 1
    
lazo2:
	JAL mostrarap
    ADDI a3, a3, 4
    j lazo2

finaliza:
	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 			# Termina el programa y retorna al sistema operativo
