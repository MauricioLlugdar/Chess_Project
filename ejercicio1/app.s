 .equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGHT, 480
.equ BITS_PER_PIXEL, 32
.equ CHESS_TABLE, 448
.equ BTW_CHESS_BORDER_WIDTH, 96
.equ BTW_CHESS_BORDER_HEIGH, 16
.equ SQUARERADIUS, 72
.equ RADIUS, 8
.equ GPIO_BASE, 0x3f200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0, 0x34
.equ GPIO_W, 0b000010
.equ GPIO_A, 0b000100
.equ GPIO_S, 0b001000
.equ GPIO_D, 0b010000
.equ GPIO_SPACE, 0b100000
.equ BLANCO, 0xF7F3BE
.equ NEGRO, 0x000000
.equ DARKCOLOR, 0x492200
.equ LIGHTCOLOR, 0xAA511E
.equ COLORCAMBIO, 0x1779D9
.equ ROJO, 0xFF0000
.equ CONSTANTLOOP, 0x1FFF0000

//norwayflag 
.equ NORROJO, 0x8a0b0b
.equ NORAZUL, 0x02044d
.equ NORBLANCO, 0xFFFFFF
//
//russiaflag 
.equ RUSROJO, 0xb31010
.equ RUSAZUL, 0x040aba
.equ RUSBLANCO, 0xFFFFFF
//


.globl main

main:
// x0 contiene la direccion base del framebuffer
mov x20, x0 // Guarda la dirección base del framebuffer en x20
//---------------- CODE HERE ------------------------------------

ldr x10, =NEGRO

resetboard:
mov x0, x20

mov x2, SCREEN_HEIGHT // Y Size
loopfondo1:
mov x1, SCREEN_WIDTH // X Size
loopfondo0:
stur w10,[x0] // Colorear el pixel N
add x0,x0,4 // Siguiente pixel
sub x1,x1,1 // Decrementar contador X
cbnz x1,loopfondo0 // Si no terminó la fila, salto
sub x2,x2,1 // Decrementar contador Y
cbnz x2,loopfondo1 // Si no es la última fila, salto

//reinicio X0 con lo guardado en x20
mov x0, x20

ldr x13, =LIGHTCOLOR

//DARK SQUARES COLORS
ldr x14, =DARKCOLOR


mov x21, CHESS_TABLE //Asigno el valor de las dimensiones del tablero

//ACOMODAMOS X0 A LA DIRECCION DE MEMORIA QUE QUEREMOS PARA QUE EL TABLERO QUEDE CENTRADO

mov x2, BTW_CHESS_BORDER_HEIGH
looptablero1:
mov x1, BTW_CHESS_BORDER_WIDTH
looptablero0:
add x0,x0,4
sub x1,x1,1
cbnz x1, looptablero0
add x0,x0,(SCREEN_WIDTH-BTW_CHESS_BORDER_WIDTH)*4
sub x2,x2,1
cbnz x2,looptablero1
add x0,x0,BTW_CHESS_BORDER_WIDTH*4 //Agrego para moverlo del margen izquierdo al medio de la pantalla

//CREAMOS TABLERO, LO QUE VAMOS A HACER ES LO SIGUIENTE: HACEMOS LA PRIMER FILA Y LUEGO HACEMOS LA SEGUNDA FILA CAMBIANDO EL ORDEN DE LOS COLORES


square:

mov x2, x21 // LARGO DEL TABLERO
switch1: mov x4, 56 // contador para el cambio de orden de los colores
looptablero3:
mov x1, x21 // ANCHO DEL TABLERO



resetlight1: mov x3, 56 // reseteo el length de cada cuadrado
light1:
stur w13,[x0] // Colorear
add x0,x0,4 // Siguiente pixel
sub x3, x3, 1 // Resto al contador del length de cada cuadrado
sub x1,x1,1 // Decrementar contador del ancho del tablero
cbz x1, nextline1 // chequeo si llegue al extremo derecho del tablero
cbz x3, resetdark1 // si ya complete el length del cuadrado, coloreo oscuro ahora
b light1 //si no termine el length del cuadrado, sigo con claro

