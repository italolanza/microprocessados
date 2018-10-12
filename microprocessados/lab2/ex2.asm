teclado equ 0ffe3h
motor equ 0ffe6h 
en_display equ 0ffe1h 
dados_display equ 0ffe0h
org 0h 
clr a 
mov p1,a ;apagando leds em p1 
mov a,#00h ;zerando o motor.... 
mov dptr,#motor ;(evitar aquecimento movx @dptr,a ;e ruído!!)

;Mostra 9
mov a,#08h				;ativa display mais a direita (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov r0,#6				;para apontar o primeiro dado da tabela
;tabela
mov a,r0
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a
;Mostra 5
mov a,#04h				;ativa display mais a direita (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov r1,#5				;para apontar o primeiro dado da tabela
;tabela
mov a,r1
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a
 
inicio: 
;############## teclado ############### 
mov a,#40h ;ativa linha 7Q do IC4 (ver fig. anterior) 
mov dptr,#teclado ;envia o endereço do teclado para dptr 
movx @dptr,a ;envia 40h para teclado 
movx a,@dptr ;o que está no endereço do teclado vai para acc 
cjne a,#08h,prox ;pressionou tecla "+"? 
cjne r0, #00010001b, incremente_unidade
mov r0,#0
inc r1
acall display
jmp sair_positivo


incremente_unidade:
inc r0
acall display

sair_positivo:
acall teclado_sair

prox: 
cjne a,#80h,sair ; pressionou tecla "-"? 
cjne r0, #00000000b, decrementa_unidade
mov r0,#9
dec r1
acall display
jmp sair

decrementa_unidade:
dec r0
acall display

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
mov a,#08h				;ativa display mais a direita (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov a,r0
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a			;envia 3fh para display
mov a,#04h				;ativa display mais a direita (D30)
mov dptr,#en_display	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov a,r1
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a			;envia 3fh para display
ret

tabela:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h
 
end