; Laboratorio 1 - Sistemas Microprocessados
; 3Q2018 - 27/09/2018 - Grupo 5
; Autores: Italo Milhomem de Abreu Lanza  RA:11039414 
;          Joao Pedro Poloni Ponce        RA:11116513         

;chave
sw equ p1.7

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
   	mov a,#10000000b
 	;setb sw
 	mov p1,a 

loop:   jnb sw, loop 
 	jb sw, $
 	
 	
incrementa: inc a
            mov p1,a
            
comparacao: cjne a,#10000000b,loop
            mov a,#10001111b
            ljmp loop
end