resetdark1: mov x3, 56 // reseteo el length de cada cuadrado
dark1:
stur w14, [x0] // Colorear
add x0, x0, 4 // Siguiente pixel
sub x3, x3, 1 // Resto al contador del length de cada cuadrado
sub x1, x1, 1 // Decrementar contador del ancho del tablero
cbz x1, nextline1 // Chequeo si llegue al extremo derecho del tablero
cbz x3, resetlight1 // si ya complete el length del cuadrado, coloreo claro ahora
b dark1 //si no termine el length del cuadrado, sigo con oscuro


nextline1: add x0,x0,(SCREEN_WIDTH-CHESS_TABLE)*4 // Me salteo todo lo que queda de la fila p/ llegar a la sig fila y al centro
sub x4, x4, 1 // decremento el contador para saber si tengo que cambiar el orden de los colores
sub x2,x2, 1 // Decrementar contador del largo del tablero
cbz x2, done // Si llegue a colorear el largo del tablero, termino
cbz x4, switch2 // chequeo si ya es momento de cambiar el orden de los colores
b looptablero3 //si todavia no es momento de cambiar el orden de los colores, sigo coloreando como antes


 //MISMO CODIGO QUE ARRIBA PERO CAMBIADO EL ORDEN DE LOS COLORES


switch2: mov x4, 56 // contador para el cambio del orden de los colores

looptablero4:
mov x1, x21 // contador para el ancho del tablero



resetdark2: mov x3, 56 // reseteo el length de cada cuadrado
dark2:
stur w14,[x0] // Colorear
add x0,x0,4 // Siguiente pixel
sub x3, x3, 1 // Decremento el contador del length del cuadrado
sub x1,x1,1 // Decrementar contador del ancho
cbz x1, nextline2 //cheque si llegue al extremo derecho del tablero
cbz x3, resetlight2 //si complete el length del cuadrado, coloreo claro ahora
b dark2 // si no complete el length, sigo con oscuro

resetlight2: mov x3, 56 // reseteo el length de cada cuadrado
light2:
stur w13, [x0] // coloreo
add x0, x0, 4 // siguiente pixel
sub x3, x3, 1 // Decremento el contador del length del cuadrado
sub x1, x1, 1 // Decrementar contador del ancho
cbz x1, nextline2 // chequeo si llegue al extremo derecho del tablero
cbz x3, resetdark2 //si completee el length del cuadrado, paso a colorear oscuro
b light2 //si no complete el length del cuadrado, sigo con claro


nextline2: add x0,x0,(SCREEN_WIDTH-CHESS_TABLE)*4 // Me salteo todo lo que queda de la fila p/ llegar a la sig fila
sub x4, x4, 1 //decremento el contador para saber si tengo que cambiar el orden de los colores
sub x2,x2, 1 // Decrementar contador del largo
cbz x2, done // Si llegue a colorear el largo del tablero, termino
cbz x4, switch1 // chequeo si ya es momento de cambiar el orden de los colores
b looptablero4 //si todavia no es momento de cambiar el orden de los colores, sigo coloreando como antes

done:



//x16 es el parametro de la altura del framebuffer
//x17 es el parametro de lo ancho del framebuffer
//x18 es el parametro del ancho del lado de arriba de los trapecios
//x19 es la altura de los trapecios
//x15 sirve para colocar x0 justo para hacer un trapeciopiso abajo del circulo (si no estamos trabajando con trapeciopiso y circulo juntos, x15 tomara el valor 0, si trbajamos junto a un circulo, x15 tomara el valor de RADIUS (radio del circulo del peon, alfil y rey)
//x9 tomara el valor del cuadrado del radio que querramos hacer el circulo (en SQUARERADIUS tenemos el tamaño para hacer el circulo del peon, alfil y rey)

ldr x10, =NEGRO

mov x16, 386 // Movimiento en Y
mov x17, 517 // Movimiento en X


bl drawpawn

mov x16, 386
mov x17, 461


bl drawpawn

mov x16, 386
mov x17, 405


bl drawpawn

mov x16, 386
mov x17, 349


bl drawpawn

mov x16, 386
mov x17, 293


bl drawpawn

mov x16, 386
mov x17, 237


bl drawpawn

mov x16, 386
mov x17, 181


bl drawpawn

mov x16, 386
mov x17, 125


bl drawpawn

//Alfil
mov x16, 440 // Movimiento en Y
mov x17, 405 // Movimiento en X

bl drawbishop


