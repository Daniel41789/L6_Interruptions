# L6_Interruptions
## Funcionamiento
El software implementa un contador binario de 10 bits con 10 leds, al princio, como valor predeterminado la velocidad del aumento de la cuenta es cada segundo, después, al presionar uno de los botones, el modo de la cuenta cambiará, pasando de ascendente a descendente y viceversa; Por otro lado, al presionar el otro botón, la velocidad del contador aumentará x2, x4 y x8 y posteriormente, cuando la velocidad esté en x8 y se presione nuevamente el botón, la velocidad regresará a x1 que sería la velocidad predeterminada.

## Diagrama electrónico
El siguiente diagrama muestra las conexiones hechas en el hardware utilizado para este proyecto:
![logo](https://i.ibb.co/PFN8FDX/Lab6.png)

## Proceso de compilación
En primera instancia necesitamos conectar la placa a nuestro ordenador para verificar que el sistema operativo la reconoce. Para esto, se hizo uso del software STM32CubeProgrammer para hacer el reconocimiento de la placa. Una vez hecho esto, iremos a nuestro Visual Studio Code o directamente desde la terminal de Ubuntu (wsl) y ejecutamos el siguiente comando:

```
make
```
Como los comandos para obtener el archivo .bin se encuentran en el makefile lo único que se necesita es el comando anterior.
Una vez hecho este procedimiento, haciendo uso del STM32CubeProgrammer simplemente conectamos el grabador con la blue pill y damos click en la parte superior derecha en Connect y buscamos el apartado de Erasing & Programming, buscamos nuestro archivo prog.bin y damos clic en Start Programming para realizar el grabado del programa en nuestra placa.