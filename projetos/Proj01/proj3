org 00h

;mov a,#00h ;;DesativaMotor
;mov dptr,#0ffe6h
;movx @dptr,a


MOV R0,#0
MOV R1,#0
MOV R2,#0
MOV R3,#0

Reg4:MOV A,#9
	 MOV R4,A
	 ;todoteclado

Reg5:MOV A,#9
	 MOV R5,A
	 ;todoteclado
Reg6:MOV A,#9
	 MOV R6,A
	 ;todoteclado
Reg7:MOV A,#9
	 MOV R7,A
	 ;todoteclado

cont4: clr C
      MOV A,R4
	  SUBB A,#01h
	  JC cont5
      MOV R4,A
	  JMP DReg0

cont5: clr C
      MOV A,R5
	  SUBB A,#01h
	  JC cont6
      MOV R5,A
	  MOV R4,#09h
	  JMP DReg0


cont6: clr C
      MOV A,R6
	  SUBB A,#01h
	  JC cont7
      MOV R6,A
	  MOV R4,#09h
      MOV R5,#09h
	  JMP DReg0

cont7: clr C
      MOV A,R7
	  SUBB A,#01h
	  JC fim
      MOV R7,A
	  MOV R4,#09h
      MOV R5,#09h
      MOV R6,#09h
	  JMP DReg0


DReg0: MOV A,R0
	   ADD A,#1
	   MOV B,A
	   SUBB A,#10
	   JZ DReg1
	   MOV R0,B
	   acall Delay
	   JMP cont4

DReg1: 
       MOV A,R1
       ADD A,#1
       MOV B,A
	   SUBB A,#10
	   JZ DReg2
	   MOV R0,#0
	   MOV R1,B
	   JMP cont4

DReg2: MOV A,R2
       ADD A,#1
       MOV B,A
	   SUBB A,#10
	   JZ DReg3
       MOV R0,#0
       MOV R1,#0
	   MOV R2,B
	   JMP cont4

DReg3: MOV A,R3
       ADD A,#1
       MOV B,A
	   SUBB A,#10
	   JZ fim
       MOV R0,#0
       MOV R1,#0
	   MOV R2,#0
	   MOV R3,B
	   JMP cont4

fim :
	MOV A,#01h   ;;DISPLAY 01
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R3
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a

 	MOV A,#02h   ;;DISPLAY 02
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R2
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a


 	MOV A,#04h   ;;DISPLAY 03
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R1
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a


 	MOV A,#08h   ;;DISPLAY 04
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R0
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a
SJMP fim

Delay:
	mov 40h, #255

display:
	;;TODO DISPLAY
 	MOV A,#01h   ;;DISPLAY 01
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R3
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a

 	MOV A,#02h   ;;DISPLAY 02
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R2
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a


 	MOV A,#04h   ;;DISPLAY 03
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R1
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a


 	MOV A,#08h   ;;DISPLAY 04
 	MOV DPTR, #0ffc1h
	MOVX @DPTR,A
	mov dptr,#TAB
	mov a, R0
	movc a, @a + dptr
	mov dptr, #0ffc0h
	movx @dptr,a

	DJNZ 41h,display
	DEC 40h
	MOV A,40H
	JZ saida
	MOV 41h, #255
	SJMP display
saida:
ret


TAB: 	DB 	3Fh, 06h, 5Bh, 4Fh, 66h, 6Dh, 7Dh, 07h, 7Fh, 67h, 77h, 7Ch, 39h, 5Eh, 79h, 71h

END