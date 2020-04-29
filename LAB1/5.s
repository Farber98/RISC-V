#Modifique el ejercicio visto en la clase de laboratorio para prender los segmentos
#correspondientes a un dígito determinado. El valor a mostrar, que deberá estar entre
#0 y 9, se encuentra almacenado en el registro R0. Para la solución deberá utilizar una tabla de
#conversión de BCD a 7 segmentos la cual deberá estar almacenada en memoria no volatil. La
#asignación de los bits a los correspondientes segmentos del dígito se muestra en la figura que
#acompaña al enunciado. */

    
.data 
	tabla: 
    .byte 0x3F, 0x06, ,0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x3C, 0x39, 0x5E, 0x79, 0x71   #Armo la tabla BCD a 7segm
#          0     1      2     3     4     5     6     7      8     9    A     b     c     d     e      f

 	cad: .asciiz "El numero a mostrar es: "

.text              
.globl main    
    
main:
	LA a2, tabla 
    LI a3, 12	#Numero que quiero
reloj:
	MV t0, a2 #Auxiliar de tabla para obtener numero
    ADD t0,a2,a3 #Direccion del numero que quiero
    LI a0,4 #Mostrar cadena
    LA a1, cad
    ECALL
    LI a0,1 #Mostrar entero --> Muestra el valor entero del HEXA correspondiente.
    LB a1,0(t0) 
    ECALL
    LI a0, 10 #Finalizar programa
    ECALL
    
    

