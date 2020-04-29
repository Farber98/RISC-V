#Escriba una subrutina que reciba dos elementos A y B almacenados en memoria, los compare
#y los intercambie para retornar siempre con A menor que B. La subrutina recibe las direccio-
#nes de los elementos en los registros a0 y a1 respectivamente. Escriba además un programa
#principal de prueba que defina dos valores y muestre por pantalla cuál es el menor.
.data
	memA: .word 999
    memB: .word 111
    
    cad1: .asciiz "Inicial(A,B): "
	cad2: .asciiz " Final(A,B): "
    
    
.text
.globl main

# Uso de registros
# a2 = memA.
# a3 = elemA
# a4 = memB.
# a5 = elemB

cargo:
	LW t0, 0(a2) # elemA
    LW t1, 0(a4) # elemB

comparar:
	BLTU t0, t1, final
    SW t0, 0(a4)
    SW t1, 0(a2)
    JR ra

main:
    LA a2, memA
    LA a4, memB
    LW s2, 0(a2) #Posicion inicial elemA
    LW s4, 0(a4) #Posicion inicial elemB
    JAL cargo
    
final:
	LI a0, 4  #Seleccion servicio mostrar cadena por pantalla
    LA a1, cad1
    ECALL
    LI a0, 1  #Selecciono servicio mostrar entero por pantalla.
    MV a1,s2  #Cargo inicial elemA
    ECALL
    LI a0, 1  #Selecciono servicio mostrar entero por pantalla.
    MV a1,s4  #Cargo inicial elemB
    ECALL
  	LI a0, 4  #Seleccion servicio mostrar cadena por pantalla
    LA a1, cad2
    ECALL
    LI a0, 1  #Selecciono servicio mostrar entero por pantalla.
    LW t0,0(a2)
    MV a1,t0   #Cargo final elemA
    ECALL
    LI a0, 1  #Selecciono servicio mostrar entero por pantalla.
    LW t0,0(a4)
    MV a1,t0  #Cargo final elemB
    ECALL
	LI a0,10  #Seleccion servicio terminar programa sin error.
    ECALL
    
    