mov x16, 440
mov x17, 235

bl drawbishop
//REINA

mov x16, 437
mov x17, 368
mov x15, XZR
mov x18, 1
mov x19, 20

bl drawqueen



//caballo
mov x16, 440
mov x17, 460

bl drawknight

//caballo
mov x16, 440
mov x17, 180

bl drawknight


//torre
 mov x18, 36 // Movimiento en Y
 mov x19, 509 // Movimiento en X
 bl drawtower

 mov x18, 36 // Movimiento en Y
 mov x19, 116 // Movimiento en X
 bl drawtower
 
 //PARAMETROS DE DRAWKING
//params de la cruz
mov x18, 25
mov x19, 342
//params del peon
mov x16, 440
mov x17, 292

bl drawking
 
 //PIEZAS BLANCAS
 
ldr x10, =BLANCO
mov x16, 107 // Movimiento en Y
mov x17, 517 // Movimiento en X


bl drawpawn

mov x16, 107
mov x17, 461


bl drawpawn

mov x16, 107
mov x17, 405


bl drawpawn

mov x16, 107
mov x17, 349


bl drawpawn

mov x16, 107
mov x17, 293


bl drawpawn

mov x16, 107
mov x17, 237


bl drawpawn

mov x16, 107
mov x17, 181


bl drawpawn

mov x16, 107
mov x17, 125


bl drawpawn

//Alfil
mov x16, 48 // Movimiento en Y
mov x17, 405 // Movimiento en X

bl drawbishop


mov x16, 48
mov x17, 235

bl drawbishop
//REINA

mov x16, 45
mov x17, 368
mov x15, XZR
mov x18, 1
mov x19, 20

bl drawqueen

//caballo
mov x16, 48
mov x17, 460

bl drawknight

//caballo
mov x16, 48
mov x17, 180

bl drawknight


//torre
 mov x18, 430 // Movimiento en Y
 mov x19, 509 // Movimiento en X
 bl drawtower

 mov x18, 430 // Movimiento en Y
 mov x19, 116 // Movimiento en X
 bl drawtower
 

 //PARAMETROS DE DRAWKING
//params de la cruz
mov x18, 417
mov x19, 342
//params del peon
mov x16, 48
mov x17, 292

bl drawking

//bandera noruega
mov x18, BTW_CHESS_BORDER_HEIGH
mov x19, 25

bl norwayflag

mov x18, BTW_CHESS_BORDER_HEIGH+CHESS_TABLE-30
mov x19, 25

bl russiaflag


loopmain: //INFINIT LOOP

bl read_user_input

b loopmain //INFINIT LOOP

read_user_input:

sub sp, sp, 16
stur lr, [sp]
stur x24, [sp, 8]

mov x24, GPIO_BASE
ldr w24, [x24, GPIO_GPLEV0]

bl input_space //CAMBIA COLOR DEL FONDO

ldur x24, [sp, 8]
ldur lr, [sp]
add sp, sp, 16
br lr

drawknight:
sub sp, sp, 8
stur lr, [sp]

bl elipse

mov x15, XZR
add x16, x16, 2
add x17, x17, 14
mov x18, 1
mov x19, 25

bl triangulorectangulo1

add x16, x16, 10
sub x17, x17, 9
mov x18, 1
mov x19, 10

bl trapeciopiso


ldur lr, [sp]
add sp, sp, 8
br lr

drawpawn:
sub sp, sp, 16
stur lr, [sp]
stur x19, [sp, 8]
// PEONES (TRAPECIO CON CIRCULO ARRIBA)
//CIRCULO
mov x9, SQUARERADIUS
bl circle

//TRAPECIO
mov x15, RADIUS
mov x18, 6
mov x19, 15
bl trapeciopiso

ldur x19, [sp, 8]
ldur lr, [sp]
add sp, sp, 16
br lr


drawbishop:
sub sp, sp, 8
stur lr, [sp]

//CIRCULO
mov x9, SQUARERADIUS
bl circle


//TRAPECIO BASE DEL BISHOP
mov x15, RADIUS
mov x18, 6 //lado de arriba del trapeciopiso
mov x19, 15 //altura del trapeciopiso

bl trapeciopiso

