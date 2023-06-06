# L6_Interruptions
## Funcionamiento
El software implementa un contador binario de 10 bits con 10 leds, al princio, como valor predeterminado la velocidad del aumento de la cuenta es cada segundo, después, al presionar uno de los botones, el modo de la cuenta cambiará, pasando de ascendente a descendente y viceversa; Por otro lado, al presionar el otro botón, la velocidad del contador aumentará x2, x4 y x8 y posteriormente, cuando la velocidad esté en x8 y se presione nuevamente el botón, la velocidad regresará a x1 que sería la velocidad predeterminada.

## Diagrama electrónico
El siguiente diagrama muestra las conexiones hechas en el hardware utilizado para este proyecto:
![logo](https://i.ibb.co/9GmXYH5/STM32-Blue-Pill-Pr-ctica-1.png)

## Configuración de las interrupciones externas
En el main primero configuramos el mapeo de las interrupciones externas:
```
    ldr r0, =AFIO_BASE
    eor r1, r1
    str r1, [r0, AFIO_EXTICR2_OFFSET]
```
Después configuramos el disparador de la siguiente forma:

```
   ldr r0, =EXTI_BASE
    eor r1, r1                              
    str r1, [r0, EXTI_FTST_OFFSET]          
    ldr r1, =(0x3 << 6)                             
    str r1, [r0, EXTI_RTST_OFFSET]          
    str r1, [r0, EXTI_IMR_OFFSET]           
    ldr r0, =NVIC_BASE
    ldr r1, =(0x1 << 23)                    
    str r1, [r0, NVIC_ISER0_OFFSET]
```
Realizamos la limpieza del registro y desactivamos el flanco de bajada, para posteriormente habilitar el flanco de subida en PR 6 y 7 dado que se hace uso de las EXTI6 y EXTI7 para este caso. Y finalmente habilitamos EXTI Line [9:5]. Aquí hacemos uso de ISER0 porque en la documentación de stm32 que es nuestra placa, es necesario usar ISER0 para hacer uso de las EXTI 6 y 7.
## Configuración del reloj del sistema
Para configurar el reloj del sistema es necesario tener el siguiente código: 

```
Ini_SysTick:
    ldr r0 , =SYSTICK_BASE
    mov r1, #0
    str r1, [r0, #STK_CTRL_OFFSET]
    ldr r2, =7999
    str r2, [r0, #STK_LOAD_OFFSET] 
    mov r1, #0
    str r1, [r0, #STK_VAL_OFFSET]
    ldr r2 , =SCB_BASE
    add r2 , r2 , #SCB_SHPR3_OFFSET
    mov r3, #0x20
    strb r3, [r2, #11]
    ldr r1, [ r0 , #STK_CTRL_OFFSET]
    orr r1, r1, #7
    str r1, [r0, #STK_CTRL_OFFSET]
    bx lr

.global SysTick_Handler
SysTick_Handler:
    sub r10, r10, #1
    bx lr
.size   SysTick_Handler, .-SysTick_Handler
```
Aquí notamos que pasamos el valor de 7999 porque nuestro microcontrolador trabaja a 8mhz, por lo que ajustamos el microcontrolador a este valor para generar un retraso de 1 milisegundo.

## Proceso de compilación
En primera instancia necesitamos conectar la placa a nuestro ordenador para verificar que el sistema operativo la reconoce. Para esto, se hizo uso del software STM32CubeProgrammer para hacer el reconocimiento de la placa. Una vez hecho esto, iremos a nuestro Visual Studio Code o directamente desde la terminal de Ubuntu (wsl) y ejecutamos el siguiente comando:

```
make
```
Como los comandos para obtener el archivo .bin se encuentran en el makefile lo único que se necesita es el comando anterior.
Una vez hecho este procedimiento, haciendo uso del STM32CubeProgrammer simplemente conectamos el grabador con la blue pill y damos click en la parte superior derecha en Connect y buscamos el apartado de Erasing & Programming, buscamos nuestro archivo prog.bin y damos clic en Start Programming para realizar el grabado del programa en nuestra placa.