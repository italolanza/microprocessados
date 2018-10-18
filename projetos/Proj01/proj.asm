teclado equ 0ffe3h
motor equ 0ffe6h 
en_display equ 0ffe1h 
dados_display equ 0ffe0h

org 0000h

inicio: 
;############## teclado ############### 
mov a,#40h ;ativa linha 7Q do IC4 (ver fig. anterior) 
mov dptr,#teclado ;envia o endereço do teclado para dptr 
movx @dptr,a ;envia 40h para teclado 
movx a,@dptr ;o que está no endereço do teclado vai para acc 
cjne a,#08h,prox ;pressionou tecla "+"? 
cpl p1.0

prox: 
cjne a,#80h,sair ; pressionou tecla "-"? 
cpl p1.1

sair: 
acall teclado_sair 
sjmp inicio

teclado_sair:
push acc
mov a, #40h
mov dptr, #teclado
movx @dptr, a

teclado_repeat_2:
movx a, @dptr
cjne a, #00h, teclado_repeat_2

pop acc
ret

end
