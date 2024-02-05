Cagliero, Nicolás
Llugdar, Mauricio

Recomendaciones para instalar qemu y lo necesario:

Instalación
0-TENER ACTUALIZADOS LOS REPOSITORIOS
$ sudo apt update
1- SETTING UP AARCH64 TOOLCHAIN
$ sudo apt install gcc-aarch64-linux-gnu
2- SETTING UP QEMU ARM (incluye aarch64)
$ sudo apt install qemu-system-arm
3- FETCH AND BUILD AARCH64 GDB
$ sudo apt install gdb-multiarch
4- CONFIGURAR GDB PARA QUE HAGA LAS COSAS MÁS AMIGABLES
$ wget -P ~ git.io/.gdbinit

Como ejecutar:
Se necesitan 2 terminales abiertas en el ejercicio 1 o 2, según cual se quiera ejecutar.
En la primera terminal ejecutamos "make runQEMU" y en la segunda "make runGPIOM" para comunicarnos con el ajedrez, en la segunda terminal vamos a escribir los comandos.

Organización del proyecto:
Ejercicio 1: se muestra en pantalla un tablero de ajedrez y al apretar la tecla 'espacio' cambiamos el color del fondo a azul.

Ejercicio 2: mostramos en pantalla una clase de teoría de ajedrez con Magnus Carlsen y Garry Kasparov. Al apretar 'w' se mostrará "THE PONZIANI OPENING", 'a' muestra "THE SPANISH GAME", 's' muestra "JAQUEMATE PASTOR", 'd' muestra una línea de "THE LONDON SYSTEM"(Jugada más completa) y 'espacio' reinicia el tablero.