//TRAPECIO ARRIBA DEL BISHOP
mov x15, RADIUS*2
sub x15, XZR, x15
mov x18, 1 //lado de arriba del trapeciopiso
mov x19, 8 //altura del trapeciopiso
bl trapeciopiso



ldur lr, [sp]
add sp, sp, 8

br lr

drawtower:
 sub sp, sp, 24
 stur lr, [sp]
 
 //Tallo de la torre
 
 mov x16, 16
 mov x17, 24
 bl rectangle


 //Tapa de arriba de la torre
 stur x19, [sp, 8]
 stur x18, [sp, 16]
 //Acomodo las posiciones respecto al tallo
 sub x18, x18, 4
 sub x19, x19, 4
 mov x16, 24
 bl trapeciotecho

 ldur x19, [sp, 8]
 ldur x18, [sp, 16]

 //Tapa rectangular de arriba

 stur x19, [sp, 8]
 stur x18, [sp, 16]
 //Acomodo las posiciones respecto al tallo
 sub x18, x18, 6
 sub x19, x19, 4
 mov x16, 24
 mov x17, 3
 bl rectangle

 ldur x19, [sp, 8]
 ldur x18, [sp, 16]

 ////Tapa de abajo de la torre
 stur x19, [sp, 8]
 stur x18, [sp, 16]
 //Acomodo las posiciones respecto al tallo
 add x18, x18, 20
 sub x19, x19, 2
 mov x16, 20
 mov x17, 6
 bl rectangle

 ldur x19, [sp, 8]
 ldur x18, [sp, 16]
 


 ldur lr, [sp]
 add sp, sp, 24
 br lr

drawking:
sub sp, sp, 24
stur lr, [sp]
stur x19, [sp, 8]
stur x18, [sp, 16]

bl drawpawn
ldur x19, [sp, 8]
ldur x18, [sp, 16]

bl drawcross


ldur lr, [sp]

add sp, sp, 24
br lr

drawcross:
sub sp, sp, 8
stur lr, [sp]
//Acomodar rectangulo para la cruz

/*
Reinicio el x0
*/
mov x0, x20
/*
Acomodo en donde quiero para armar la cruz
Parámetros x18(alto), x19(ancho)
*/

mov x12, SCREEN_WIDTH
mul x13, x18, x12
add x13, x13, x19
lsl x13,x13,2
add x0, x0, x13
 
/*param:
x0 dirección de arriba a la Izquierda del rectangulo */

mov x12, 4 //alto
width_again1:
mov x13, 12 //ancho
horizontal_cross_paint:
stur w10, [x0]
add x0, x0, 4
sub x13, x13, 1
cbnz x13, horizontal_cross_paint
sub x12, x12, 1
cbz x12, done_horizontal_rect
add x0, x0, (SCREEN_WIDTH-12)*4
b width_again1
done_horizontal_rect:

/*acomodo con respecto al x0 final, para armar la cruz, me fijo desde la posición anterior
que me deja el rectangulo horizontal*/

mov x6, 2 // height/2
mov x7, 6// width/2
mov x8, SCREEN_WIDTH
mul x9, x8, x6// SCREEN_WIDTH*height/2
mul x15, x8, x7// SCREEN_WIDTH*width/2
sub x6, XZR, x6
sub x7, x6, x7
sub x9, x7, x9
sub x15, x9, x15
lsl x15,x15,2
add x0, x0, x15

/*param:
x0 dirección de arriba ala Izquierda del rectangulo */
mov x12, 12 //alto
width_again2:
mov x13, 4 //ancho
vertical_cross_painting:
stur w10, [x0]
add x0, x0, 4
sub x13, x13, 1
cbnz x13, vertical_cross_painting
sub x12, x12, 1
cbz x12, done_vertical_rect
add x0, x0, (SCREEN_WIDTH-4)*4
b width_again2
done_vertical_rect:

ldur lr, [sp]
add sp, sp, 8
br lr

//FUNCION DEL CIRCULO
circle:
sub sp, sp, 8
stur lr, [sp]

mov x0, x20 //reinicio x0 con la primer direccion de memoria


mov x21, SCREEN_HEIGHT
loopcircle1:

mov x22, SCREEN_WIDTH

loopcircle2:
 sub x4, x21, x16
