TEMP EQU (65535 - 2000)
TEMP1S EQU (65535 - 20000)
TECLADO equ 0FFE3H
MOTOR equ 0FFE6H
TECLAAUX equ 11H
EN_DIPSLAY equ 0ffe1h 
DADOS_DISPLAY equ 0ffe0h
DISP0 EQU 30H
DISP1 EQU 31H
DISP2 EQU 32H
DISP3 EQU 33H

DISP0C EQU 34H
DISP1C EQU 35H
DISP2C EQU 36H
DISP3C EQU 37H

ORG 0h

INICIO:
    CLR A ; Limpando A
    MOV P1,A
    ; Zerando o Motor.... (Evitar aquecimento e ruído!!) MOV A,#00H
    MOV DPTR,#MOTOR
    MOVX @DPTR,A
    MOV R0, #0
    MOV R1, #0
    MOV R2, #0
    MOV R3, #0
    MOV R6, #0
    CALL DISPLAY
;    LJMP TECLADO_READ
    ;AJMP LOOP

;Inicia a varredura do teclado
TECLADO_READ:
    MOV A,#40H
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    MOVX A,@DPTR
    CJNE A,#01H,TRT2; Pressionou tecla "1"?
    MOV R6,#01H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TRT2: CJNE A,#02H,TR3 ; Pressionou tecla "2"?
    MOV R6,#02H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR3: CJNE A,#04H,TR5 ; Pressionou tecla "3"?
    MOV R6,#03H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR5: CJNE A,#10H,TR6 ; Pressionou tecla "4"?
    MOV R6,#04H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR6: CJNE A,#20H,TR7 ; Pressionou tecla "5"?
    MOV R6,#05H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR7: CJNE A,#40H,TR9_B ; Pressionou tecla "6"?
    MOV R6,#06H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    ;TR8: CJNE A,#02H,TR9_A ; Pressionou tecla "B"?
    ;MOV P1,#0BH
    ;LJMP TECLADO_SAIR

    TR9_A: CJNE A,#06H,TR9_B
    MOV A,#TECLAAUX
    LJMP TECLADO_SAIR

    TR9_B: MOV A,#80H ;Ativar a linha 7
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    MOVX A,@DPTR
    CJNE A,#01H,TR10 ; Pressionou tecla "7"?
    MOV R6,#07H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR10: CJNE A,#02H, TR11 ; Pressionou tecla "8"?
    MOV R6,#08H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR11: CJNE A,#04H, TR14 ; Pressionou tecla "9"?
    MOV R6,#09H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR14: CJNE A,#20H, TR17 ; Pressionou tecla "0"?
    MOV R6,#00H
    CALL ATUALIZA_DISPLAY
    MOV A, R6
    MOV R0, A
    LJMP TECLADO_SAIR

    TR17: LJMP TECLADO_SAIR
;    CJNE R1, #00000000, TECLADO_READ
    ; aqui devo fazer o display apareceer o numero
    RET
;    LJMP TECLADO_READ

    ;Esta rotina evita repetição de teclas
TECLADO_SAIR:
    PUSH ACC
    MOV A,#80H
    MOV DPTR,#TECLADO
    MOVX @DPTR,A

    TECLADO_REPEAT_1:
    MOVX A,@DPTR
    CJNE A,#00H,TECLADO_REPEAT_1

    TECLADO_SAIR_2:
    MOV A,#40H
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    TECLADO_REPEAT_2:
    MOVX A,@DPTR
    CJNE A,#00H,TECLADO_REPEAT_2
    POP ACC
    
;    CALL DECREMENTA
    
    RET
    
;DECREMENTA:
;	DJNZ R0, DECREMENTA
;	CALL TEMPO2
;	RET
    
ATUALIZA_DISPLAY:
    MOV A, R2
    MOV R3, A
    MOV A, R1
    MOV R2, A
    MOV A, R0
    MOV R1, A
    
    RET
    
display:
clr a
mov a,#08h				;ativa display das unidade (D30)
mov dptr,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov a,R0
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#DADOS_DISPLAY	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a
CALL TEMPO
mov a,#04h				;ativa display das dezenas (D20)
mov dptr,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 04h, habilitando o display D20 
mov a,R1
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#DADOS_DISPLAY	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a
CALL TEMPO
clr a
mov a,#02h				;ativa display das unidade (D30)
mov dptr,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 08h, habilitando o display D30 
mov a,R2
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#DADOS_DISPLAY	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a
call TEMPO
mov a,#01h				;ativa display das dezenas (D20)
mov dptr,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
movx @dptr,a			;envia 04h, habilitando o display D20 
mov a,R3
mov dptr, #tabela
movc a,@a+dptr ;envia dados para o display
mov dptr,#DADOS_DISPLAY	;envia o dados para display para dptr 
movx @dptr,a			;envia o valor do acumulador para display
clr a

CALL TEMPO
CALL TECLADO_READ

MOV A,#80H ;Ativar a linha 7
MOV DPTR,#TECLADO
MOVX @DPTR,A
MOVX A,@DPTR
CJNE A,#40H, display ; Pressionou tecla "0"?
CALL TECLADO_SAIR
MOV DISP0, R0
MOV DISP1, R1
MOV DISP2, R2
MOV DISP3, R3




jmp display

TEMPO:		;rotina de tempo(20x50.000)
    ;MOV R0,#2

    LOOP:
    MOV TMOD,#00000001B
    MOV TL0,#LOW(TEMP)
    MOV TH0,#HIGH(TEMP)
    SETB TR0
    JNB TF0,$
    CLR TR0
    CLR TF0
    ;DJNZ R0,LOOP
    RET
    
TEMPO2:		;rotina de tempo(20x50.000)
    ;MOV R0,#2

    ;LOOP:
    MOV TMOD,#00000001B
    MOV TL0,#LOW(TEMP1S)
    MOV TH0,#HIGH(TEMP1S)
    SETB TR0
    JNB TF0,$
    CLR TR0
    CLR TF0
    ;DJNZ R0,LOOP
    RET

tabela:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h

END
