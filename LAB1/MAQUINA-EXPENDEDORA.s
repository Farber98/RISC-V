#Se desea implementar el código de una función de una máquina expendedora de gaseosas,
#a la cual se le ingresa un cierto monto de dinero, y devuelve la cantidad mínima de monedas
#que debe entregar para llegar a ese monto. La máquina trabaja con monedas de $1, $5 y $10.
#Por ejemplo, si se ingresa el monto 45, se espera que la función devuelva que debe entregar
#4 monedas de $10 y 1 moneda de $5.

.data
	cad0: .asciiz "Monto ingresado: "
    cad1: .asciiz "Monedas 10 pesos: "
    cad2: .asciiz "Monedas 5 pesos: "
    cad3: .asciiz "Monedas 1 peso: "
    
.text
.globl main
nollega:
	JR ra

diez:
	LI t0,10
	BGTU t0, a2, nollega
    ADDI s2,s2,1 #Sumo una moneda
    ADDI a2,a2, -10 #Resto 10 a monto.
    J diez #Vuelvo a evaluar.

cinco:
	LI t0,5
	BGTU t0, a2, nollega
    ADDI s3,s3,1 #Sumo una moneda
    ADDI a2,a2, -5 #Resto 10 a monto.
    J cinco #Vuelvo a evaluar.

uno:
	LI t0,1
	BGTU t0, a2, nollega
    ADDI s4,s4,1 #Sumo una moneda
    ADDI a2,a2, -1 #Resto 10 a monto.
    J uno #Vuelvo a evaluar.
    
#a2 = Monto
#s2 = Contador monedas 10
#s3 = Contador monedas 5
#s4 = Contador monedas 1
main:
	LI a2, 27
    MV a3,a2
    LI s2, 0   
    LI s3, 0
    LI s4, 0

lazo:
	BEQZ a2, finaliza #cuando el monto llega a cero finaliza.
	JAL diez
    JAL cinco
    JAL uno
    J lazo

finaliza:
	#Monto ingresado
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad0 		# Cadena monto
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,a3		# Monto
    ECALL
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
    #Monedas 10
	LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad1 		# Cadena monto
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s2		# Monto
    ECALL
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
    #Monedas 5
    LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad2 		# Cadena monto
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s3		# Monto
    ECALL
	LI a0,11		# Selección del servicio: mostrar un ASCII por pantalla
    LI a1,10		# Cargamos el valor que queremos mostrar --> Salto de linea
	ECALL
    #Monedas 1
    LI a0,4 	# Selección del servicio: mostrar una cadena por pantalla
	LA a1,cad3 		# Cadena monto
	ECALL
	LI a0,1			# Selección del servicio: mostrar un entero por pantalla
    MV a1,s4		# Monto
    ECALL
    #Fin
	LI a0,10 	# Selección del servicio terminar el programa sin error
	ECALL 			# Termina el programa y retorna al sistema operativo