mul x4, x4, x4
sub x5, x22, x17
mul x5, x5, x5
add x4, x5, x4
sub x22, x22, 1
subs XZR, x4, x9
B.LE paintcircle
add x0, x0, 4
back: cbnz x22, loopcircle2
sub x21, x21, 1
cbz x21, donecircle
b loopcircle1

paintcircle: stur w10, [x0]
add x0, x0, 4
b back

donecircle:
ldur lr, [sp]
add sp, sp, 8
br lr

//TRAPECIO MANEJABLE DESDE LA BASE
trapeciotecho:
sub sp, sp, 8
stur lr, [sp]
//Acomodar el trapeciotecho

/*
Reinicio el x0
*/
mov x0, x20
/*
Acomodo en donde quiero para armar el rectangulo
Parámetros x18(alto), x19(ancho) en pantalla
*/

mov x12, SCREEN_WIDTH
mul x13, x18, x12
add x13, x13, x19
lsl x13,x13,2
add x0, x0, x13

//Armo el trapecio
//Recibo parametros del ancho del techo x16
//El trapecio que voy a realizar va a ser de altura 6, lo unico que cambia es el ancho del techo del trapecio
lsl x12, x12, 2
mov x21, 6
anchotraptecho:
mov x22, x16
pintartraptecho:
stur w10, [x0]
add x0, x0, 4
sub x22,x22, 1
cbnz x22, pintartraptecho
lsl x8, x16, 2
sub x13, x12, x8
add x13, x13, 4
add x0, x0, x13
sub x21, x21, 1
cbz x21, donetraptecho
sub x16, x16, 2 // Le resto 2 para la proxima iteracion y que la linea de abajo sea un poco mas chica, asi da el efecto del trapecio
b anchotraptecho

donetraptecho:

ldur lr, [sp]
add sp, sp, 8
br lr


//TRAPECIO MANEJABLE DESDE LA BASE

trapeciopiso:

sub sp, sp, 8
stur lr, [sp]
mov x0, x20 //reinicio x0 con la direccion base

//acomodo x0 al lugar de la memoria que yo quiero

mov x21, SCREEN_HEIGHT
sub x21, x21, x16
add x21, x21, x15
add x2, XZR, XZR
mov x22, SCREEN_WIDTH
sub x22, x22, x17
lsr x8, x18, 1
sub x22, x22, x8
add x1, x2, 4
mul x22, x22, x1

trap: 
add x0, x0, SCREEN_WIDTH*4 //sumo linea tras linea hasta llegar a la que quiero
sub x21, x21, 1 //resto al contador de las lineas
cbnz x21, trap //si no estoy en la fila que quiero, continuo
add x0, x0, x22 //cuando llegue a la fila q quiera, coloco x0 justo abajo del circulo

//PINTAR EL TRAPECIO
add x21, x2, x18 //el lado de arriba del trapeciopiso
add x22, XZR, XZR
add x23, x2, x19 //alto del trapeciopiso
mul x3, x21, x1
painttrap: stur w10, [x0]
add x0, x0, 4
sub x21, x21, 1
cbnz x21, painttrap 
add x0, x0, SCREEN_WIDTH*4
sub x0, x0, x3
sub x0, x0, 4
add x22, x22, 2
add x21, x22, x18
mul x3, x21, x1
sub x23, x23, 1
cbnz x23, painttrap

ldur lr, [sp]
add sp, sp, 8
ret


//FUNCION ELIPSE

elipse:
sub sp, sp, 8
stur lr, [sp]
mov x0, x20 //reinicio x0 con la direccion base

mov x21, SCREEN_HEIGHT
loopelipse1:

mov x22, SCREEN_WIDTH

loopelipse2:
 sub x4, x21, x16
mul x4, x4, x4
lsr x4, x4, 1
sub x5, x22, x17
mul x5, x5, x5
lsr x5, x5, 3
add x4, x5, x4
sub x22, x22, 1
mov x6, RADIUS*3
subs XZR, x4, x6
B.LE paintelipse
add x0, x0, 4
backelipse:
cbnz x22, loopelipse2
sub x21, x21, 1
cbz x21, doneelipse
b loopelipse1

paintelipse: stur w10, [x0]
add x0, x0, 4
b backelipse

doneelipse:
ldur lr, [sp]
add sp, sp, 8
ret


rectangle:
sub sp, sp, 8
stur lr, [sp]

mov x0, x20 // Reinicio el x0

