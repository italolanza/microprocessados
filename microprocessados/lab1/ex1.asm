; Laboratorio 1 - Sistemas Microprocessados
; 3Q2018 - 27/09/2018 - Grupo 5
; Autores: Italo Milhomem de Abreu Lanza  RA:11039414 
;          Joao Pedro Poloni Ponce        RA:11116513         

;chaves
sw1 equ p1.4
sw2 equ p1.5
sw3 equ p1.6
sw4 equ p1.7
;leds
led1 equ p1.0
led2 equ p1.1
led3 equ p1.2
led4 equ p1.3


org 0000h
ljmp main

main:   mov a,#00h
        mov dptr,#0ffe6h
        movx @dptr,a
        
        mov sw1,#1 ; setas a portas onde estao conectados as chaves como entradas
        setb sw2
        setb sw3
        setb sw4
        
        setb led1 ; zera a porta dos leds
        setb led2
        setb led3
        setb led4
        
              
led1_p: jnb sw1,led1_n
     	clr led1
     	ljmp led2_p
led1_n: setb led1
        ljmp led2_p
led2_p: jnb sw2,led2_n
        clr led2
	ljmp led3_p
led2_n: setb led2
        ljmp led3_p
led3_p: jnb sw3,led3_n
     	clr led3
     	ljmp led4_p
led3_n: setb led3
        ljmp led4_p
led4_p: jnb sw4,led4_n
        clr led4
	ljmp led1_p
led4_n: setb led4
        ljmp led1_p
      
end