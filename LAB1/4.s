#Usando la subrutina del ejercicio anterior escriba una subrutina que ordene de menor a mayor
#los elementos de un vector de número de 8 bits sin signo usando el método de ordenamiento
#que usted considere conveniente. El puntero al primer elemento se recibe en el registro a0 y
#la cantidad de elementos en a1. Para las pruebas utilice un vector que tenga como mínimo 10
#elementos.

#Lista de registros:
# a0: base del vector
# a1: tamano del vector

.data
	vector: .byte 54,5,23,0,65,2,84,78,37,97
    cor0: .asciiz "[ "
    cor1: .asciiz " ]"
    coma: .asciiz " , "

.text
.globl main

main:
	LA a0, vector #Guardo en a0 direccion de la base del vector
	LI a1, 10 #Guardo en a1 el tamano del vector 
    jal ordenarVector
    
    #Vamos a mostrar bro
    LA a6, vector
    LI a7, 10
    jal mostrarVector
    
finalposta:
	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 			# Termina el programa y retorna al sistema operativo   

#Inicio subrutina ordenarVector. Recibe en a0 la base del vector, y en a1 el tamano
#t0 es i
#t1 es j
#t2 es [i]
#t3 es [j]
ordenarVector:
	MV t0,a0 #Equivale a i=0 pero de acuerdo a la direccion
    ADD a1,a1,a0 #Obtengo el tamano pero de acuerdo a las direcciones

cond1: #i==tam? Recordar que tam es 10, pero elemento max es 9
    BEQ t0,a1, salir #Si i==tam, salir. Sino, avanzo
    ADDI t1,t0,1 #j=i+1
   
cond2: #j==tam?
	BEQ t1,a1, incrementoi #Si j==tam, incremento i++. Sino, avanzo
    LB t2,0(t0) #t2 guarda el valor de [i]
    LB t3,0(t1) #t3 guarad el valor de [j]
    BLTU t2,t3, salgo #Si A<B, no hago nada y salgo. Sino, los cambio de lugar
    SB t2,0(t1) #cambio en memoria A por B
    SB t3,0(t0)	#cambio en memoria B por A
    
salgo:
	ADDI t1, t1, 1 #j++
    J cond2 #Vuelvo al inicio del lazo
    
incrementoi:
	ADDI t0,t0,1 #i++
    J cond1 #Vuelvo a condicion1
	
salir:
	JR ra
#Fin subrutina ordenarVector

#Inicio subrutina mostrarVector. Recibe en a6 el inicio y en a7 el tamano
#t0 es el indice
#t1 es el tamano
#t3 es [indice]
mostrarVector:
	MV t0, a6 #En registro temporal t0 pongo el indice para ir avanzando
    ADD t1, a7, a6 #En registro temporal t1 pongo tamano pero en direcciones
    
    #Abro corchete
    LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cor0 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
    
lazoMostrarVector:
	BEQ t0,t1, salgoMostrarVector #Si ya mostre todos los elementos ,salgo. Sino, sigo mostrando
	
    #Muestro el elemento
    LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    LB t3, 0(t0)	#Traigo de memoria el valor del elemento
    MV a1,t3		# Cargamos el valor que queremos mostrar
	ECALL 			# Pedimos el servicio, el entero se muestra en la pantalla
    ADDI t0,t0,1    #i++
    
    #Pongo la coma
    LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,coma 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
    J lazoMostrarVector
    
salgoMostrarVector:
	#Cierro corchete
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cor1 		# Apuntamos al inicio de la cadena a imprimir
	ECALL
    JR ra
	
#Fin subrutina mostrarVector
