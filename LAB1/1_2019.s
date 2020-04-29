#1 eval 2019) En los ambientes de procesamiento gráfico o procesamiento de señales, son muy usadas las
#interpolaciones lineales de la forma Z = X ∗ a + Y ∗ (1 − a), donde X, Y, Z son vectores y a es
#una constante entre 0 y 1. Escribe un programa que calcule la interpolación lineal sobre dos vectores utilizando la
#subrutinas anteriores y muestre el vector de resultado por la pantalla.

.data
	vectX: .word 1,2,3,4,5,6,7 # ---------------> Setear vector X
    vectY: .word 5,5,5,5,5,5,5 # ---------------> Setear vector Y
    vectZ: .word 0,0,0,0,0,0,0 # Vector resultante 
    cad: .asciiz "Vector resultante: "
    cor1: .asciiz "["
    cor2: .asciiz "]"
.text
.globl main

mostrarVector:
    LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,32		# Espacio
	ECALL
    LW t0, 0(a4) 	#Obtengo Zi
    LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,t0		# Cargamos el valor que queremos mostrar
	ECALL
    JR ra

cargo:
    LW t0, 0(a2) #Traigo elemento Xi
    LW t1, 0(a3) #Traigo elemento Yi
    MUL t0, t0, a5 # x * a
    LI t3, 1
    SUB t3, t3, a5 #Obtengo 1-a
    MUL t1, t1, t3 # Yi * (1-a)
	ADD t2, t1, t0 # x * a + Yi * (1-a)
    SW t2, 0(a4) #Guardo en Z vector de resultados
    JR ra
    
#a2 --> Direcc VectX
#a3 --> Direct VectY
#a4 --> Direct Vect Z
#a5 --> constante
#s2 --> Tam vect para cortar
#s3 --> Contador


main:
	LA a2, vectX
    LA a3, vectY
    LA a4, vectZ
    LI a5, 10 # --------------------> Setear constante a
    LI s2, 7 #  --------------------> Setear tamaño de vector
    LI s3, 0 #Contador
lazo:
    BEQ s3, s2, final
	ADDI s3, s3, 1
    JAL cargo
	ADDI a2, a2, 4  #Desplazo para leer los datos siguientes
    ADDI a3, a3, 4
    ADDI a4, a4, 4
	J lazo
    
final:
	LI a0, 4  #Mostrar cadena por pantalla
    LA a1, cad
    ECALL
	LI a0, 4  #Mostrar cadena por pantalla
    LA a1, cor1
    ECALL
    LA a4,vectZ
    LI s5, 0 #Auxiliar para cortar
	LI t0, 4 #Auxiliar para calcular cond corte.
    MUL s4, s2, t0 # Condicion de corte: Cuando t1 llegue a recorrer los n --> (n x 4)

evaluo:
	BEQ s5, s4, sigo
    JAL mostrarVector
    ADDI s5, s5, 4	#Para encontrar corte.
    ADDI a4, a4, 4 #Para ir desplazando por Z
    J evaluo
sigo:   
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,32		# Espacio
	ECALL
    LI a0, 4  		#Mostrar cadena por pantalla
    LA a1, cor2		# Corchete
    ECALL
    
 finprog:
 	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 		# Termina el programa y retorna al sistema operativo

