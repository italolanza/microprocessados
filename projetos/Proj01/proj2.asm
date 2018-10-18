TECLADO equ 0FFE3H
MOTOR equ 0FFE6H
TECLAAUX equ 11H

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

    TR3: CJNE A,#80H,TR4 ; Pressionou tecla "3"?
    MOV P1,#03H
    LJMP TECLADO_SAIR

    TR4: CJNE A,#04H,TR5 ; Pressionou tecla "A"?
    MOV P1,#0AH
    LJMP TECLADO_SAIR

    TR5: CJNE A,#10H,TR6 ; Pressionou tecla "4"?
    MOV P1,#04H
    LJMP TECLADO_SAIR

    TR6: CJNE A,#01H,TR7 ; Pressionou tecla "5"?
    MOV P1,#05H
    LJMP TECLADO_SAIR

    TR7: CJNE A,#08H,TR8 ; Pressionou tecla "6"?
    MOV P1,#06H
    LJMP TECLADO_SAIR

    TR8: CJNE A,#02H,TR9_A ; Pressionou tecla "B"?
    MOV P1,#0BH
    LJMP TECLADO_SAIR

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

    TR11: CJNE A,#08H, TR12 ; Pressionou tecla "9"?
    MOV P1,#09H
    LJMP TECLADO_SAIR

    TR12: CJNE A,#02H, TR13 ; Pressionou tecla "C"?
    MOV P1,#0CH
    LJMP TECLADO_SAIR

    TR13: CJNE A,#40H, TR14 ; Pressionou tecla "E"?
    MOV P1,#0EH
    LJMP TECLADO_SAIR

    TR14: CJNE A,#20H, TR15 ; Pressionou tecla "0"?
    MOV P1,#00H
    LJMP TECLADO_SAIR

    TR15: CJNE A,#80H, TR16 ; Pressionou tecla "F"?
    MOV P1,#0FH
    LJMP TECLADO_SAIR

    TR16: CJNE A,#04H, TR17 ; Pressionou tecla "D"?
    MOV P1,#0DH

    TR17: LJMP TECLADO_SAIR

    ;Esta rotina evita repetição de teclas TECLADO_SAIR:
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

END