//Acomodo el x0 a donde quiera colocar el rectangulo
//Recibo en x18(ancho) y x19(alto) para el x0
mov x12, SCREEN_WIDTH
mul x13, x18, x12
add x13, x13, x19
lsl x13,x13,2
add x0, x0, x13

//Dibujo el rectangulo
//Recibo en x16(ancho) y x17(alto) del rectangulo

mov x7, x17
reset_width_rect:
mov x6, x16
paintrect:
stur w10, [x0]
add x0, x0, 4
sub x6, x6, 1
cbnz x6, paintrect
sub x7, x7, 1
cbz x7, donerect
sub x9, x12, x16
lsl x9, x9, 2
add x0, x0, x9
b reset_width_rect

donerect:

ldur lr, [sp]
add sp, sp, 8
br lr


//TRIANGULO RECTANGULO

triangulorectangulo1:
sub sp, sp, 8
stur lr, [sp]
mov x0, x20 //reinicio x0 con la direccion base

//acomodo x0 al lugar de la memoria que yo quiero

mov x21, SCREEN_HEIGHT
sub x21, x21, x16
add x21, x21, x15
add x2, XZR, XZR
mov x22, SCREEN_WIDTH
sub x22, x22, x17
lsr x8, x18, 1
sub x22, x22, x8
add x1, x2, 4
mul x22, x22, x1 
triangulo:
add x0, x0, SCREEN_WIDTH*4 //sumo linea tras linea hasta llegar a la que quiero
sub x21, x21, 1 //resto al contador de las lineas
cbnz x21, triangulo //si no estoy en la fila que quiero, continuo
add x0, x0, x22 //cuando llegue a la fila q quiera, coloco x0 justo abajo del circulo

//PINTAR EL TRAPECIO
add x21, x2, x18 //el lado de arriba del trapeciopiso
add x22, XZR, XZR
add x23, x2, x19 //alto del trapeciopiso
mul x3, x21, x1
painttriangulo:
stur w10, [x0]
add x0, x0, 4
sub x21, x21, 1
cbnz x21, painttriangulo 
add x0, x0, SCREEN_WIDTH*4
sub x0, x0, x3
add x22, x22, 1
add x21, x22, x18
mul x3, x21, x1
sub x23, x23, 1
cbnz x23, painttriangulo

ldur lr, [sp]
add sp, sp, 8
ret


triangulorectangulo2:

sub sp, sp, 8
stur lr, [sp]
mov x0, x20 //reinicio x0 con la direccion base

//acomodo x0 al lugar de la memoria que yo quiero

mov x21, SCREEN_HEIGHT
sub x21, x21, x16
add x21, x21, x15
add x2, XZR, XZR
mov x22, SCREEN_WIDTH
sub x22, x22, x17
lsr x8, x18, 1
sub x22, x22, x8
add x1, x2, 4
mul x22, x22, x1

triangulo2: 
add x0, x0, SCREEN_WIDTH*4 //sumo linea tras linea hasta llegar a la que quiero
sub x21, x21, 1 //resto al contador de las lineas
cbnz x21, triangulo2 //si no estoy en la fila que quiero, continuo
add x0, x0, x22 //cuando llegue a la fila q quiera, coloco x0 justo abajo del circulo

//PINTAR EL TRAPECIO
add x21, x2, x18 //el lado de arriba del trapeciopiso
add x22, XZR, XZR
add x23, x2, x19 //alto del trapeciopiso
mul x3, x21, x1
painttriangulo2:
stur w10, [x0]
add x0, x0, 4
sub x21, x21, 1
cbnz x21, painttriangulo2 
add x0, x0, SCREEN_WIDTH*4
sub x0, x0, x3
sub x0, x0, 4
add x22, x22, 1
add x21, x22, x18
mul x3, x21, x1
sub x23, x23, 1
cbnz x23, painttriangulo2

ldur lr, [sp]
add sp, sp, 8
ret

//REINA
drawqueen:
sub sp, sp, 8
stur lr, [sp]

bl triangulorectangulo1

sub x17, x17, 40
bl triangulorectangulo2

sub x16, x16, 5
add x17, x17, 20
mov x15, XZR
mov x18, 1
sub x19, x19, 5
bl trapeciopiso


add x16, x16, 8
sub x17, x17, 18
mov x9, 30
bl circle

