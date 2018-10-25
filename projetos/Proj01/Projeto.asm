TEMP EQU (65535 - 2000)
TEMP1S EQU (65535 - 50000)
TECLADO equ 0FFE3H
MOTOR equ 0FFE6H
TECLAAUX equ 11H
EN_DIPSLAY equ 0ffe1h 
DADOS_DISPLAY equ 0ffe0h
DISP0 EQU 30H
DISP1 EQU 40H
DISP2 EQU 50H
DISP3 EQU 60H

;DISP0C EQU 34H
;DISP1C EQU 35H
;DISP2C EQU 36H
;DISP3C EQU 37H

ORG 0h

;MOV DISP0, #10H
;MOV a, DISP0;
;CJNE a, DISP0, INICIO
;MOV DISP0, #20H

INICIO:
    CLR A ; Limpando A
    MOV P1,A
    ; Zerando o Motor.... (Evitar aquecimento e rui´do!!) MOV A,#00H
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

    TR9_B: 
    MOV A,#80H ;Ativar a linha 7
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

    ;Esta rotina evita repetic¸a~o de teclas
    
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
    
DISPLAY:
    CLR A
    MOV A,#08H				;ativa display das unidade (D30)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 08h, habilitando o display D30 
    MOV A,R0					; MOSTRA O VALOR DE R0
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO
    MOV A,#04H				;ativa display das dezenas (D20)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 04h, habilitando o display D20 
    MOV A,R1
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO
    CLR A
    MOV A,#02H				;ativa display das unidade (D30)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 08h, habilitando o display D30 
    MOV A,R2
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    call TEMPO
    MOV A,#01H				;ativa display das dezenas (D20)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 04h, habilitando o display D20 
    MOV A,R3
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A

    CALL TEMPO
    CALL TECLADO_READ

    MOV A,#80H ;Ativar a linha 7
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    MOVX A,@DPTR
    CJNE A,#40H, DISPLAY ; Pressionou tecla "="?
    CALL TECLADO_SAIR
    CALL INCREMENTA



    JMP DISPLAY

INCREMENTA:
 
    MOV DISP0, R0			;; GRAVOU OS VALORES QUE ESTAVA EM R0 EM DISP0
    MOV DISP1, R1			;; GRAVOU OS VALORES QUE ESTAVA EM R1 EM DISP1
    MOV DISP2, R2			;; GRAVOU OS VALORES QUE ESTAVA EM R2 EM DISP2
    MOV DISP3, R3			;; GRAVOU OS VALORES QUE ESTAVA EM R3 EM DISP3

    MOV R0,#0				;; ZEROU OS REGISTRADORES
    MOV R1,#0				;; ZEROU OS REGISTRADORES
    MOV R2,#0				;; ZEROU OS REGISTRADORES
    MOV R3,#0				;; ZEROU OS REGISTRADORES

CONTAGEM:
CALL TEMPO2
    CLR A
    MOV A,#08H				;ativa display das unidade (D30)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 08h, habilitando o display D30 
    MOV A,R0
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO
    MOV A,#04H				;ativa display das dezenas (D20)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 04h, habilitando o display D20 
    MOV A,R1
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO
    CLR A
    MOV A,#02H				;ativa display das unidade (D30)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 08h, habilitando o display D30 
    MOV A,R2
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO
    MOV A,#01H				;ativa display das dezenas (D20)
    MOV DPTR,#EN_DIPSLAY	;envia endereco de habilitacao do display para o dptr
    MOVX @DPTR,A			;envia 04h, habilitando o display D20 
    MOV A,R3
    MOV DPTR, #TABELA
    MOVC A,@A+DPTR ;envia dados para o display
    MOV DPTR,#DADOS_DISPLAY	;envia o dados para display para dptr 
    MOVX @DPTR,A			;envia o valor do acumulador para display
    CLR A
    CALL TEMPO

    MOV A, R3
    CJNE A, DISP3, VERIFICA_9_UNIDADE
    
    MOV A, R2
    CJNE A, DISP2, VERIFICA_9_UNIDADE
    ;DEC R2
    
    MOV A, R1
    CJNE A, DISP1, VERIFICA_9_UNIDADE
    ;DEC R1
    
    MOV A, R0
    CJNE A, DISP0, VERIFICA_9_UNIDADE
    RET

VERIFICA_9_UNIDADE:
    CJNE R0, #9, INCREMENTA_UNIDADE
    MOV R0, #0
    JMP VERIFICA_9_DEZENA

INCREMENTA_UNIDADE:
    INC R0
    JMP CONTAGEM

VERIFICA_9_DEZENA:
    CJNE R1, #9, INCREMENTA_DEZENA
    MOV R1, #0
    JMP VERIFICA_9_CENTENA

INCREMENTA_DEZENA:
    INC R1
    JMP CONTAGEM

VERIFICA_9_CENTENA:
    CJNE R2, #9, INCREMENTA_CENTENA
    MOV R2, #0
    JMP VERIFICA_MILHAR

INCREMENTA_CENTENA:
    INC R2
    JMP CONTAGEM

VERIFICA_MILHAR:
    CJNE R3, #DISP3, INCREMENTA_MILHAR
    JMP CONTAGEM

INCREMENTA_MILHAR:
    INC R3
    JMP CONTAGEM


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
    MOV R5,#2

    LOOP2:
    MOV TMOD,#00000001B
    MOV TL0,#LOW(TEMP1S)
    MOV TH0,#HIGH(TEMP1S)
    SETB TR0
    JNB TF0,$
    CLR TR0
    CLR TF0
    DJNZ R5,LOOP2
    RET

TABELA:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fH,06H,5bH,4fH,66H,6dH,7dH,07H,7fH,67H,77H,7cH,39H,5eH,79H,71H

END
