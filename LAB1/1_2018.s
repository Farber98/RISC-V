#1 eval 2018) Escriba un programa en lenguaje ensamblador RV32IM del RISC-V que reciba un número entero
#en el registro a0 y devuelva por consola la raíz cuadrada aproximada del mismo. Para calcular
#la misma utilice aproximaciones sucesivas calculando el producto de los números enteros
#hasta obtener el más cercano inferior al número ingresado. Agregue las cadenas de texto
#adecuadas para indicar qué significa el resultado.

.data
	cad: .asciiz "El resultado es: "
    
.text
.globl main

main:
	LI a3, 230 # Cargo numero que quiero obtener la raiz aprox.
    LI t0, 0 #Inicializo resultado
lazo:
	ADDI t0, t0, 1 #Sumo uno a resultado
    MUL t1, t0, t0 #Obtengo su cuadrado
    BEQ t1,a3 mostrar  #En caso de que sea numero exacto no debo restar
    BGE t1, a3, salgo2 #En caso de que sea numero aproximado debo restar 
    J lazo
    
salgo2:
	ADDI t0, t0, -1 # Le resto uno porque ya me pase debido a la condicion BGE
    
mostrar:
	LI a0, 4  #Mostrar cadena por pantalla
    LA a1, cad
    ECALL
    LI a0,1 #Mostrar entero por pantalla
	MV a1,t0
    ECALL
    LI a0, 10  #Finalizar programa
    ECALL
	
