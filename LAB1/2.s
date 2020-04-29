#Escriba un programa en lenguaje ensamblador utilizando el ISA RV32IM que reciba la dirección
# de un vector números enteros en el registro a0, lea todos los elementos del vector hasta en
# contrar el valor cero, y en ese momento finalice mostrando por consola la suma y el promedio
# (sólo parte entera) de los números leídos.

.data
	vect: .word 30,30,0,2,3,4,5
    
    cad1: .asciiz "La suma es: "
	cad2: .asciiz " El promedio es: "
    
    
.text
.globl main

# Uso de registros
# s2 = base vector.
# s3 = Auxiliar base vector.
# s4 = valor cada vector
# s5 = Suma
# s6 = Promedio
# s7 = contador

main:
    LA s3, vect
    LI s5,0  #Defino Suma
    LI s6,0 #Defini Promedio
    LI s7,0 #Defino contador
    
lazo:
	LW s4, 0(s3) #Obtengo elemento.
    BEQZ s4, finalsuma
    ADD s5,s5,s4  #Acumulo suma
    ADDI s7, s7, 1  #Sumo uno al cont
    ADDI s3, s3, 4	#Voy al siguiente elemento
    J lazo
    
finalsuma:
	LI a0, 4  #Seleccion servicio mostrar cadena por pantalla
    LA a1, cad1
    ECALL
    LI a0, 1  #Selecciono servicio mostrar entero por pantalla.
    MV a1,s5  #Cargo valor que quiero mostrar
    ECALL
    
finalprom:
	MV s6,s5
    DIV s6, s6, s7
    LI a0, 4  #Seleccion servicio mostrar cadena por pantalla
    LA a1, cad2
    ECALL
    LI a0,1  #Selecciono servicio mostrar entero por pantalla.
    MV a1, s6  #Cargo el valor a mostrar.
    ECALL
    
final:
	LI a0,10  #Seleccion servicio terminar programa sin error.
    ECALL
    
    