add x17, x17, 36
mov x9, 30
bl circle

sub x16, x16, 5
sub x17, x17, 18
mov x9, 30
bl circle

ldur lr, [sp]
add sp, sp, 8
br lr


norwayflag:

//Recibo parametros x18(alto), x19(ancho), x10 color

sub sp, sp, 32

stur lr, [sp]

stur x18, [sp,8]

stur x19, [sp,16]

stur x10, [sp, 24]


mov x16, 40

mov x17, 30


ldr x10, =NORROJO


bl rectangle


ldur x10, [sp, 24]


stur x18, [sp, 8]

stur x19, [sp, 16]

stur x10, [sp, 24]


mov x18, 27

mov x19, 25

mov x16, 40

mov x17, 9


ldr x10, =NORBLANCO


bl rectangle //Rectangulo hor blanco


mov x18, BTW_CHESS_BORDER_HEIGH

mov x19, 37

mov x16, 9

mov x17, 30

bl rectangle //Rectangulo ver blanco


ldur x10, [sp, 24]

ldur x18, [sp,16]

ldur x19, [sp, 8]


stur x10, [sp, 24]

stur x18, [sp, 8]

stur x19, [sp, 16]


mov x18, 29

mov x19, 25

mov x16, 40

mov x17, 5


ldr x10, =NORAZUL


bl rectangle //Rectangulo hor azul


mov x18, BTW_CHESS_BORDER_HEIGH

mov x19, 39

mov x16, 5

mov x17, 30

bl rectangle //Rectangulo ver azul


ldur x10, [sp, 24]


ldur x18, [sp,16]

ldur x19, [sp, 8]

ldur lr, [sp]

add sp, sp, 32


br lr


russiaflag:

//Recibo parametros x18(alto), x19(ancho), x10 color

sub sp, sp, 32

stur lr, [sp]

stur x18, [sp,8]

stur x19, [sp,16]

stur x10, [sp, 24]


mov x16, 40

mov x17, 30


ldr x10, =RUSROJO


bl rectangle


ldur x10, [sp, 24]


stur x18, [sp, 8]

stur x19, [sp, 16]

stur x10, [sp, 24]


mov x18, BTW_CHESS_BORDER_HEIGH+CHESS_TABLE-30

mov x19, 25

mov x16, 40

mov x17, 10


ldr x10, =RUSBLANCO


bl rectangle //Rectangulo hor blanco


ldur x10, [sp, 24]

ldur x18, [sp,16]

ldur x19, [sp, 8]


stur x10, [sp, 24]

stur x18, [sp, 8]

stur x19, [sp, 16]


mov x18, BTW_CHESS_BORDER_HEIGH+CHESS_TABLE-20

mov x19, 25

mov x16, 40

mov x17, 10


ldr x10, =RUSAZUL


bl rectangle //Rectangulo hor azul


ldur x10, [sp, 24]


ldur x18, [sp,16]

ldur x19, [sp, 8]

ldur lr, [sp]

add sp, sp, 32


br lr


// TECLA SPACE


input_space:
sub sp, sp, 24
stur lr, [sp]
stur x19, [sp, 8]
stur x10, [sp,16]

and x19, x24, GPIO_SPACE
cbz x19, notspace

ldr x10, =COLORCAMBIO

b resetboard


notspace:
ldur x10, [sp, 16]
ldur x19, [sp, 8]
ldur lr, [sp]
add sp, sp, 24
br lr


// Ejemplo de uso de gpios
mov x9, GPIO_BASE

// Atención: se utilizan registros w porque la documentación de broadcom
// indica que los registros que estamos leyendo y escribiendo son de 32 bits

// Setea gpios 0 - 9 como lectura
str wzr, [x9, GPIO_GPFSEL0]

// Lee el estado de los GPIO 0 - 31
ldr w10, [x9, GPIO_GPLEV0]

// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
// al inmediato se lo refiere como "máscara" en este caso:
// - Al hacer AND revela el estado del bit 2
// - Al hacer OR "setea" el bit 2 en 1
// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
and w11, w10, 0b00000010

// si w11 es 0 entonces el GPIO 1 estaba liberado
// de lo contrario será distinto de 0, (en este caso particular 2)
// significando que el GPIO 1 fue presionado

//---------------------------------------------------------------
