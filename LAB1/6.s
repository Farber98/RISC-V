# C = C + A * B para ganar generalidad.
#Las matrices A, B y C son matrices cuadradas de 32x32 elementos, y cada
#elemento es de tipo entero de 32 bits.

#Como las matrices son pasadas como parámetros, puede asumir que las direcciones base de
#cada una están en los registros a0, a1 y a2 (para C, A y B respectivamente).
#Al igual que en muchos otros lenguajes de programación, en C las matrices en memoria se almacenan
#ordenadas por filas. Esto quiere decir que primero se guarda en memoria la primera
#fila completa, luego la segunda fila completa, y así sucesivamente con el resto de las filas.
#Las variables temporales i, j y k se pueden mapear a los registros t0, t1 y t2, respectivamente.

#Lista de registros:
# a0: base de matriz A
# a1: base de matriz B
# a2: base de matriz C

#************************COMO USAR:
#************************1. Para mostrar resultados, ajustar A7 antes de llamar cada vez a subrutina poniendo CANTIDAD DE ELEMENTOS (3x3=9)
#************************2. Dentro de la subrutina apenas empieza, ajustar S11 poniendo NUMERO DE COLUMNAS (3)

.data
    A: .word 1,2,3,4,5,6,7,8,9
    B: .word 11,22,33,44,55,66,77,88,99
    C: .word 0,0,0,0,0,0,0,0,0
    cor0: .asciiz "[ "
    cor1: .asciiz " ]"
    coma: .asciiz " , "

.text
.globl main

main:
    LA a0, A 
    LA a1, B 
    LA a2, C 
    
    jal productoMatrices
    
    #Vamos a mostrar bro
    LA a6, A
    LI a7, 9
    jal mostrarVector
    LA a6, B
    LI a7, 9
    jal mostrarVector
    LA a6, C
    LI a7, 9
    jal mostrarVector
    
finalposta:
    LI a0,10    # Selección del servicio terminar el programa sin error
    ECALL           # Termina el programa y retorna al sistema operativo   

#******************Inicio subrutina productoMatrices. Recibe matrices A B y C en a0 a1 y a2
# t0: indice i
# t1: indice j
# t2: indice k
#t3 es c[i][j]
#t4 es a[i][k]
#t5 es b[k][j]
#t6 me ayuda a calcular los offsets
#s11 es numero de columnas      YA SE QUE NO SE DEBE USAR
productoMatrices:
    LI s11, 3   #Numero de columnas
    #LI s10, 16 #A comparar para las condiciones
    LI t0, 0 #i=0
    
cond1:
    BEQ t0,s11,salirProductoMatrices
    LI t1, 0 #j=0

cond2:
    BEQ t1,s11,salgoCond2
    LI t2, 0 #k=0
    
cond3:
    BEQ t2,s11,salgoCond3
    #ACA HAGO EL CALCULO
    #obtener a[i][k]
        #Calculo el offset en t6
        MUL t6,t0,s11    #offset=i*N
        ADD t6, t6, t2   #offset=i*N+k
        SLLI t6,t6,2     #offset=((i*N)+k)*4            Ya puedo obtener el elemento
        
        ADD a0, a0, t6  #Agrego offset a A.         Recordar despues devolver puntero de A al inicio!!!!
        LW t4, 0(a0)    #t4=a[i][k]
        SUB a0, a0, t6  #Quito offset de A.         Listo!!!!!
    #obtener b[k][j];
        #Calculo el offset en t6
        MUL t6,t2,s11    #offset=k*N
        ADD t6, t6, t1   #offset=k*N+j
        SLLI t6,t6,2     #offset=((k*N)+j)*4            Ya puedo obtener el elemento
        
        ADD a1, a1, t6  #Agrego offset a B.         Recordar despues devolver puntero de B al inicio!!!!
        LW t5, 0(a1)    #t5=b[k][j]
        SUB a1, a1, t6  #Quito offset de B.         Listo!!!!!
    #multiplicar esos dos
        MUL t4,t4,t5    #a[i][k]=a[i][k]*b[k][j]
    #obtener c[i][j]
        #Calculo el offset en t6
        MUL t6,t0,s11    #offset=i*N
        ADD t6, t6, t1   #offset=i*N+j
        SLLI t6,t6,2     #offset=((i*N)+j)*4            Ya puedo obtener el elemento
        
        ADD a2, a2, t6  #Agrego offset a C.         Recordar despues devolver puntero de C al inicio!!!!
        LW t3, 0(a2)    #t3=c[i][j]
        
        #Hago por fin el calculo, y lo meto en memoria
        ADD t3,t3,t4    #sumar en c[i][j] el producto anterior
        SW t3, 0(a2)    #Guardo resultado en memoria. Ahora si devuelvo puntero de C al inicio.
        
        SUB a2, a2, t6  #Quito offset de C.         Listo!!!!!
        
        ADDI t2,t2,1    #k++
        J cond3

salgoCond2:
    ADDI t0, t0, 1 #i++
    J cond1
    
salgoCond3:
    ADDI t1, t1, 1 #j++
    J cond2

salirProductoMatrices:
    JR ra
#******************Fin subrutina productoMatrices


#******************Inicio subrutina mostrarVector. Recibe en a6 el inicio y en a7 el tamano
#t0 es el indice
#t1 es el tamano
#t3 es [indice]
mostrarVector:
    MV t0, a6 #En registro temporal t0 pongo el indice para ir avanzando
    SLLI a7,a7,2    #tam=tam*4 por ser de 32 bits
    ADD t1, a7, a6 #En registro temporal t1 pongo tamano pero en direcciones
    
    #Abro corchete
    LI a0,4     # Selección del servicio: mostrar una cadena por pantalla
    LA a1,cor0      # Apuntamos al inicio de la cadena a imprimir
    ECALL
    
lazoMostrarVector:
    BEQ t0,t1, salgoMostrarVector #Si ya mostre todos los elementos ,salgo. Sino, sigo mostrando
    
    #Muestro el elemento
    LI a0,1         # Selección del servicio: mostrar un entero por pantalla
    LW t3, 0(t0)    #Traigo de memoria el valor del elemento
    MV a1,t3        # Cargamos el valor que queremos mostrar
    ECALL           # Pedimos el servicio, el entero se muestra en la pantalla
    ADDI t0,t0,4    #i++
    
    #Pongo la coma
    LI a0,4     # Selección del servicio: mostrar una cadena por pantalla
    LA a1,coma      # Apuntamos al inicio de la cadena a imprimir
    ECALL
    J lazoMostrarVector
    
salgoMostrarVector:
    #Cierro corchete
    LI a0,4     # Selección del servicio: mostrar una cadena por pantalla
    LA a1,cor1      # Apuntamos al inicio de la cadena a imprimir
    ECALL
    JR ra
    
#******************Fin subrutina mostrarVector