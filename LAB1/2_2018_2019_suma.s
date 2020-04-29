#2 eval 2018) En la siguiente porción de código, se utiliza la función serie(x,n) , la cual se encarga de mos-
#trar una serie de n números de la forma x ∗ i, donde i es la posición del elemento y x es un
#valor constante que la función recibe como parámetro. Por ejemplo, para x = 3 y n = 5, se
#debe mostrar por pantalla la serie: 3, 6, 9, 12, 15.

.data
	cad: .asciiz "El resultado es: "
    com: .asciiz ", "
	
.text
.globl main

mostrar:
	LI a0,1 #Mostrar entero por pantalla
	MV a1,a5
    ECALL
    
	LI t0,0 #Para ver si pongo la coma. (hay un elemento antes o no) 
    BGTU a4,t0,coma

volver:
    JR ra
    
coma: 
	BEQ a4,a3,volver #Para que no ponga la coma despues del ultimo (n) 
	LI a0, 4  #Mostrar cadena por pantalla
    LA a1, com
    ECALL
    J volver


main:
	LI a2, 3 # x 
    LI a3, 5 # n
	LI a4, 0 # Aux para cortar
    LI a5, 0 # Suma	
cadena:
	LI a0, 4  #Mostrar cadena por pantalla
    LA a1, cad
    ECALL

lazo:
	ADDI a4,a4 ,1 # Sumo uno 
	ADD a5, a5, a2 
    JAL mostrar
    BEQ a4, a3, final #Cuando aux es igual a n corto
    J lazo
    
final:    
    LI a0, 10  #Finalizar programa
    ECALL
	

