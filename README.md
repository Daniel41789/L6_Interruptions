# L6_Interruptions
This is lab practice 6 of Microcontrollers 

## Diagrama electrónico
El siguiente diagrama muestra las conexiones hechas en el hardware

## Proceso de compilación
En primera instancia necesitamos conectar la placa a nuestro ordenador para verificar que el sistema operativo la reconoce. Para esto, se hizo uso del software STM32CubeProgrammer para hacer el reconocimiento de la placa. Una vez hecho esto, iremos a nuestro Visual Studio Code o directamente desde la terminal de Ubuntu (wsl) y ejecutamos el siguiente comando:

```
make
```
Como los comandos para obtener el archivo .bin se encuentran en el makefile lo único que se necesita es el comando anterior.
Una vez hecho este procedimiento, haciendo uso del STM32CubeProgrammer simplemente conectamos el grabador con la blue pill y damos click en la parte superior derecha en Connect y buscamos el apartado de Erasing & Programming, buscamos nuestro archivo prog.bin y damos clic en Start Programming para realizar el grabado del programa en nuestra placa.