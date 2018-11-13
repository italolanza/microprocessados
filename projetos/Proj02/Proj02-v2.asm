TEMP          EQU (65535 - 100)
DISPLAY_IR equ 0FFC2H ;escrita instrucao no display.
DISPLAY_DR equ 0FFD2H ;escrita dado no display
DISPLAY_BF equ 0FFE2H ;leitura instrucao do display.
DISPLAY_R equ 0FFF2H ;leitura dado do display
DISPLAY_CONFIGURACAO equ 038H ; configura o display pra funcionar com 8 bits, usando 2 linhas e caracteres com tamanho 5x7 pontos 
DIPSPLAY_CONFIGURACAO_ENTRY_MODE EQU 06H; configura o entry mode do display
DISPLAY_CONFIGURACAO_DISPLAY EQU 0CH; configura on/off control 	
DISPLAY_POS_INICIAL equ 80H ; posicao inical da memoria DDRAM do display (ou posicao zero do cursor)
MOTOR equ 0FFE6H



ORG 0h

Zera_Motor:
	CLR A ; Limpando A
	MOV P1,A; Zerando o Motor.... (Evitar aquecimento e rui?do!!) MOV A,#00H
	MOV DPTR,#MOTOR
	MOVX @DPTR,A
 	
Init_DISPAY: 	
	MOV DPTR, #DISPLAY_IR
	MOV A, #DISPLAY_CONFIGURACAO
	MOVX @DPTR, A
	ACALL DISPLAY_BUSY
	MOV DPTR, #DISPLAY_IR
	MOV A, #DIPSPLAY_CONFIGURACAO_ENTRY_MODE
	MOVX @DPTR, A
	ACALL DISPLAY_BUSY
	MOV DPTR, #DISPLAY_IR
	MOV A, #DISPLAY_CONFIGURACAO_DISPLAY
	MOVX @DPTR, A
	ACALL DISPLAY_BUSY

	LJMP ANIMATION
	
WRITE_CHAR:
	;MOV R0, #5H
	;ACALL DISPLAY_POS
	MOV DPTR, #DISPLAY_DR
	ACALL TEMPO
	;MOV A, #'D'
	MOVX @DPTR, A
	ACALL TEMPO
	;JMP WRITE_CHAR

	RET
	
	
DISPLAY_POS:
	PUSH DPL
	PUSH DPH
	MOV DPTR, #DISPLAY_IR
	POP DPH
	POP DPL
	PUSH ACC
	ACALL TEMPO
	CLR A
	MOV A, #DPL
	;ADD A, R0 ;LOCAL ONDE FICA A POSICAO DO CURSOR QUE VAI SER USADO APRA ESCRITA
	MOVX @DPTR, A
	POP ACC
	RET

DISPLAY_BUSY:
        PUSH ACC
	MOV DPTR,#DISPLAY_BF ;Verifica se o Display est? ocupado
	MOVX A,@DPTR
	JB ACC.7, DISPLAY_BUSY
	POP ACC
	RET

ANIMATION:

	MOV A, #'A' ; Move letra A para o acumulador
	MOV DPTR, #PATH_ANIMATION

WRITE_STR:
	ACALL DISPLAY_POS
	PUSH DPL
	PUSH DPH
	ACALL WRITE_CHAR
	POP DPH
	POP DPL
	INC DPTR
	PUSH ACC
	;MOV A, #' '
	;ACALL WRITE_CHAR
	MOVC A, @A+DPTR
	ACALL TEMPO
	CJNE A, #00, RETURN_ACC
	LJMP ANIMATION

RETURN_ACC:
	POP ACC
	LJMP WRITE_STR

TEMPO:		;rotina de tempo(2000us)
    MOV R0, #10
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

	
;Cursor_Ps: db 00H, 01H, 02H, 03H, 04H, 05H, 06H, 07H, 08H, 09H, 0AH, 0BH, 0CH, 0DH, 0EH, 0FH, 40H, 41H, 42H, 43H, 44H, 45H, 46H, 47H, 48H, 49H, 4AH, 4BH, 4CH, 4DH, 4EH, 4FH,10H, 11H, 12H, 13H, 14H, 15H, 16H, 17H, 18H, 19H, 1AH, 1BH, 1CH, 1DH, 1EH, 1FH, 50H, 51H, 52H, 53H, 54H, 55H, 56H, 57H, 58H, 59H, 5AH, 5BH, 5CH, 5DH, 5EH, 5FH

PATH_ANIMATION: db 82, 133, 192, 135, 220, 198, 151, 00

END