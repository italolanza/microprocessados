; Laboratorio 2 - Sistemas Microprocessados
; 3Q2018 - 11/10/2018 - Grupo 5
; Autores: Italo Milhomem de Abreu Lanza   RA:11039414 
;          Joao Pedro Poloni Ponce         RA:11116513         
;          Felipe Carlos Miguel Tignonsini RA: 11054613
;          Nicolas de Oliveira Mizukami    RA: 11075314

teclado equ 0ffe3h
motor equ 0ffe6h 
en_display equ 0ffe1h 
dados_display equ 0ffe0h

org 0h

clr a 
mov p1,a ;apagando leds em p1 
mov a,#00h ;zerando o motor.... 
mov dptr,#motor ;(evitar aquecimento movx @dptr,a ;e ruído!!)

;Mostra 6
mov a,#08h				;ativa display das unidades (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov r0,#6				;para apontar o 6 dado da tabela
;tabela
mov a,r0
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a

clr a
;Mostra 5
mov a,#04h				;ativa display das dezenas (D20)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D20 
mov r1,#5				;para apontar o 5 dado da tabela
;tabela
mov a,r1
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a
clr a

inicio: 
;############## teclado ############### 
mov a,#40h ;ativa linha 7Q do IC4 
mov dptr,#teclado ;envia o endereço do teclado para dptr 
movx @dptr,a ;envia 40h para teclado 
movx a,@dptr ;o que está no endereço do teclado vai para acc 
cjne a,#08h,prox ;pressionou tecla "+"? 
cjne r0, #00001001b, incremente_unidade ; r0 = 9 ? sim: move 0 para r0 incrementa r1, não: incremente r0
mov r0,#0

cjne r1, #00001001b, incremente_dezena ; verifica se a dezena e 9
mov r0, #0 ; caso sim, zera o display
acall display ; chama rotina para escrever dados no display
jmp sair ; Finaliza o processo

incremente_dezena: ; Rotina para incrementar a dezena
inc r1
acall display ; chama rotina para escrever dados no display
jmp sair ; Finaliza o processo


incremente_unidade: ; Rotina para incrementar a unidade
inc r0
acall display ; chama rotina para escrever dados no display
ljmp sair ; Finaliza o processo

prox: 
cjne a,#80h,sair ; pressionou tecla "-"? 
cjne r0, #00000000b, decrementa_unidade ; verifica se a unidade e 0
mov r0,#9

cjne r1, #00000000b, decrementa_dezena ; verifica se a dezena e 0
mov r1, #9 ; caso sim, zera o display
acall display ; chama rotina para escrever dados no display
ljmp sair ; Finaliza o processo

decrementa_dezena: ; Rotina para decrementar a dezena
dec r1
acall display ; chama rotina para escrever dados no display
jmp sair ; Finaliza o processo

decrementa_unidade: ; Rotina para decrementar unidade
dec r0
acall display ; chama rotina para escrever dados no display

sair: 
acall teclado_sair
sjmp inicio 

;####################################### ;esta rotina evita repetição de teclas 
teclado_sair: 
push acc 
mov a,#40h 
mov dptr,#teclado 
movx @dptr,a 
teclado_repeat_2: 
movx a,@dptr 
cjne a,#00h,teclado_repeat_2;espera a tecla ser solta para que não ;gere varias ocorrencias da tecla 
pop acc 
ret

display:
clr a
mov a,#08h				;ativa display das unidade (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov a,r0
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a
mov a,#04h				;ativa display das dezenas (D20)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 04h, habilitando o display D20 
mov a,r1
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a
ret

tabela:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h
 
end