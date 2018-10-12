motor equ 0ffe6h
en_display equ 0ffe1h 
dados_display equ 0ffe0h
sw equ P3.4

org 0h

mov a,#00h				; zerando o motor....
mov dptr,#motor			;(evitar aquecimento
movx @dptr,a			; e ruído!!)


;configura o display
mov a,#08h				;ativa display mais a direita (D30)
mov dptr,#en_display	;envia endereço de habilitação do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 

mov r0,#0				;para apontar o primeiro dado da tabela

inicio:
;tabela
mov a,r0
mov dptr, #tabela
movc a,@a+dptr

;envia dados para o display
mov dptr,#dados_display	;envia o dados para display para dptr 
movx @dptr,a			;envia 3fh para display

loop:
jnb sw, loop
jb sw, $
inc r0

cjne r0, #00010000b, inicio
mov r0,#0
ljmp inicio
tabela:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h	

end
