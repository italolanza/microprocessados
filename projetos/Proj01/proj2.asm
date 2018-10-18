TEMP EQU (65535 - 50000)
TECLADO equ 0FFE3H
MOTOR equ 0FFE6H
TECLAAUX equ 11H
EN_DIPSLAY equ 0ffe1h 
DADOS_DISPLAY equ 0ffe0h

ORG 0h

INICIO:
    CLR A ; Limpando A
    MOV P1,A
    ; Zerando o Motor.... (Evitar aquecimento e ruído!!) MOV A,#00H
    MOV DPTR,#MOTOR
    MOVX @DPTR,A

    CALL TECLADO_READ
    AJMP LOOP

;Inicia a varredura do teclado
TECLADO_READ:
    MOV A,#80H
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    MOVX A,@DPTR
    CJNE A,#40H,TRT2; Pressionou tecla "1"?
    MOV P1,#01H
    LJMP TECLADO_SAIR

    TRT2: CJNE A,#20H,TR3 ; Pressionou tecla "2"?
    MOV P1,#02H
    LJMP TECLADO_SAIR

    TR3: CJNE A,#80H,TR5 ; Pressionou tecla "3"?
    MOV P1,#03H
    LJMP TECLADO_SAIR

    TR5: CJNE A,#10H,TR6 ; Pressionou tecla "4"?
    MOV P1,#04H
    LJMP TECLADO_SAIR

    TR6: CJNE A,#01H,TR7 ; Pressionou tecla "5"?
    MOV P1,#05H
    LJMP TECLADO_SAIR

    TR7: CJNE A,#08H,TR9_A ; Pressionou tecla "6"?
    MOV P1,#06H
    LJMP TECLADO_SAIR

    ;TR8: CJNE A,#02H,TR9_A ; Pressionou tecla "B"?
    ;MOV P1,#0BH
    ;LJMP TECLADO_SAIR

    TR9_A: CJNE A,#06H,TR9_B
    MOV A,#TECLAAUX
    LJMP TECLADO_SAIR

    TR9_B: MOV A,#40H ;Ativar a linha 7
    MOV DPTR,#TECLADO
    MOVX @DPTR,A
    MOVX A,@DPTR
    CJNE A,#10H,TR10 ; Pressionou tecla "7"?
    MOV P1,#07H
    LJMP TECLADO_SAIR

    TR10: CJNE A,#01H, TR11 ; Pressionou tecla "8"?
    MOV P1,#08H
    LJMP TECLADO_SAIR

    TR11: CJNE A,#08H, TR14 ; Pressionou tecla "9"?
    MOV P1,#09H
    LJMP TECLADO_SAIR

    TR14: CJNE A,#20H, TR17 ; Pressionou tecla "0"?
    INC R1
    MOV P1,#00H
    LJMP TECLADO_SAIR

    TR17: LJMP TECLADO_SAIR
    CJNE R1, #00000000, TECLADO_READ
    ; aqui devo fazer o display apareceer o numero

    LJMP TECLADO_READ

    ;Esta rotina evita repetição de teclas
TECLADO_SAIR:
    PUSH ACC
    MOV A,#80H
    MOV DPTR,#TECLADO MOVX @DPTR,A

    TECLADO_REPEAT_1:
    MOVX A,@DPTR
    CJNE A,#00H,TECLADO_REPEAT_1

    TECLADO_SAIR_2:
    MOV A,#40H
    MOV DPTR,#TECLADO MOVX @DPTR,A
    TECLADO_REPEAT_2:
    MOVX A,@DPTR
    CJNE A,#00H,TECLADO_REPEAT_2 POP ACC
    RET

TEMPO:		;rotina de tempo(20x50.000)
    MOV R0,#20

    LOOP:
    MOV TMOD,#00000001B
    MOV TL0,#LOW(TEMP)
    MOV TH0,#HIGH(TEMP)
    SETB TR0
    JNB TF0,$
    CLR TR0
    CLR TF0
    DJNZ R0,LOOP
    RET

tabela:
	; 0	  1	  2	  3   4   5   6   7   8   9   A   B   C   D   E   F
db	 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h

END
